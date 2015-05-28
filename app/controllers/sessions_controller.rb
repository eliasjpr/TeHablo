class SessionsController < ApplicationController

	skip_before_action :authorize, :current_user

	def new
	end

	def create_account
		@user = User.new
	end

	def recover
	end

	# Creates a new password and sends an email to the user
	def forgot_password
		@user = User.find_by_email(params[:email])

		if @user
			random_password = Array.new(10).map { (65 + rand(58)).chr }.join
			@user.password  = random_password
			@user.save!

			respond_to do |format|
				format.html { redirect_to login_path, notice: "Email sent. Follow the instructions to reset your password." }
			end

			#Send user forgot password email
      UserNotifier.forgot_password(@user, random_password).deliver
		else
			respond_to do |format|
				format.html { redirect_to recover_path, alert: "No account with #{params[:email]} was found!" }
			end
		end
	end

	# Creates a new account, sends welcome email to user
	def register
		@user = User.new(user_params)

		respond_to do |format|
			if @user.save

				format.html { redirect_to login_path, notice: "Account created successfully!" }
			else
				format.html { render action: :create_account }
			end
		end
	end

	# Log user in and sets session variable
	def create
		@user = User.find_by_email(params[:email])

		if @user and @user.authenticate(params[:password])

			# set session user id
			session[:user_id] = @user.id

			respond_to do |format|
				format.html { redirect_to dashboard_index_path, notice: "Welcome Back #{@user.full_name}!" }
			end

		else
			respond_to do |format|
				format.html { redirect_to login_path, alert: "Sorry wrong username or password" }
			end
		end
	end

	def destroy
		session[:user_id] = nil
		redirect_to login_path
	end


	private


	# Never trust parameters from the scary internet, only allow the white list through.
	def user_params
		params.permit(:first_name, :last_name, :email, :password, :password_confirmation)
	end

end
