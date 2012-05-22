require 'personal_context_authorization.rb'
class PersonalContext < CouchRest::Model::Base
  collection_of :personal_context_authorizations
  property :context, String 
end
