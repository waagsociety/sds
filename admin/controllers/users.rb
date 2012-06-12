Admin.controllers :users do

  get :index, :map => "/users" do
	@account = current_account
	store = PersonalStore.find_by_account_id(@account.id)
	if(store != nil)
		@contexts = store.personal_contexts
	else
		@contexts = Array.new
	end
	render 'user/index'
  end

  #revoke access of a client 
  put :revoke, :map => "/users/revoke" do
	  @account = current_account
	  pca = PersonalContextAuthorization.find_by_access_token(params[:id])
	  if(pca.state == 2)
		 pca.state = 3 #revoke this application
		 pca.save 
	  end 
	  redirect 'admin/users'
  end

  put :grant, :map => "/users/grant" do
	  @account = current_account
	  pca = PersonalContextAuthorization.find_by_access_token(params[:id])
	  if(pca.state != 2)
		 pca.state = 2 #grant access to this application
		 pca.save 
	  end 
	  redirect 'admin/users'
  end
end
