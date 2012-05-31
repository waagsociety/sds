#oauth authorization controller
Admin.controllers :authorization do

	get :index, :map => 'oauth/authorize/' do
		@account = current_account
		@application = SharedDataApplication.get(session[:oauth_client_id])
		@context = @application.shared_data_contexts.first		
		#TODO: show appriopriate error message (redirect 404) if no client id is provided
		#TODO: validate provided redirect_uri client_id and scope
		#TODO: validate that tokenized scope argument is the same

		render 'oauth/authorize'
	end

	post :create do
		@account = current_account
		@application = SharedDataApplication.get(session[:oauth_client_id])
		@context = @application.shared_data_contexts.first		
		puts "create authorization for user: #{@account.name} and client: #{@application.name}"
		
		#check if personal store for current_account exists, if not create
		store = PersonalStore.find_by_account_id(@account.id)
		if(store == nil)
			store = PersonalStore.new(:account => @account)
			store.save                      
		else
			puts "reusing store"
		end
		
		#check if the personal context exists in the current store, if not create and add it
		pc = store.personal_contexts.find_all{ |item| item.context == @context.name}.last
		if(pc == nil)
			pc = PersonalContext.new
			pc.context = @context.name
			pc.save
			store.personal_contexts << pc
			store.save
		else
			puts "reusing context"
		end
		
		
		#check if a validation for the user/context/application combination already exists..
		#TODO:check if pca gets saved in multiple documents?
		pca = pc.personal_context_authorizations.find_all{ |item| item.client_id == @application.id && item.scope.context == @context.name }.last
		
		if(pca == nil)
			#if not create new validation with request_token as output
			pca = PersonalContextAuthorization.new(
				:client => @application, 
				:scope => PersonalContextAuthorizationScope.new(
					:context => @context.name, 
					:operations =>["read","write"], 
					:level => ["private","public"]), 
				:state => AuthorizationState::PENDING_REQUEST, 
				:request_token => SecureRandom.hex(11),
				:access_token => SecureRandom.hex(11)
			)
			#state stays pending until token is swapped
			pca.save
			pc.personal_context_authorizations << pca 
			store.save
		else
			puts "reusing authorization"
		end
		
		#if save is successful execute the redirect uri
		redirect "http://#{@application.redirect_url}?request_token=#{pca.request_token}"
	end
end	
