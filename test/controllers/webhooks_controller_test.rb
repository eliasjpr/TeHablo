require 'test_helper'

class WebhooksControllerTest < ActionController::TestCase
  test "should get transfer" do
    get :transfer
    assert_response :success
  end

end
