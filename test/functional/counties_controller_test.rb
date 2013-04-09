require 'test_helper'

class CountiesControllerTest < ActionController::TestCase
  setup do
    @county = cities(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:counties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create city" do
    assert_difference('City.count') do
      post :create, county: {string: @county.string}
    end

    assert_redirected_to city_path(assigns(:county))
  end

  test "should show city" do
    get :show, id: @county
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @county
    assert_response :success
  end

  test "should update city" do
    put :update, id: @county, county: {string: @county.string}
    assert_redirected_to city_path(assigns(:county))
  end

  test "should destroy city" do
    assert_difference('City.count', -1) do
      delete :destroy, id: @county
    end

    assert_redirected_to cities_path
  end
end
