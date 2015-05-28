require 'test_helper'

class CallingIdsControllerTest < ActionController::TestCase
	setup do
		@calling_id = calling_ids(:one)
	end

	test "should get index" do
		get :index
		assert_response :success
		assert_not_nil assigns(:calling_ids)
	end

	test "should get new" do
		get :new
		assert_response :success
	end

	test "should create calling_id" do
		assert_difference('CallingId.count') do
			post :create, calling_id: { call_id: @calling_id.call_id, user_id: @calling_id.user_id }
		end

		assert_redirected_to calling_id_path(assigns(:calling_id))
	end

	test "should show calling_id" do
		get :show, id: @calling_id
		assert_response :success
	end

	test "should get edit" do
		get :edit, id: @calling_id
		assert_response :success
	end

	test "should update calling_id" do
		patch :update, id: @calling_id, calling_id: { call_id: @calling_id.call_id, user_id: @calling_id.user_id }
		assert_redirected_to calling_id_path(assigns(:calling_id))
	end

	test "should destroy calling_id" do
		assert_difference('CallingId.count', -1) do
			delete :destroy, id: @calling_id
		end

		assert_redirected_to calling_ids_path
	end
end
