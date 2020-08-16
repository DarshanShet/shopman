class VendorsController < ApplicationController
  before_action :set_vendor, only: [:show, :edit, :update, :destroy]

  # GET /vendors
  # GET /vendors.json
  def index
    @vendors = Vendor.search(params).page(params[:page]).per(per_page_count)

    respond_to do |format|
      format.html
      format.json { @vendors }
      format.js {render layout: false, content_type: 'text/javascript'}
    end
  end

  # GET /vendors/1
  # GET /vendors/1.json
  def show
  end

  # GET /vendors/new
  def new
    @vendor = Vendor.new
  end

  # GET /vendors/1/edit
  def edit
  end

  # POST /vendors
  # POST /vendors.json
  def create
    @vendor = Vendor.new(vendor_params)

    respond_to do |format|
      if @vendor.save
        format.html { redirect_to vendors_path, notice: 'Supplier was successfully created.' }
        format.json { render :show, status: :created, location: @vendor }
      else
        format.html { render :new }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vendors/1
  # PATCH/PUT /vendors/1.json
  def update
    respond_to do |format|
      if @vendor.update(vendor_params)
        format.html { redirect_to vendors_path, notice: 'Supplier was successfully updated.' }
        format.json { render :show, status: :ok, location: @vendor }
      else
        format.html { render :edit }
        format.json { render json: @vendor.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vendors/1
  # DELETE /vendors/1.json
  def destroy
    @vendor.destroy
    respond_to do |format|
      format.html { redirect_to vendors_url, notice: 'Supplier was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    if params[:file].present?
      spreadsheet = Roo::Spreadsheet.open(params[:file].path)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        vendor = Vendor.new
        vendor.attributes = {
          name: row["name"],
          contact_number1: row["contact_number1"].present? ? row["contact_number1"].to_i : "",
          contact_number2: row["contact_number2"].present? ? row["contact_number2"].to_i : "",
          contact_number3: row["contact_number3"].present? ? row["contact_number3"].to_i : "",
          address1: row["address1"],
          address2: row["address2"]
        }

        if vendor.save
          
        else
          vendor.errors.full_messages.each do |message|
            flash_message(:error, "Line no #{i} : #{message}")
          end
        end
      end

      if flash[:error].blank?
        flash[:notice] = "Suppliers was successfully imported."
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
    def set_vendor
      @vendor = Vendor.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def vendor_params
      params.require(:vendor).permit(:name, :contact_number1, :contact_number2, :contact_number3, :address1, :address2)
    end
end
