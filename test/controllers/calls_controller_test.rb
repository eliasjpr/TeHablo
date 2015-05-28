require 'test_helper'

class CallsControllerTest < ActionController::TestCase
	setup do
		@call = calls(:one)
	end

	test "should get index" do
		get :index
		assert_response :success
		assert_not_nil assigns(:calls)
	end

	test "should get new" do
		get :new
		assert_response :success
	end

	test "should create call" do
		assert_difference('Call.count') do
			post :create, call: { account_sid: @call.account_sid, api_version: @call.api_version, call_sid: @call.call_sid, call_status: @call.call_status, caller_name: @call.caller_name, direction: @call.direction, forwarded_from: @call.forwarded_from, from: @call.from, from_city: @call.from_city, from_country: @call.from_country, from_state: @call.from_state, from_zip: @call.from_zip, to: @call.to }
		end

		assert_redirected_to call_path(assigns(:call))
	end

	test "should show call" do
		get :show, id: @call
		assert_response :success
	end

	test "should get edit" do
		get :edit, id: @call
		assert_response :success
	end

	test "should update call" do
		patch :update, id: @call, call: { account_sid: @call.account_sid, api_version: @call.api_version, call_sid: @call.call_sid, call_status: @call.call_status, caller_name: @call.caller_name, direction: @call.direction, forwarded_from: @call.forwarded_from, from: @call.from, from_city: @call.from_city, from_country: @call.from_country, from_state: @call.from_state, from_zip: @call.from_zip, to: @call.to }
		assert_redirected_to call_path(assigns(:call))
	end

	test "should destroy call" do
		assert_difference('Call.count', -1) do
			delete :destroy, id: @call
		end

		assert_redirected_to calls_path
	end
end
