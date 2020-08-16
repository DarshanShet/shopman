class DashbordsController < ApplicationController
  include DashbordsHelper
  before_action :set_dashbord, only: [:show, :edit, :update, :destroy]

  # GET /dashbords
  # GET /dashbords.json
  def index
    @customer_pending_amount = Billing.sum_pending_amount
    @supplier_pending_amount = Receiving.sum_pending_amount
    @customer_count = Customer.count
    @sale = Billing.filter_by_bill_date_range(Date.today.at_beginning_of_month, Date.today.end_of_month).sum_paid_amount
    @top_pending_customer = top_pending_amout_customers
    @top_pending_supplier = top_pending_amout_supplier
    @sales_receiving_by_month = Receiving.year_sales
    @sales_billing_by_month = Billing.year_sales
    @last_year_sale = Billing.last_year_sale
    @current_year_sale = @sales_billing_by_month.values.inject { |a, b| a + b }
  end
end
