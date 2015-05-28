class SessionsController < ApplicationController

	skip_before_action :authorize, :current_user

	def new
	end


	# Creates a new password and sends an email to the user
	def forgot_password
		@user = User.find_by_email(params[:email])

		if @user
			random_password = Array.new(10).map { (65 + rand(58)).chr }.join
			@user.password  = random_password
			@user.save!

			respond_to do |format|
				format.js { @alert = "Recover password email sent!" }
			end

			#Send user forgot password email
			UserNotification.forgot_password(@user).deliver
		else
			respond_to do |format|
				format.js { @alert = "No account with #{params[:email]} was found!" }
			end
		end
	end

	# Creates a new account, sends welcome email to user
	def register
		@user = User.new(user_params)

		respond_to do |format|
			if @user.save
				# Send user welcome email
				UserNotification.welcome_email(@user).deliver

				format.js { @errors = [] }
			else
				format.js { @errors = @user.errors }
			end
		end
	end

	# Log user in and sets session variable
	def create
		user = User.find_by_email(params[:email])

		if user and user.authenticate(params[:password])
			session[:agent_id] = user.id
			respond_to do |format|
				format.js { @alert = "" }
			end
		else

			respond_to do |format|
				format.js { @alert = "Sorry wrong username or passord" }
			end

		end
	end

	def destroy
		session[:agent_id] = nil
		redirect_to login_path
	end


	private


	# Never trust parameters from the scary internet, only allow the white list through.
	def user_params
		params.permit(:first_name, :last_name, :email, :password, :password_confirmation)
	end

end
