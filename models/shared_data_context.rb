#contains list of uri's / query to public documents
#contains design documents for this context
#reused by multiple shared applications

class SharedDataContext  < CouchRest::Model::Base
   unique_id :id
   property :name, String
   property :public_validation, String #Design document json
   property :private_validation, String #Design document json
   property :anonimization, String #Design document json, contains js anon function
  
end
