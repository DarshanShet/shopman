class ShopsController < ApplicationController
  before_action :set_shop, only: [:edit, :update, :destroy]

  # GET /shops
  # GET /shops.json
  def index
    if current_user.shop.present?
      redirect_to edit_shop_path(id: current_user.shop.id)
    else
      redirect_to new_shop_path
    end
  end

  # GET /shops/1
  # GET /shops/1.json
  def show
  end

  # GET /shops/new
  def new
    @shop = Shop.new
  end

  # GET /shops/1/edit
  def edit
  end

  # POST /shops
  # POST /shops.json
  def create
    @shop = Shop.new(shop_params)

    respond_to do |format|
      if @shop.save
        user  = User.find(current_user.id)
        user.shop_id = @shop.id

        if user.save
          format.html { redirect_to dashbords_path, notice: 'Settings was successfully Updated.' }
        else
          format.html { render :new }
        end
      else
        format.html { render :new }
      end
    end
  end

  # PATCH/PUT /shops/1
  # PATCH/PUT /shops/1.json
  def update
    respond_to do |format|
      if @shop.update(shop_params)
        format.html { redirect_to dashbords_path, notice: 'Settings was successfully Updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /shops/1
  # DELETE /shops/1.json
  def destroy
    @shop.destroy
    respond_to do |format|
      format.html { redirect_to shops_url, notice: 'Shop was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_shop
      @shop = Shop.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def shop_params
      params.require(:shop).permit(:shop_name, :shop_address, :shop_mobile, :shop_email, :shop_img)
    end
end
