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
		pca = PersonalContextAuthorization.find_by_request_token(body[:code])
	        	
		##validate client authorized and that the state is 'in request'
		puts pca.client_id
		puts sda.id
		if(pca != nil && pca.client_id == sda.id && pca.state == AuthorizationState::PENDING_REQUEST)
			
			#everything seems in order
			#let's swap and return the access code
			pca.state = AuthorizationState::ACCESS_GRANTED
			pca.save
			return "{ \"access_token\": \"#{pca.access_token}\" }" #TODO:return expiry/refresh stuff	
		else
			puts 'swap error, personal context authorization not valid'
		end
	  else 
	        puts 'swap error, illegal client'
	  end
	end


	#store a document
	#the token indicates the application, context etc
	post 'store' do
		token = env["HTTP_AUTHORIZATION"].split.last
		
		#make json can parse the data as a hash
		document = params.first.first
		data = JSON.parse document
		#puts data

		pca = PersonalContextAuthorization.find_by_access_token(token)

		if(document != nil && pca != nil && pca.state == AuthorizationState::ACCESS_GRANTED)
			store = PersonalStore.find_by_account_id(pca.resource_owner_id)
			store.save data, pca.scope.context
		else
			"no valid token" #TODO: appropriate error
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
				response << "#{doc.first}\n"
			end
			return response
		else
			"no valid token"#TODO: appropriate error
		end
	end
end
