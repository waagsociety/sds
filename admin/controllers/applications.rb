#applications controller

Admin.controllers :applications do

	get :index do
    		@account = current_account
    		@apps = SharedDataApplication.by_account(:account => @account.id, :descending => true)
		render 'applications/index'
	end
	
	get :new do
		@application = SharedDataApplication.new
		render 'applications/new'
	end
	
	post :create do
	    @applications = SharedDataApplication.new(params[:application])
	    if @application.save
	      flash[:notice] = 'Shared Data Application was successfully created.'
	      redirect url(:applications, :edit, :id => @context.id)
	    else
	      render 'applications/new'
	    end
	end

	#TODO: update, edit, destroy	
end
