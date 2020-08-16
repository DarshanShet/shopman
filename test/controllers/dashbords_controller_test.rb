require 'test_helper'

class DashbordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @dashbord = dashbords(:one)
  end

  test "should get index" do
    get dashbords_url
    assert_response :success
  end

  test "should get new" do
    get new_dashbord_url
    assert_response :success
  end

  test "should create dashbord" do
    assert_difference('Dashbord.count') do
      post dashbords_url, params: { dashbord: {  } }
    end

    assert_redirected_to dashbord_url(Dashbord.last)
  end

  test "should show dashbord" do
    get dashbord_url(@dashbord)
    assert_response :success
  end

  test "should get edit" do
    get edit_dashbord_url(@dashbord)
    assert_response :success
  end

  test "should update dashbord" do
    patch dashbord_url(@dashbord), params: { dashbord: {  } }
    assert_redirected_to dashbord_url(@dashbord)
  end

  test "should destroy dashbord" do
    assert_difference('Dashbord.count', -1) do
      delete dashbord_url(@dashbord)
    end

    assert_redirected_to dashbords_url
  end
end
