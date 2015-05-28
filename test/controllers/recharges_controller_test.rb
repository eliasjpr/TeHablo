require 'test_helper'

class RechargesControllerTest < ActionController::TestCase
  setup do
    @recharge = recharges(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:recharges)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create recharge" do
    assert_difference('Recharge.count') do
      post :create, recharge: {agent_id: @recharge.agent_id, amount: @recharge.amount, amount_refunded: @recharge.amount_refunded, captured: @recharge.captured, card_type: @recharge.card_type, currency: @recharge.currency, customer: @recharge.customer, description: @recharge.description, dispute: @recharge.dispute, failure_code: @recharge.failure_code, failure_message: @recharge.failure_message, fee: @recharge.fee, invoice: @recharge.invoice, last4: @recharge.last4, paid: @recharge.paid, refunded: @recharge.refunded, user_id: @recharge.user_id}
    end

    assert_redirected_to recharge_path(assigns(:recharge))
  end

  test "should show recharge" do
    get :show, id: @recharge
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @recharge
    assert_response :success
  end

  test "should update recharge" do
    patch :update, id: @recharge, recharge: {agent_id: @recharge.agent_id, amount: @recharge.amount, amount_refunded: @recharge.amount_refunded, captured: @recharge.captured, card_type: @recharge.card_type, currency: @recharge.currency, customer: @recharge.customer, description: @recharge.description, dispute: @recharge.dispute, failure_code: @recharge.failure_code, failure_message: @recharge.failure_message, fee: @recharge.fee, invoice: @recharge.invoice, last4: @recharge.last4, paid: @recharge.paid, refunded: @recharge.refunded, user_id: @recharge.user_id}
    assert_redirected_to recharge_path(assigns(:recharge))
  end

  test "should destroy recharge" do
    assert_difference('Recharge.count', -1) do
      delete :destroy, id: @recharge
    end

    assert_redirected_to recharges_path
  end
end
