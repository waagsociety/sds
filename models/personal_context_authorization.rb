#authorization of personal context to one application instance
#embeddable
class PersonalContextAuthorization #< CouchRest::Model::Base
  include CouchRest::Model::Embeddable 

  property :set, PersonalContext
  property :scope, PersonalAuthorizationScope
  property :grantee, SharedDataApplication  
end
