require 'test_helper'

class UnsecureareaControllerTest < ActionController::TestCase
  test "should get connexion" do
    get :connexion
    assert_response :success
  end

  test "should get register" do
    get :register
    assert_response :success
  end

  test "should get createconnexion" do
    get :createconnexion
    assert_response :success
  end

end
