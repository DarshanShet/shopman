class StockUpdateLog < ApplicationRecord
  belongs_to :item


  def self.create_log(item_id, old_stock_qty, new_stock_qty)
    StockUpdateLog.create({
      item_id: item_id,
      old_stock: old_stock_qty,
      new_stock: new_stock_qty,
      discrepancy: new_stock_qty - old_stock_qty
    })
  end
end
