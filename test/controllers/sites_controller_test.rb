require 'test_helper'

class SitesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get features" do
    get :features
    assert_response :success
  end

  test "should get contact" do
    get :contact
    assert_response :success
  end

  test "should get about" do
    get :about
    assert_response :success
  end

end
