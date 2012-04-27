require 'personal_context.rb'
require 'personal_document.rb'

#the personal store should proxy all personal documents into a separate database
class PersonalStore < CouchRest::Model::Base
  
  unique_id :id
  belongs_to :account, Account
  property :contexts, [PersonalContext] #should be embedded

  proxy_database_method :store_name 
  proxy_for :personal_documents

  def proxy_database
	CouchRest.database! "http://taco:couchdb@localhost:5984/ps_#{id}"
  end
end

