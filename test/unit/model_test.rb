require 'teststrap.rb'

#application is denied access to documents specific datacontext
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
			sdc.destroy
		end

		asserts("taxi app has context"){topic.shared_data_contexts.length == 1}

		#context "is denied energy context" do
			#assert energy context in contexts 
		#end

	end

	teardown do
		puts topic.uri
		topic.destroy
	end 
end

#application is denied access to documents specific personal context
#applcation is denied access to documents in specific personal context for a named scope
#application is granted access to documents in a specific datacontext
#application is granted access to documents specific personal context
#application is granted access to documents in a specific personal context for a named scope

