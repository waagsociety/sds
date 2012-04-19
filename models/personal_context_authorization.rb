#authorization of personal context to one application instance
#embeddable
require 'personal_context_authorization_scope.rb'
require 'shared_data_application.rb'

class PersonalContextAuthorization #< CouchRest::Model::Base
  include CouchRest::Model::Embeddable 

  property :scope, PersonalContextAuthorizationScope
  property :grantee, SharedDataApplication  
end
