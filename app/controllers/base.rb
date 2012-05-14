Sdsapp.controllers :base do

  get :index, :map => "/" do
    "SHARED DATA SERVICE"
  end

  get 'oauth/authorize', :map => '/admin/oauth/authorize' do
	  #store parameters in session
	  session[:oauth_client_id] = params[:client_id] #save arguments in session
	  
	  #these are for extra security it seems
	  session[:oauth_redirect_uri] = params[:redirect_uri]
	  session[:oauth_scope] = params[:scope]
	  session[:return_to] = '/admin/oauth/authorize'

	  redirect 'admin/oauth/authorize' #redirect, authenticates user if needed
  end

end
