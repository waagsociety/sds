#embedded in personal store
class PersonalContext 
  include CouchRest::Model::Embeddable

  #property :store, PersonalStore
  property :context, SharedDataContext
  property :authorizations, [PersonalContextAuthorization]
  property :document_uris, [String]
end
