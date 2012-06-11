Admin.controllers :users do

  get :index, :map => "/users" do
	@account = current_account
	store = PersonalStore.find_by_account_id(@account.id)
	@contexts = store.personal_contexts
    	#@applications = SharedDataApplication.by_account(:key => @account, :descending => true)
	render 'user/index'
  end

end
