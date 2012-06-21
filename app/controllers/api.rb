#api controller
Sdsapp.controllers :api do
	
	#swap request token for authentication token
	post 'oauth/token' do
	
	  #1. check params, client id / secret combination
	  body = JSON.parse params.first.first	  
	  sda = SharedDataApplication.get body["client_id"]
	  
	 ##validate client id in authorization
	  if(body["grant_type"] == "authorization_code" && sda != nil && sda.secret == body["client_secret"])
	  	
		#2. find authorization for request token
		puts "provided code: #{body["code"]}" 
		pca = PersonalContextAuthorization.find_by_request_token(body["code"])
		puts "found pca, state #{pca.state},provided: #{body[:code]} token: #{pca.request_token}"		
		##validate client authorized and that the state is 'in request'
		puts pca.client_id
		puts sda.id
		if(pca != nil && pca.client_id == sda.id && pca.state == AuthorizationState::PENDING_REQUEST)
			
			#everything seems in order
			#let's swap and return the access code
			pca.state = AuthorizationState::ACCESS_GRANTED
			pca.save
			return "{ \"access_token\": \"#{pca.access_token}\" }" 
			#TODO:return expiry/refresh stuff	
		else
		 	halt 422, "invalid or outdated  authorization request"	
		end
	  else 
		halt 422, "invalid request"
	  end
	end


	#store a document
	#the token indicates the application, context etc
	post 'store' do
		token = env["HTTP_AUTHORIZATION"].split.last
		
		#make json can parse the data as a hash
		document = params.first.first
		data = JSON.parse document
		puts data.inspect

		pca = PersonalContextAuthorization.find_by_access_token(token)
	
		if(document != nil && pca != nil && pca.state == AuthorizationState::ACCESS_GRANTED)
			store = PersonalStore.find_by_account_id(pca.resource_owner_id)
			
			#1.store clear text document in temp db
			#id = store.persist(data, pca.scope.context)
			id = TempDatabase.persist(data,pca.scope.context)

			#2.create anonymized version of the document, by transformation
			anonimized_data = TempDatabase.anonimize(pca.scope.context,id)
			
			#delete temp database
		 	TempDatabase.proxy_database(pca.scope.context).delete!	
				
			#get reference to the context store
			sdc = SharedDataContext.find_by_name pca.scope.context
			cstore = ContextStore.find_by_shared_data_context_id sdc
			if(cstore == nil)
				cstore = ContextStore.new(:shared_data_context => sdc)
				cstore.save #save the store document
			end

			cstore.persist anonimized_data	#save some public data in the context store
			#3. now encrypt the personal data
			#
			client = SharedDataApplication.get(pca.client_id)
			puts client.public_key
			#3a. create random symmetric encryption key
			secret_key = SecureRandom.hex(11) 
			puts "secret key: #{secret_key}"

			#3b. symetrically encrypt the message
			
			data.each do |key,value|
				if(key == "_id")
					next
				end
				data[key] = Base64.encode64(Encryptor.encrypt(value, :key => secret_key))
			end
			puts "encrypted message: #{data.inspect}"

			#3c. encrypt symmetric key with public key of client
			public_key = OpenSSL::PKey::RSA.new client.public_key
			ciphertext = public_key.public_encrypt(secret_key)
			safe = Base64.encode64(ciphertext)
			puts "encrypted key: #{safe}"
			data["cipher"] = safe
			
			#3d.persist the encrypted data
			store.persist(data,pca.scope.context)

		else
			halt 422, "no valid token" 
		end
	end

	get 'all' do
		token = env["HTTP_AUTHORIZATION"].split.last
		pca = PersonalContextAuthorization.find_by_access_token(token)

		if(pca != nil && pca.state == AuthorizationState::ACCESS_GRANTED)
			store = PersonalStore.find_by_account_id(pca.resource_owner_id)
			application = SharedDataApplication.get(pca.client_id)
		        list = store.list(application, pca.scope.context)
			response = ""
			list.each do |doc|
				json = doc.to_json	
				response << "#{json}\n"
			end
			return response
		else
			halt 422, "no valid token"
		end
	end

	get 'context/:name' do
		sdc = SharedDataContext.find_by_name(params[:name])
		if(sdc != nil)
			cstore = ContextStore.find_by_shared_data_context_id sdc
			list = cstore.list
			response = ""
			list.each do |doc|
				response << "#{doc}\n"
			end
			return response
		else
			halt 404, "context not found"
		end
	end
end
