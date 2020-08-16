class ReceivingsController < ApplicationController
  before_action :set_receiving, only: [:show, :edit, :update, :destroy]

  # GET /receivings
  # GET /receivings.json
  def index
    @receivings = Receiving.search(params).page(params[:page]).per(per_page_count)

    respond_to do |format|
      format.html
      format.json { @receivings }
      format.js {render layout: false, content_type: 'text/javascript'}
    end
  end

  # GET /receivings/1
  # GET /receivings/1.json
  def show
    respond_to do |format|
      format.html
      format.pdf { render_receiving(@receiving) }
    end
  end

  # GET /receivings/new
  def new
    @receiving = Receiving.new
    @receiving.receiving_date = display_date(DateTime.now)
    @receiving.receiving_number = Receiving.get_next_number
  end

  # GET /receivings/1/edit
  def edit
  end

  # POST /receivings
  # POST /receivings.json
  def create
    @receiving = Receiving.new(create_receiving_params)

    respond_to do |format|
      if @receiving.save
        format.html { redirect_to receivings_path, notice: 'Receiving was successfully created.' }
        format.json { render :show, status: :created, location: @receiving }
      else
        format.html { render :new }
        format.json { render json: @receiving.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /receivings/1
  # PATCH/PUT /receivings/1.json
  def update
    respond_to do |format|
      if @receiving.update(update_receiving_params)
        format.html { redirect_to receivings_path, notice: 'Receiving was successfully updated.' }
        format.json { render :show, status: :ok, location: @receiving }
      else
        format.html { render :edit }
        format.json { render json: @receiving.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /receivings/1
  # DELETE /receivings/1.json
  def destroy
    @receiving.destroy
    respond_to do |format|
      format.html { redirect_to receivings_url, notice: 'Receiving was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_receiving
      @receiving = Receiving.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def create_receiving_params
      params.require(:receiving).permit(:receiving_date, :receiving_number, 
        :bill_number, :bill_date, :total_amount, :vendor_id, :paid_amount, :pending_amount,
        receiving_details_attributes: [:receiving_id, :item_id, :item_quantity, :item_rate, :item_total])
    end

    def update_receiving_params
      params.require(:receiving).permit(:id, :paid_amount, :pending_amount)
    end

    def render_receiving(receiving)
      report = ::Thinreports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'receiving_bill.tlf')
      
      report.start_new_page

      report.page.values(bill_number: receiving.receiving_number,
        bill_date: receiving.receiving_date,
        vendor_name: receiving.vendor.name,
        vendor_address: receiving.vendor.address1,
        vendor_number: receiving.vendor.contact_number1,
        shop_name: "ShopMan",
        shop_address: "Sai Market, APMC, Near Axis Bank, Vashi",
        shop_mobile_number: "M. 7208516101")

      report.page.list do |list|

        list.on_footer_insert do |footer|
          footer.item(:total_amount).value(receiving.total_amount)
          footer.item(:amount_paid).value(receiving.paid_amount)
          footer.item(:pending_amount).value(receiving.pending_amount)
        end
        
        receiving.receiving_details.each_with_index do |detail,index|
          index += 1
          list.add_row do |row|
            row.values no: index, 
                      item_name: detail.item.name, 
                      qty: detail.item_quantity,
                      rate: detail.item_rate, 
                      amount: detail.item_total
          end
        end

        if receiving.receiving_details.count() < 30
          loopNo = 30 - receiving.receiving_details.count()

          loopNo.times do |t|
            list.add_row(no: "", item_name: "", qty: "", rate: "", amount: "")
          end
        end
      end

      send_data report.generate, filename: "supplier_#{receiving.receiving_number}.pdf", 
                                 type: 'application/pdf', 
                                 disposition: 'inline'
    end
end
