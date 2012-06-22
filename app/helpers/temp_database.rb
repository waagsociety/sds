#temp database
class TempDatabase

	def self.anonimize(context,doc_id)
		doc = proxy_database(context).view("#{context}/anonimization",:key => doc_id)["rows"].first["value"]
  	end

	def self.persist(data,context)
		sc = SharedDataContext.find_by_name context  #not very efficient
		update_design_for sc	

		pd = CouchRest::Document.new
		pd.database = proxy_database(context)

		#copy data in to document
		data.each do |key,value|
			puts "#{key}:#{value}"
			pd["#{key}"] = value
		end

		#make sure these are correct	
		pd[:type] = context
		pd[:date] = DateTime.now
		puts pd.new?

		begin
			puts "saving temporary personal document"
			pd.save false
			id = pd["_id"]
			return id
		rescue => e
			puts "NOT SAVED: #{e.response}"
			#TODO: properly handle this stuff
		end
	end

	def self.update_design_for(shared_context)

		design = nil 

		begin
			design = proxy_database(shared_context.name).get("_design/#{shared_context.name}")
		rescue RestClient::ResourceNotFound => nfe
			design = CouchRest::Design.new
			design.name = shared_context.name
			design.database = proxy_database(shared_context.name)
		end

		if(design != nil)
			#update some stuff, from the shared_context
			#1. update the personal validation document
			if(design[:validate_doc_update] != shared_context.private_validation)
				design[:validate_doc_update] = shared_context.private_validation
				design[:views] = Hash.new
				design[:views][:anonimization] = Hash.new
				design[:views][:anonimization][:map] = shared_context.anonimization
				design[:views][:all] = Hash.new
				design[:views][:all][:map] = "function(doc) {if (doc['type'] == '#{shared_context.name}') {emit(doc);}}"
				puts "saving design doc"
				design.save
			end
		end
	end

	def self.proxy_database(context)
		CouchRest.database! "http://taco:couchdb@localhost:5984/ps_#{context}"
	end
end
