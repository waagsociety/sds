Admin.controllers :developers do

  get :index, :map => "/developers" do
    
    @account = current_account
    
    @contexts = SharedDataContext.all #TODO: you can only edit/delete the ones that you manage..

    @apps = SharedDataApplication.by_account(:account => @account.id, :descending => true)
    render "developer/index"
  end
end
