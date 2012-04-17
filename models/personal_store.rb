class PersonalStore < CouchRest::Model::Base
  unique_id :id
  #property :owner, Account
  belongs_to :account
  property :contexts, [PersonalContext]
end
