require 'test_helper'

class ItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @item = items(:one)
  end

  test "should get index" do
    get items_url
    assert_response :success
  end

  test "should get new" do
    get new_item_url
    assert_response :success
  end

  test "should create item" do
    assert_difference('Item.count') do
      post items_url, params: { item: { billing_uom: @item.billing_uom, code: @item.code, conversion_rate: @item.conversion_rate, last_receiving_rate: @item.last_receiving_rate, name: @item.name, qty_in_stock: @item.qty_in_stock, receiving_uom: @item.receiving_uom } }
    end

    assert_redirected_to item_url(Item.last)
  end

  test "should show item" do
    get item_url(@item)
    assert_response :success
  end

  test "should get edit" do
    get edit_item_url(@item)
    assert_response :success
  end

  test "should update item" do
    patch item_url(@item), params: { item: { billing_uom: @item.billing_uom, code: @item.code, conversion_rate: @item.conversion_rate, last_receiving_rate: @item.last_receiving_rate, name: @item.name, qty_in_stock: @item.qty_in_stock, receiving_uom: @item.receiving_uom } }
    assert_redirected_to item_url(@item)
  end

  test "should destroy item" do
    assert_difference('Item.count', -1) do
      delete item_url(@item)
    end

    assert_redirected_to items_url
  end
end
