class UomsController < ApplicationController
  before_action :set_uom, only: [:show, :edit, :update, :destroy]

  # GET /uoms
  # GET /uoms.json
  def index
    @uoms = Uom.search(params).page(params[:page]).per(per_page_count)

    respond_to do |format|
      format.html
      format.json { @uoms }
      format.js {render layout: false, content_type: 'text/javascript'}
    end
  end

  # GET /uoms/1
  # GET /uoms/1.json
  def show
  end

  # GET /uoms/new
  def new
    @uom = Uom.new
  end

  # GET /uoms/1/edit
  def edit
  end

  # POST /uoms
  # POST /uoms.json
  def create
    @uom = Uom.new(uom_params)

    respond_to do |format|
      if @uom.save
        format.html { redirect_to uoms_path, notice: 'Uom was successfully created.' }
        format.json { render :show, status: :created, location: @uom }
      else
        format.html { render :new }
        format.json { render json: @uom.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /uoms/1
  # PATCH/PUT /uoms/1.json
  def update
    respond_to do |format|
      if @uom.update(uom_params)
        format.html { redirect_to uoms_path, notice: 'Uom was successfully updated.' }
        format.json { render :show, status: :ok, location: @uom }
      else
        format.html { render :edit }
        format.json { render json: @uom.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /uoms/1
  # DELETE /uoms/1.json
  def destroy
    @uom.destroy
    respond_to do |format|
      format.html { redirect_to uoms_url, notice: 'Uom was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def import
    if params[:file].present?
      spreadsheet = Roo::Spreadsheet.open(params[:file].path)
      header = spreadsheet.row(1)
      (2..spreadsheet.last_row).each do |i|
        row = Hash[[header, spreadsheet.row(i)].transpose]
        if Uom.find_by_code(row["code"]).blank?
          uom = Uom.new
          uom.attributes = {
            code: row["code"],
            name: row["name"]
          }

          if uom.save
            
          else
            uom.errors.full_messages.each do |message|
              flash_message(:error, "Line no #{i} : #{message}")
            end
          end
        else
          flash_message(:error, "Line no #{i} : #{row["code"]} already exists")
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
    def set_uom
      @uom = Uom.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def uom_params
      params.require(:uom).permit(:code, :name)
    end
end
