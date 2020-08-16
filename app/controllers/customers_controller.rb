class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :edit, :update, :destroy]

  # GET /customers
  # GET /customers.json
  def index
    @customers = Customer.search(params).page(params[:page]).per(per_page_count)

    respond_to do |format|
      format.html
      format.json { @customers }
      format.js {render layout: false, content_type: 'text/javascript'}
    end
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(customer_params)

    respond_to do |format|
      if @customer.save
        format.html { redirect_to customers_path, notice: 'Customer was successfully created.' }
        format.json { render :show, status: :created, location: @customer }
      else
        format.html { render :new }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /customers/1
  # PATCH/PUT /customers/1.json
  def update
    respond_to do |format|
      if @customer.update(customer_params)
        format.html { redirect_to customers_path, notice: 'Customer was successfully updated.' }
        format.json { render :show, status: :ok, location: @customer }
      else
        format.html { render :edit }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer.destroy
    respond_to do |format|
      format.html { redirect_to customers_url, notice: 'Customer was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    if params[:file].present?
      spreadsheet = Roo::Spreadsheet.open(params[:file].path)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        customer = Customer.new
        customer.attributes = {
          name: row["name"],
          contact_number1: row["contact_number1"].present? ? row["contact_number1"].to_i : "",
          contact_number2: row["contact_number2"].present? ? row["contact_number2"].to_i : "",
          contact_number3: row["contact_number3"].present? ? row["contact_number3"].to_i : "",
          address1: row["address1"],
          address2: row["address2"]
        }

        if customer.save
          
        else
          customer.errors.full_messages.each do |message|
            flash_message(:error, "Line no #{i} : #{message}")
          end
        end
      end

      if flash[:error].blank?
        flash[:notice] = "Customer was successfully imported."
        redirect_to vendors_path
      else
        redirect_to vendors_path
      end
    else
      flash[:error] = "Please select file."
      redirect_to vendors_path
    end
  end
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_customer
      @customer = Customer.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def customer_params
      params.require(:customer).permit(:name, :contact_number1, :contact_number2, :contact_number3, :address1, :address2)
    end
end
