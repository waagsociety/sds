Admin.controllers :base do

  get :index, :map => "/" do
    

    if(current_account.role == "dataowner")
    	redirect "admin/users"	
    end

    if(current_account.role == "developer")
        redirect "admin/developers"
    end
    render "base/index"
  end
end
