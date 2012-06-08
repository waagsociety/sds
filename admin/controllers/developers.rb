Admin.controllers :developers do

  get :index, :map => "/developers" do
    
    @account = current_account
    
    @contexts = SharedDataContext.all #TODO: you can only edit/delete the ones that you manage..
    #this is the correct way to do a search on account!
    #FIXME: should be a search the id only, the account should not be saved nested fashion here
    @applications = SharedDataApplication.by_account(:key => @account, :descending => true)
    render "developer/index"
  end
end
