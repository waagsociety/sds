require 'account.rb'
require 'personal_context.rb'
require 'personal_document.rb'
require 'exceptions.rb'

include Exceptions

#the personal store should proxy all personal documents into a separate database
class PersonalStore < CouchRest::Model::Base
  
  unique_id :id
  belongs_to :account, Account
  property :personal_contexts, [PersonalContext] #should be embedded

  #proxy_database_method :store_name 
  #proxy_for :personal_documents
 
  view_by :account_id 

  #create the proxy database
  #use this manually
  def proxy_database
	#this creates the personal database if it doesn't exist
	CouchRest.database! "http://taco:couchdb@localhost:5984/ps_#{id}"
  end

  #store method
  #validates validation and anonimization are in place
  #expects data as hash
  def save(data,context)
	sc = SharedDataContext.find_by_name context  #not very efficient
	update_design_for sc	
	
	pd = CouchRest::Document.new
	pd.database = proxy_database

	#copy data in to document
	data.each do |key,value|
		puts "#{key}:#{value}"
		pd["#{key}"] = value
	end

	#make sure these are correct	
	pd[:type] = context
	pd[:date] = DateTime.now
	puts pd.new?
	
	begin
		puts "saving personal document"
		pd.save false
	rescue => e
		puts "NOT SAVED: #{e.response}"
		#TODO: properly handle this stuff
	end
  end

  #add/update the design document in this personal store for a given context 
  def update_design_for(shared_context)
	
	design = nil 

	begin
		design = proxy_database.get("_design/#{shared_context.name}")
	rescue RestClient::ResourceNotFound => nfe
		design = CouchRest::Design.new
		design.name = shared_context.name
		design.database = proxy_database
	end

	if(design != nil)
		#update some stuff, from the shared_context
		#1. update the personal validation document
		if(design[:validate_doc_update] != shared_context.private_validation)
			design[:validate_doc_update] = shared_context.private_validation
			design[:views] = Hash.new
			design[:views][:anonimization] = Hash.new
			design[:views][:anonimization][:map] = shared_context.anonimization
			puts "saving design doc"
			design.save
		end
	end
  end

  #return all personal documents for a given context,but only if authorized
  def list(client, context)
	
		#first check if this store contains a personalcontext with the context name
	puts "authenticating: #{client.name}, id: #{client.id} for #{context}"

	context = self.personal_contexts.find_all{ |item| item.context == context}.last
		
	if(context == nil)
		raise StoreError, "Specified context not found in store"
	else
		puts "found context, checking authorizations"
		puts "context: #{context}"

		#second check if that context contains an authorization with the id of the given client
		context.personal_context_authorizations.each do |auth|
			puts "found; #{auth.client_id} state: #{auth.state}"
		end

		auth = context.personal_context_authorizations.find_all{|item| item.client_id == client.id}.last
		if(auth == nil || auth.state != AuthorizationState::ACCESS_GRANTED )
			raise StoreAuthenticationError, "Specified client not authorized for specified context: #{auth.state}"
		else
			puts "found authorization, checking scope"

			#third check if the scope of the authorization contains the read scope
			if(auth.scope.level.include?("private") && auth.scope.operations.include?("read"))
				
				docs = self.personal_documents.by_context(:context => context, :descending => true)
				bodies = docs.each.collect {|doc| doc.body}
				return bodies 

			else
				raise StoreAuthenticationError, "Specified client not authorized for personal read scope"
			end
		end
	end	
		
  end
end

