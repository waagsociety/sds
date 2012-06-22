case Padrino.env
  when :development then db_name = 'http://localhost:5984/sdsapp_development'
  when :production  then db_name = 'sdsapp_production'
  when :test        then db_name = 'sdsapp_test'
end

CouchRest::Model::Base.configure do |conf|
  conf.model_type_key = 'type' # compatibility with CouchModel 1.1
  conf.database = CouchRest.database!(db_name)
  puts db_name 
  #conf.environment = Padrino.env
  # conf.connection = {
  #   :protocol => 'http',
  #   :host     => 'localhost',
  #   :port     => '5984',
  #   :prefix   => 'sdsapp',
  #   :suffix   => 'development',
  #   :join     => '_',
  #   :username => 'admin',
  #   :password => 'couchdb'
  # }
end
