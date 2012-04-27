require 'personal_context_authorization.rb'
class PersonalContext 
  include CouchRest::Model::Embeddable

  property :authorizations, [PersonalContextAuthorization]#list of external documents
  property :context, String 
end
