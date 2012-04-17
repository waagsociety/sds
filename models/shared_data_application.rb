#contains list of uris to shared_data_contexts, that it is authorized to access
class SharedDataApplication < CouchRest::Model::Base

  unique_id :id
  property :name, String
  property :description, String
  collection_of :shared_data_contexts
  #property :contexts, [SharedDataContext] #derived from list of uri's
  
end
