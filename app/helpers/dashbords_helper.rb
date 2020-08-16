module DashbordsHelper

  def top_pending_amout_customers
    @top_pending_customer = Billing.pending_amount_bills.group(:customer_id).select('customer_id, SUM(pending_amount) as amount').order('amount desc').limit(5)
    
    @pending_customers = []

    @top_pending_customer.each do |pending_customer|
      @customer_detail = Customer.find(pending_customer.customer_id)

      pending_customer_obj = {
        amout_to_pay: pending_customer.amount,
        customer_name: @customer_detail.name,
        customer_number: @customer_detail.contact_number1
      }

      @pending_customers << pending_customer_obj
    end

    return @pending_customers
  end

  def top_pending_amout_supplier
    @top_pending_supplier = Receiving.pending_amount_bills.group(:vendor_id).select('vendor_id, SUM(pending_amount) as amount').order('amount desc').limit(5)
    
    @pending_suppliers = []

    @top_pending_supplier.each do |pending_supplier|
      @supplier_detail = Vendor.find(pending_supplier.vendor_id)
      
      pending_supplier_obj = {
        amout_to_pay: pending_supplier.amount,
        supplier_name: @supplier_detail.name,
        supplier_number: @supplier_detail.contact_number1
      }

      @pending_suppliers << pending_supplier_obj
    end

    return @pending_suppliers
  end
end
