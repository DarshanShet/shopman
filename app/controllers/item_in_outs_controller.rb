class ItemInOutsController < ApplicationController
  # GET /item_in_outs
  # GET /item_in_outs.json
  def index
    @item_in_outs = ItemInOut.search(params).page(params[:page]).per(per_page_count)

    respond_to do |format|
      format.json { @item_in_outs }
    end
  end
end