require 'teststrap.rb'
require 'authorizationstate'
require 'pp'

#application is setup with access to context: taxi_data
#application is tested for succesfull access to taxi_data
#application is denied access to energy_data
context "taxi app" do
	setup { SharedDataApplication.new(:name => "taxiapp", :description => "taxi application") }
		
	hookup do
		topic.save
	end	
	asserts("taxi app save"){!topic.new?}
	
	context "with taxi context" do

		hookup do 
			sdc = SharedDataContext.new(:name => "taxi_data", :public_validation => nil, :private_validation => nil, :anonimization => nil)
			sdc.save
			topic.shared_data_contexts << sdc
			topic.save
			#sdc.destroy
		end

		asserts("taxi app has context"){topic.shared_data_contexts.length == 1}
	
		asserts("has taxi context") do
			topic.is_authorized_for "taxi_data"
		end	
		denies("has energy context") do
			topic.is_authorized_for "energy_data"			
		end

	end

	teardown do
		puts topic.uri

		#destroy contexts too
		topic.shared_data_contexts.each do |context|
			context.destroy
		end
			
		topic.destroy
	end 
end


#model implications:
# 1. create & save personal_context_authorization, as a separate document, validate client and resource owner exist, and scope is valid
#remark: we don't know in advance who is the resource_owner that will be granting access to the client
context "taxi client initiates authorization request" do

	setup{SharedDataApplication.new(:name => "taxiapp", :description => "taxi application")}
	
	hookup do
	  sdc = SharedDataContext.new(:name => "taxi_data", :public_validation => nil, :private_validation => nil, :anonimization => nil)
	  sdc.save
	  topic.shared_data_contexts << sdc
	  topic.save
	end

	setup do
	  #TODO: change to normal constructor
	  PersonalContextAuthorization.new(:client => topic, :scope => PersonalContextAuthorizationScope.new(:context => topic.shared_data_contexts.first.name, :operations =>["read","write"], :level => ["private","public"]), :state => AuthorizationState::PENDING_REQUEST, :request_token => "4sdafadsf2334")
	 end
	 
	hookup do
	  topic.save
	  puts topic.uri
	 end

	asserts_topic.kind_of(PersonalContextAuthorization)
	asserts("pca saved"){!topic.new?}
	asserts("pca has request token"){topic.request_token != nil}


	# 2. assume logged in user, change state of personal_context_authorization; using grant/deny defs; update authorization state
	hookup do
		#1. create and save account

		u = Account.find_by_email("taco+developer@waag.org")

		puts "account found"
		
		topic.state = AuthorizationState::ACCESS_GRANTED
		topic.resource_owner = u
		topic.save
		puts "topic saved"


		store = PersonalStore.new(:account => u)
		store.save			
		puts "store created"

		pc = PersonalContext.new
		pc.authorizations << topic
		
		pc.context = topic.scope.context
		store.contexts << pc
		
		#add a document to the store, which should be saved in its own database
		store.save

		doc = store.personal_documents.new(:context =>topic.scope.context, :date => DateTime.now, :body => "blablabla_encrypted")
		doc.save
		
	end

	#3. validate access to store/personal_context by application
	#find the shared data application that was saved earlier
	u = Account.find_by_email("taco+developer@waag.org")
	asserts("user exists"){u != nil}
	store = PersonalStore.find_by_account_id(u.id)
	asserts("store exists"){store != nil}
	app = SharedDataApplication.find_by_name("taxiapp")
	asserts("app exists"){app != nil}
	asserts("access to docs"){store.list(app,app.shared_data_contexts.first.name).length > 0} #should return something
end
 


#then in other unit test, expand this to oauth scenario using server requests etc.:
#1. application requests request_token for user context identifier/scope combination, receives expiring request_token
#2. redirected user grants/denies access_request, with provided request token
#3. application requests access with access_token (is denied/granted)
