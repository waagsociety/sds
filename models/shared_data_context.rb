#contains list of uri's / query to public documents
#contains design documents for this context
#reused by multiple shared applications

class SharedDataContext  < CouchRest::Model::Base
   
   #properties
   unique_id :id
   property :name, String
   property :public_validation, String #Design document json
   property :private_validation, String #Design document json
   property :anonimization, String #Design document json, contains js anon function

   # Validations
   validates_presence_of     :name, :public_validation, :private_validation, :anonimization
   validates_uniqueness_of   :name
  
end
