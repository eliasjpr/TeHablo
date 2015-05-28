require 'test_helper'

class AgentsControllerTest < ActionController::TestCase
	setup do
		@user = agents(:one)
	end

	test "should get index" do
		get :index
		assert_response :success
		assert_not_nil assigns(:users)
	end

	test "should get new" do
		get :new
		assert_response :success
	end

	test "should create user" do
		assert_difference('User.count') do
			post :create, user: { account_status: @user.account_status, auth_token: @user.auth_token, balance: @user.balance, business_name: @user.business_name, commission: @user.commission, email: @user.email, first_name: @user.first_name, last_name: @user.last_name, logo: @user.logo, password: @user.password, sid: @user.sid }
		end

		assert_redirected_to agent_path(assigns(:user))
	end

	test "should show user" do
		get :show, id: @user
		assert_response :success
	end

	test "should get edit" do
		get :edit, id: @user
		assert_response :success
	end

	test "should update user" do
		patch :update, id: @user, user: { account_status: @user.account_status, auth_token: @user.auth_token, balance: @user.balance, business_name: @user.business_name, commission: @user.commission, email: @user.email, first_name: @user.first_name, last_name: @user.last_name, logo: @user.logo, password: @user.password, sid: @user.sid }
		assert_redirected_to agent_path(assigns(:user))
	end

	test "should destroy user" do
		assert_difference('User.count', -1) do
			delete :destroy, id: @user
		end

		assert_redirected_to agents_path
	end
end
