#contains list of uris to shared_data_contexts, that it is authorized to access

require 'account.rb'
class SharedDataApplication < CouchRest::Model::Base

  unique_id :id
  property :name, String
  property :description, String
  collection_of :shared_data_contexts
  property :account, Account

  view_by :name
  view_by :account
  #check if context is part of the shared_data_contexts collection

   # Validations
   validates_presence_of     :name, :description
   validates_uniqueness_of   :name
 


  #TODO: change check to the private internal id of the application instead, 
  #the application id should never be visible outside the application
  #change;   
  def is_authorized_for(context)
	result = shared_data_contexts.find_all{|item| item.name == context }	
	return result != nil && result.length > 0 
  end 
  #application is allowed to use short-lived authorized_request_tokens for this context 
end
