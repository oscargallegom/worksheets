require 'test_helper'

class FarmsControllerTest < ActionController::TestCase
  setup do
    @farm = projects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:farms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create project" do
    assert_difference('Project.count') do
      post :create, farm: { farm_notes: @farm.farm_notes, name: @farm.name, tract_number: @farm.tract_number }
    end

    assert_redirected_to project_path(assigns(:farm))
  end

  test "should show project" do
    get :show, id: @farm
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @farm
    assert_response :success
  end

  test "should update project" do
    put :update, id: @farm, farm: { farm_notes: @farm.farm_notes, name: @farm.name, tract_number: @farm.tract_number }
    assert_redirected_to project_path(assigns(:farm))
  end

  test "should destroy project" do
    assert_difference('Project.count', -1) do
      delete :destroy, id: @farm
    end

    assert_redirected_to projects_path
  end
end
