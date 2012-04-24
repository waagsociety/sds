#this is a scope definition
class PersonalContextAuthorizationScope
include CouchRest::Model::Embeddable
  
  property :context, String
  property :name, String #e.g. taxi_public_readonly, taxi_private_readwrite, to be used by openauth
  #TODO change to readonly calculated value
  property :operations, [String] #crud
  property :level, [String] #public/private, or just one
  
end
