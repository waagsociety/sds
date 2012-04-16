#has name, names/uri is referenced in PersonalContextAuthorization
#name/uri will also be used in oauth.
#this is a scope definition
class PersonalContextAuthorizationScope < CouchRest::Model::Base
  unique_id :id
  # property <name>
  
end
