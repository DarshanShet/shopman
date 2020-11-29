class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]

  # GET /items
  # GET /items.json
  def index
    @items = Item.search(params).page(params[:page]).per(per_page_count)

    respond_to do |format|
      format.html
      format.json { @items }
      format.js {render layout: false, content_type: 'text/javascript'}
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to items_path, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to items_path, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    if params[:file].present?
      spreadsheet = Roo::Spreadsheet.open(params[:file].path)
      header = spreadsheet.row(1).map{|x| x.downcase.tr(" ", "_")}
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        if Item.find_by_code(row["code"]).blank?
          item = Item.new
          item.attributes = {
            code: row["code"],
            name: row["name"],
            qty_in_stock: 0,
            last_receiving_rate: 0,
            receiving_uom: Uom.find_by_code(row["receiving_uom_code"]),
            conversion_rate: row["conversion_rate"].to_i,
            billing_uom: Uom.find_by_code(row["billing_uom_code"])
          }

          if item.save
          else
            item.errors.full_messages.each do |message|
              flash_message(:error, "Line no #{i} : #{message}")
            end
          end
        else
          flash_message(:error, "Line no #{i} : #{row["code"]} already exists")
        end
      end

      if flash[:error].blank?
        flash[:notice] = "Item was successfully imported."
        redirect_to items_path
      else
        redirect_to items_path
      end
    else
      flash[:error] = "Please select file."
      redirect_to items_path
    end
  end

  def update_stock
    if params[:item_stock].present?
      spreadsheet = Roo::Spreadsheet.open(params[:item_stock].path)
      header = spreadsheet.row(1).map{|x| x.downcase.tr(" ", "_")}
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        code = row["code"]
        qty_in_stock = row["qty_in_stock"]

        if code.present? && qty_in_stock.present?
          item = Item.find_by_code(code)
          current_qty_in_stock = item.qty_in_stock

          if item.present?
            if qty_in_stock.to_d != current_qty_in_stock
              if item.update(qty_in_stock: qty_in_stock)
                StockUpdateLog.create_log(item.id, current_qty_in_stock, qty_in_stock)
              else
                item.errors.full_messages.each do |message|
                  flash_message(:error, "Line no #{i} : #{message}")
                end
              end
            end
          else
            flash_message(:error, "Line no #{i} : #{code} not exists")
          end
        else
          flash_message(:error, "Line no #{i} : item code / Qty in stock cant be blank")
        end
      end

      if flash[:error].blank?
        flash[:notice] = "Item stock was updated successfully."
        redirect_to items_path
      else
        redirect_to items_path
      end
    end
  end

  def download_excel
    if File.exist?("app/data/excel/#{params[:excel_name]}")
    	send_file "app/data/excel/#{params[:excel_name]}"
  	else
  		flash[:error] = "file is missing"
  		redirect_to request.referrer
  	end
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:code, :name, :qty_in_stock, :last_receiving_rate, :receiving_uom_id, :conversion_rate, :billing_uom_id)
    end
end
