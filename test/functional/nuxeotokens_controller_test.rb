require 'test_helper'

class NuxeotokensControllerTest < ActionController::TestCase
  setup do
    @nuxeotoken = nuxeotokens(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:nuxeotokens)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create nuxeotoken" do
    assert_difference('Nuxeotoken.count') do
      post :create, nuxeotoken: { content: @nuxeotoken.content }
    end

    assert_redirected_to nuxeotoken_path(assigns(:nuxeotoken))
  end

  test "should show nuxeotoken" do
    get :show, id: @nuxeotoken
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @nuxeotoken
    assert_response :success
  end

  test "should update nuxeotoken" do
    put :update, id: @nuxeotoken, nuxeotoken: { content: @nuxeotoken.content }
    assert_redirected_to nuxeotoken_path(assigns(:nuxeotoken))
  end

  test "should destroy nuxeotoken" do
    assert_difference('Nuxeotoken.count', -1) do
      delete :destroy, id: @nuxeotoken
    end

    assert_redirected_to nuxeotokens_path
  end
end
