#this is a scope definition
class PersonalContextAuthorizationScope
include CouchRest::Model::Embeddable
  property :name, String #e.g. taxi_public_readonly, taxi_private_readwrite, to be used by openauth
  property :operations, [String] #crud
  property :accessLevel, String #public/private
  
end
