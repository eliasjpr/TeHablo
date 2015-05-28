require 'test_helper'

class RatesControllerTest < ActionController::TestCase
  setup do
    @rate = rates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rate" do
    assert_difference('Rate.count') do
      post :create, rate: { country: @rate.country, country_code: @rate.country_code, country_iso: @rate.country_iso, direction: @rate.direction, number_type: @rate.number_type, prefix: @rate.prefix, rent_per_number: @rate.rent_per_number, setup_cost_per_number: @rate.setup_cost_per_number, unit_in_seconds: @rate.unit_in_seconds, voice_rate: @rate.voice_rate }
    end

    assert_redirected_to rate_path(assigns(:rate))
  end

  test "should show rate" do
    get :show, id: @rate
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rate
    assert_response :success
  end

  test "should update rate" do
    patch :update, id: @rate, rate: { country: @rate.country, country_code: @rate.country_code, country_iso: @rate.country_iso, direction: @rate.direction, number_type: @rate.number_type, prefix: @rate.prefix, rent_per_number: @rate.rent_per_number, setup_cost_per_number: @rate.setup_cost_per_number, unit_in_seconds: @rate.unit_in_seconds, voice_rate: @rate.voice_rate }
    assert_redirected_to rate_path(assigns(:rate))
  end

  test "should destroy rate" do
    assert_difference('Rate.count', -1) do
      delete :destroy, id: @rate
    end

    assert_redirected_to rates_path
  end
end
