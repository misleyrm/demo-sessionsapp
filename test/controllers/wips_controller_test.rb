require 'test_helper'

class WipsControllerTest < ActionController::TestCase
  setup do
    @wip = wips(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wips)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wip" do
    assert_difference('Wip.count') do
      post :create, wip: { session_id: @wip.session_id, user_id: @wip.user_id, wip_item: @wip.wip_item }
    end

    assert_redirected_to wip_path(assigns(:wip))
  end

  test "should show wip" do
    get :show, id: @wip
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @wip
    assert_response :success
  end

  test "should update wip" do
    patch :update, id: @wip, wip: { session_id: @wip.session_id, user_id: @wip.user_id, wip_item: @wip.wip_item }
    assert_redirected_to wip_path(assigns(:wip))
  end

  test "should destroy wip" do
    assert_difference('Wip.count', -1) do
      delete :destroy, id: @wip
    end

    assert_redirected_to wips_path
  end
end
