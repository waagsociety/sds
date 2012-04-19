#embedded in personal store
require 'personal_context_authorization.rb'
class PersonalContext 
  include CouchRest::Model::Embeddable

  property :context, SharedDataContext
  property :authorizations, [PersonalContextAuthorization]
  property :document_uris, [String]
end
