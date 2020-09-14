class BillingsController < ApplicationController
  require "thinreports-rails"
  before_action :set_billing, only: [:show, :edit, :destroy]

  # GET /billings
  # GET /billings.json
  def index
    @billings = Billing.search(params).page(params[:page]).per(per_page_count)

    respond_to do |format|
      format.html
      format.json { @billings }
      format.js {render layout: false, content_type: 'text/javascript'}
    end
  end

  # GET /billings/1
  # GET /billings/1.json
  def show    
    respond_to do |format|
      format.html
      format.pdf { render_bill(@billing) }
    end
  end

  # GET /billings/new
  def new
    @billing = Billing.new
    @billing.billing_date = display_date(DateTime.now)
    @billing.billing_number = Billing.get_next_number
  end

  # GET /billings/1/edit
  def edit
    @billing = Billing.includes(:billing_details=> [:item], :customer => []).find(params[:id])
  end

  # POST /billings
  # POST /billings.json
  def create
    @billing = Billing.new(create_billing_params)

    create_or_update_customer
    
    respond_to do |format|
      if @billing.save
        format.html { redirect_to billings_path, notice: 'Billing was successfully created.' }
        format.json { render :show, status: :created, location: @billing }
      else
        format.html { render :new }
        format.json { render json: @billing.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /billings/1
  # PATCH/PUT /billings/1.json
  def update
    @billing = Billing.find(params[:id])
    respond_to do |format|
      if @billing.update(update_billing_params)
        format.html { redirect_to billings_path, notice: 'Billing was successfully updated.' }
        format.json { render :show, status: :ok, location: @billing }
      else
        format.html { render :edit }
        format.json { render json: @billing.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /billings/1
  # DELETE /billings/1.json
  def destroy
    @billing.destroy
    respond_to do |format|
      format.html { redirect_to billings_url, notice: 'Billing was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

    def create_or_update_customer
      if @billing.customer_id.blank?
        @customer = Customer.new
      else
        @customer = Customer.find(@billing.customer_id)
      end

      @customer.name = @billing.customer_name
      @customer.contact_number1 = @billing.contact_number1
      @customer.contact_number2 = @billing.contact_number2
      @customer.address1 = @billing.address1
      @customer.address2 = @billing.address2

      begin
        if @customer.save!
          @billing.customer_id = @customer.id
        else
  
        end
      rescue ActiveRecord::RecordInvalid => e
        @billing.errors.add(:customer_id, e.message)
      end
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_billing
      @billing = Billing.includes(:billing_details=> [:item], :customer => []).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def create_billing_params
      params.require(:billing).permit(:customer_id, :billing_date, :billing_number, :total_amount, :paid_amount, :pending_amount,
        :customer_name, :contact_number1, :contact_number2, :address1, :address2,
        billing_details_attributes: [:receiving_id, :item_id, :item_quantity, :item_rate, :item_total]
      )
    end

    def update_billing_params
      params.require(:billing).permit(:id, :billing_date, :paid_amount, :pending_amount)
    end

    def render_bill(billing)
      report = ::Thinreports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'customer_bill.tlf')
      
      report.start_new_page

      report.page.values(bill_number: billing.billing_number,
        bill_date: billing.billing_date,
        customer_name: billing.customer.name,
        customer_address: billing.customer.address1,
        customer_number: billing.customer.contact_number1,
        shop_name: "ShopMan",
        shop_address: "Sai Market, APMC, Near Axis Bank, Vashi",
        shop_mobile_number: "M. 7208516101")

      report.page.list do |list|

        list.on_footer_insert do |footer|
          footer.item(:total_amount).value(billing.total_amount)
          footer.item(:amount_paid).value(billing.paid_amount)
          footer.item(:pending_amount).value(billing.pending_amount)
        end
        
          billing.billing_details.each_with_index do |detail,index|
            index += 1
            list.add_row do |row|
              row.values no: index, 
                        item_name: detail.item.name, 
                        qty: detail.item_quantity,
                        rate: detail.item_rate, 
                        amount: detail.item_total
            end
          end

          if billing.billing_details.count() < 30
            loopNo = 30 - billing.billing_details.count()

            loopNo.times do |t|
              list.add_row(no: "", item_name: "", qty: "", rate: "", amount: "")
            end
          end
      end
      send_data report.generate, filename: "bill_#{billing.billing_number}.pdf", 
                                 type: 'application/pdf', 
                                 disposition: 'inline'
    end
end
