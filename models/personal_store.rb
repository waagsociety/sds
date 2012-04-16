class PersonalStore < CouchRest::Model::Base
  unique_id :id
  # property <name>
  property :owner
end
