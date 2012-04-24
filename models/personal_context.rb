require 'personal_context_authorization.rb'
class PersonalContext 
  include CouchRest::Model::Embeddable

  property :context, SharedDataContext
  property :authorizations, [PersonalContextAuthorization]#list of external documents
  property :document_uris, [String]
end
