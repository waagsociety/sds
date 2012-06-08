#register controller
#signs up new developer acount
Admin.controllers :register do

	get :index do
    		render 'register/new'
	end

	post :create do
	       	@account = Account.new(params[:account])
		@account.role = :developer
		if @account.save
			puts "success"
			flash[:notice] = 'Account was successfully created.'
			set_current_account(@account)

			account = Account.authenticate(@account.email, @account.password)
      			set_current_account(account)

			redirect url(:developers, :index)
		else
			puts "fail: #{@account.errors.inspect}"
			render 'register/new'
		end
	end
end
