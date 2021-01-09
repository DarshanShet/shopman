class ReportsController < ApplicationController
  
  def index
  end
  
  def pending_amount_customers
    respond_to do |format|
      @billings = Billing.pending_amount_bills
      @billings = @billings.filter_by_bill_date_range(params[:key_from_date], params[:key_to_date]) if params[:key_from_date].present? && params[:key_to_date].present?
      @billings = @billings.filter_by_customer_id(params[:key_customer_id]) if params[:key_customer_id].present?
      
      if @billings.present?
        format.pdf { render_pending_bil(@billings) }
      else
        format.pdf {}
      end
    end
  end
  
  def pending_amount_suppliers
    respond_to do |format|
      @receivings = Receiving.pending_amount_bills
      @receivings = @receivings.filter_by_receiving_date_range(params[:key_from_receiving_date], params[:key_to_receiving_date]) if params[:key_from_receiving_date].present? && params[:key_to_receiving_date].present?
      @receivings = @receivings.filter_by_vendor_id(params[:key_vendor_id]) if params[:key_vendor_id].present?
      
      if @receivings.present?
        format.pdf { render_pending_receiving_bill(@receivings) }
      else
        format.pdf {}
      end
    end
  end

  def item_stock
    respond_to do |format|
      @item_in_outs = ItemInOut.includes(:item => [:receiving_uom]).search()
      @item_in_outs = @item_in_outs.filter_qty_left_ind if params[:exclude_zero].present?
      
      if @item_in_outs.present?
        format.xlsx { response.headers['Content-Disposition'] = 'attachment; filename="item_stock.xlsx"' }
        format.pdf { render_item_stock(@item_in_outs) }
      else
        format.xlsx
        format.pdf {}
      end
    end
  end
  
  private

  def render_pending_bil(billings)
    report = ::Thinreports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'pending_bills.tlf')
      
    report.start_new_page

    report.page.values(
      shop_name: current_user.shop.present? ? current_user.shop.shop_name : "",
      shop_address: current_user.shop.present? ? current_user.shop.shop_address : "",
      shop_mobile_number: "M. #{current_user.shop.present? ? current_user.shop.shop_mobile : ""}")

    report.page.list do |list|

      list.on_footer_insert do |footer|
        footer.item(:total_amount).value(billings.sum(:total_amount))
        footer.item(:amount_paid).value(billings.sum(:paid_amount))
        footer.item(:pending_amount).value(billings.sum(:pending_amount))
      end
      
      billings.each_with_index do |bill,index|
        index += 1
        list.add_row do |row|
          row.values no: index, 
                    bill_number: bill.billing_number, 
                    bill_date: bill.billing_date,
                    customer_name: bill.customer.name, 
                    customer_number: bill.customer.contact_number1,
                    total_amount: bill.total_amount,
                    amount_paid: bill.paid_amount,
                    amount_pending: bill.pending_amount
        end
      end
    end
    send_data report.generate, filename: "bill.pdf", 
                                type: 'application/pdf', 
                                disposition: 'inline'
  end

  def render_pending_receiving_bill(receivings)
    report = ::Thinreports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'pending_vendor_bills.tlf')
      
    report.start_new_page

    report.page.values(
      shop_name: current_user.shop.present? ? current_user.shop.shop_name : "",
      shop_address: current_user.shop.present? ? current_user.shop.shop_address : "",
      shop_mobile_number: "M. #{current_user.shop.present? ? current_user.shop.shop_mobile : ""}")

    report.page.list do |list|

      list.on_footer_insert do |footer|
        footer.item(:total_amount).value(receivings.sum(:total_amount))
        footer.item(:amount_paid).value(receivings.sum(:paid_amount))
        footer.item(:pending_amount).value(receivings.sum(:pending_amount))
      end
      
      receivings.each_with_index do |bill,index|
        index += 1
        list.add_row do |row|
          row.values no: index, 
                    bill_number: bill.receiving_number, 
                    bill_date: bill.receiving_date,
                    supplier_name: bill.vendor.name, 
                    supplier_number: bill.vendor.contact_number1,
                    total_amount: bill.total_amount,
                    amount_paid: bill.paid_amount,
                    amount_pending: bill.pending_amount
        end
      end
    end
    send_data report.generate, filename: "receivings_bill.pdf", 
                                type: 'application/pdf', 
                                disposition: 'inline'
  end

  def render_item_stock(item_in_outs)
    report = ::Thinreports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'item_current_stock_landscape.tlf')
      
    report.start_new_page

    report.page.values(
      shop_name: current_user.shop.present? ? current_user.shop.shop_name : "",
      shop_address: current_user.shop.present? ? current_user.shop.shop_address : "",
      shop_mobile_number: "M. #{current_user.shop.present? ? current_user.shop.shop_mobile : ""}",
      report_date_time: Time.now)

    report.page.list do |list|      
      item_in_outs.each_with_index do |item_in_out,index|
        index += 1
        list.add_row do |row|
          row.values no: index, 
                    item_code: item_in_out.item.code, 
                    item_name: item_in_out.item.name,
                    batch_no: item_in_out.batch_number,
                    brand_name: item_in_out.item.brand_name,
                    manufacture_date: item_in_out.manufacture_date,
                    expiry_date: item_in_out.expiry_date,
                    qty_in_stk: item_in_out.qty_left, 
                    uom_name: item_in_out.item.receiving_uom.name
        end
      end
    end

    send_data report.generate, filename: "stock.pdf", 
                                type: 'application/pdf', 
                                disposition: 'inline'
  end
end