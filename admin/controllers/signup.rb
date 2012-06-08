#sign up controller
#signs up new store owner
Admin.controllers :signup do

	get :index do
    		render 'signup/new'
	end

	post :create do
	       	@account = Account.new(params[:account])
		@account.role = :dataowner
		if @account.save
			puts "success"
			flash[:notice] = 'Account was successfully created.'
			set_current_account(@account)

			account = Account.authenticate(@account.email, @account.password)
      			set_current_account(account)

			redirect url(:users, :index)
			#redirect to login
		else
			puts "fail: #{@account.errors.inspect}"
			render 'signup/new'
		end
	end
end
