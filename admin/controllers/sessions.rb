Admin.controllers :sessions do

  get :new do
	  
    render "/sessions/new", nil, :layout => false
  end

  post :create do

     session.each do | key |
	  puts "#{key} #{session[key]}"
     end

    if account = Account.authenticate(params[:email], params[:password])
      set_current_account(account)
      if(session[:return_to] != nil)
	      redirect session[:return_to] 
      else
      	redirect url(:base, :index)
      end
    elsif Padrino.env == :development && params[:bypass]
      account = Account.first
      set_current_account(account)
	if(session[:return_to] != nil)
	      redirect session[:return_to] 
      else
      	redirect url(:base, :index)
      end
    else
      params[:email], params[:password] = h(params[:email]), h(params[:password])
      flash[:warning] = "Login or password wrong."
      redirect url(:sessions, :new)
    end
  end

  delete :destroy do
    puts "destroy"
    set_current_account(nil)
    session[:return_to] = nil
    redirect url(:sessions, :new)
  end
end
