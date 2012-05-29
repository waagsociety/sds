require 'shared_data_context.rb'
require 'exceptions.rb'

include Exceptions

class ContextStore < CouchRest::Model::Base

	unique_id :id
	belongs_to :shared_data_context, SharedDataContext

	view_by :shared_data_context_id

	#TODO: refactor to yml or somethinga
	#TODO: maybe change url to name of context?	
	def proxy_database
		CouchRest.database! "http://taco:couchdb@localhost:5984/cs_#{id}"
	end

	#this data comes from the anonimization function
	def persist(data)
		update_design_for self.shared_data_context
		
		d = CouchRest::Document.new
		d.database = proxy_database

		#copy data in to document
		data.each do |key,value|
			d["#{key}"] = value
			puts "added: #{key}"
		end
		d[:type] = self.shared_data_context.name
		d[:date] = DateTime.now

		begin
			d.save false
		rescue => e
			puts "NOT SAVED: #{e.response}"
			#TODO: properly handle this stuff
		end#
	end

	#just return all rows in the public database
	def list
		docs = proxy_database.view("#{shared_data_context.name}/all")["rows"]
		return docs
  	end

	#add/update the design document in this personal store for a given context 
	def update_design_for(shared_context)

		design = nil 

		begin
			design = proxy_database.get("_design/#{shared_context.name}")
		rescue RestClient::ResourceNotFound => nfe
			design = CouchRest::Design.new
			design.name = shared_context.name
			design.database = proxy_database
		end

		if(design != nil)
			#update some stuff, from the shared_context
			#1. update the personal validation document
			#TODO: use assoc array syntax
			if(design[:validate_doc_update] != shared_context.private_validation)
				design[:validate_doc_update] = shared_context.public_validation
				design[:views] = Hash.new
				design[:views][:all] = Hash.new
				design[:views][:all][:map] = "function(doc) {if (doc['type'] == '#{shared_context.name}') {emit(doc);}}"
				puts "saving design doc"
				design.save
			end
		end
	end
end
