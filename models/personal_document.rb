#documents that belong to a store for a specific context
require 'personal_store.rb'

class PersonalDocument < CouchRest::Model::Base
	property :context
	property :body
	property :date

	proxied_by :personal_store
	
	design do
		view :by_date
		view :by_context
	end
end
