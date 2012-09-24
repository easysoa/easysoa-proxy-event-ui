require 'test_helper'

class WebservicetolistensControllerTest < ActionController::TestCase
  setup do
    @webservicetolisten = webservicetolistens(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:webservicetolistens)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create webservicetolisten" do
    assert_difference('Webservicetolisten.count') do
      post :create, webservicetolisten: { archipath: @webservicetolisten.archipath, date: @webservicetolisten.date, description: @webservicetolisten.description, environment: @webservicetolisten.environment, nuxeouid: @webservicetolisten.nuxeouid, title: @webservicetolisten.title, url: @webservicetolisten.url }
    end

    assert_redirected_to webservicetolisten_path(assigns(:webservicetolisten))
  end

  test "should show webservicetolisten" do
    get :show, id: @webservicetolisten
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @webservicetolisten
    assert_response :success
  end

  test "should update webservicetolisten" do
    put :update, id: @webservicetolisten, webservicetolisten: { archipath: @webservicetolisten.archipath, date: @webservicetolisten.date, description: @webservicetolisten.description, environment: @webservicetolisten.environment, nuxeouid: @webservicetolisten.nuxeouid, title: @webservicetolisten.title, url: @webservicetolisten.url }
    assert_redirected_to webservicetolisten_path(assigns(:webservicetolisten))
  end

  test "should destroy webservicetolisten" do
    assert_difference('Webservicetolisten.count', -1) do
      delete :destroy, id: @webservicetolisten
    end

    assert_redirected_to webservicetolistens_path
  end
end
