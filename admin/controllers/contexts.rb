#contexts controller

Admin.controllers :contexts do


	#partial, can't call this one directly	
	#get :index do
    	#	@contexts = SharedDataContext.all #you can only
	#	puts "contexts controller index"
	#	render 'contexts/index'
	#end
	
	get :new do
		@context = SharedDataContext.new
		render 'contexts/new'
	end
	
	post :create do
	    @context = SharedDataContext.new(params[:shared_data_context])
	    if @context.save
	      flash[:notice] = 'Shared Data Context was successfully created.'
	      redirect url(:contexts, :edit, :id => @context.id)
	    else
	      render 'contexts/new'
	    end
	end

        get :edit, :with => :id do
          @context = SharedDataContext.get(params[:id])
          render 'contexts/edit'
        end
      
        put :update, :with => :id do
          @context = SharedDataContext.get(params[:id])
          if @context.update_attributes(params[:shared_data_context])
            flash[:notice] = 'Shared Data Context was successfully updated.'
            redirect url(:contexts, :edit, :id => @context.id)
          else
            render 'contexts/edit'
          end
        end

	delete :destroy, :with => :id do
	  context = SharedDataContext.get(params[:id])
	  if context.destroy
	    flash[:notice] = 'Shared Data Context was successfully destroyed.'
	  else
	    flash[:error] = 'Unable to destroy Shared Data Context!'
	  end
	  redirect url(:developers, :index)
	end
end
