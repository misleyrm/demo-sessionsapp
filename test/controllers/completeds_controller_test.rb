require 'test_helper'

class CompletedsControllerTest < ActionController::TestCase
  setup do
    @completed = completeds(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:completeds)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create completed" do
    assert_difference('Completed.count') do
      post :create, completed: { completed: @completed.completed, session_id: @completed.session_id, user_id: @completed.user_id }
    end

    assert_redirected_to completed_path(assigns(:completed))
  end

  test "should show completed" do
    get :show, id: @completed
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @completed
    assert_response :success
  end

  test "should update completed" do
    patch :update, id: @completed, completed: { completed: @completed.completed, session_id: @completed.session_id, user_id: @completed.user_id }
    assert_redirected_to completed_path(assigns(:completed))
  end

  test "should destroy completed" do
    assert_difference('Completed.count', -1) do
      delete :destroy, id: @completed
    end

    assert_redirected_to completeds_path
  end
end
