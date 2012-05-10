require 'personal_context.rb'
require 'personal_document.rb'
require 'exceptions.rb'

include Exceptions

#the personal store should proxy all personal documents into a separate database
class PersonalStore < CouchRest::Model::Base
  
  unique_id :id
  belongs_to :account, Account
  property :contexts, [PersonalContext] #should be embedded

  proxy_database_method :store_name 
  proxy_for :personal_documents
 
  view_by :account_id 

  def proxy_database
	CouchRest.database! "http://taco:couchdb@localhost:5984/ps_#{id}"
  end

  #return all personal documents for a given context,but only if authorized
  def list(client, context)
	#first check if this store contains a personalcontext with the context name
	puts "authenticating: #{client.name}, id: #{client.id} for #{context}"

	context = self.contexts.find_all{ |item| item.context == context}.last
	
	if(context == nil)
		raise StoreError, "Specified context not found in store"
	else
		puts "found context, checking authorizations"

		#second check if that context contains an authorization with the id of the given client
		context.authorizations.each do |auth|
			puts "found; #{auth.client_id} state: #{auth.state}"
		end

		auth = context.authorizations.find_all{|item| item.client_id == client.id}.last
		if(auth == nil || auth.state != AuthorizationState::ACCESS_GRANTED )
			raise StoreAuthenticationError, "Specified client not authorized for specified context: #{auth.state}"
		else
			puts "found authorization, checking scope"

			#third check if the scope of the authorization contains the read scope
			if(auth.scope.level.include?("private") && auth.scope.operations.include?("read"))
				
				docs = self.personal_documents.by_context(:context => context, :descending => true)
				bodies = docs.each.collect {|doc| doc.body}
				bodies.each do | doc |
					puts doc #and this is all that should be returned
				end
				return bodies 

			else
				raise StoreAuthenticationError, "Specified client not authorized for personal read scope"
			end
		end
	end	
		
  end
end

