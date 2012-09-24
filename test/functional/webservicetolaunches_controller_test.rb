require 'test_helper'

class WebservicetolaunchesControllerTest < ActionController::TestCase
  setup do
    @webservicetolaunch = webservicetolaunches(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:webservicetolaunches)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create webservicetolaunch" do
    assert_difference('Webservicetolaunch.count') do
      post :create, webservicetolaunch: { description: @webservicetolaunch.description, environment: @webservicetolaunch.environment, nuxeouid: @webservicetolaunch.nuxeouid, url: @webservicetolaunch.url }
    end

    assert_redirected_to webservicetolaunch_path(assigns(:webservicetolaunch))
  end

  test "should show webservicetolaunch" do
    get :show, id: @webservicetolaunch
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @webservicetolaunch
    assert_response :success
  end

  test "should update webservicetolaunch" do
    put :update, id: @webservicetolaunch, webservicetolaunch: { description: @webservicetolaunch.description, environment: @webservicetolaunch.environment, nuxeouid: @webservicetolaunch.nuxeouid, url: @webservicetolaunch.url }
    assert_redirected_to webservicetolaunch_path(assigns(:webservicetolaunch))
  end

  test "should destroy webservicetolaunch" do
    assert_difference('Webservicetolaunch.count', -1) do
      delete :destroy, id: @webservicetolaunch
    end

    assert_redirected_to webservicetolaunches_path
  end
end
