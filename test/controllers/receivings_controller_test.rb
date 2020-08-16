require 'test_helper'

class ReceivingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @receiving = receivings(:one)
  end

  test "should get index" do
    get receivings_url
    assert_response :success
  end

  test "should get new" do
    get new_receiving_url
    assert_response :success
  end

  test "should create receiving" do
    assert_difference('Receiving.count') do
      post receivings_url, params: { receiving: { bill_date: @receiving.bill_date, bill_number: @receiving.bill_number, paid_amount: @receiving.paid_amount, pending_amount: @receiving.pending_amount, receiving_date: @receiving.receiving_date, receiving_number: @receiving.receiving_number, total_amount: @receiving.total_amount, vendor: @receiving.vendor } }
    end

    assert_redirected_to receiving_url(Receiving.last)
  end

  test "should show receiving" do
    get receiving_url(@receiving)
    assert_response :success
  end

  test "should get edit" do
    get edit_receiving_url(@receiving)
    assert_response :success
  end

  test "should update receiving" do
    patch receiving_url(@receiving), params: { receiving: { bill_date: @receiving.bill_date, bill_number: @receiving.bill_number, paid_amount: @receiving.paid_amount, pending_amount: @receiving.pending_amount, receiving_date: @receiving.receiving_date, receiving_number: @receiving.receiving_number, total_amount: @receiving.total_amount, vendor: @receiving.vendor } }
    assert_redirected_to receiving_url(@receiving)
  end

  test "should destroy receiving" do
    assert_difference('Receiving.count', -1) do
      delete receiving_url(@receiving)
    end

    assert_redirected_to receivings_url
  end
end
