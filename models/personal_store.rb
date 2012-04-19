require 'personal_context.rb'
class PersonalStore < CouchRest::Model::Base
  unique_id :id
  belongs_to :account
  property :contexts, [PersonalContext]
end

