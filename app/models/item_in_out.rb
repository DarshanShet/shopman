class ItemInOut < ApplicationRecord
  belongs_to :item

  scope :filter_qty_left_ind, -> { where(qty_left_ind: true) }
  scope :filter_by_item, -> (key_item) { where(item_id: key_item) }
  scope :filter_by_batch_number, -> (key_batch) { where(batch_number: key_batch) }

  def self.search(params= {})
    item_in_outs = ItemInOut.order("created_at")
    item_in_outs = item_in_outs.filter_by_item(params[:key_item]) if params[:key_item].present?
    item_in_outs = item_in_outs.filter_by_batch_number(params[:key_batch]) if params[:key_batch].present?
    #item_in_outs = item_in_outs.filter_qty_left_ind
    item_in_outs
  end

  def self.create_item_in(receiving)
    receiving.receiving_details.each do |detail|
      ItemInOut.create({
        document_in_number: receiving.receiving_number,
        item_id: detail.item_id,
        batch_number: detail.batch_number,
        manufacture_date: detail.manufacture_date,
        expiry_date: detail.expiry_date,
        qty_in: detail.item_quantity,
        qty_out: 0,
        qty_left: detail.item_quantity,
        item_rate: detail.item_rate,
        qty_left_ind: true
      })
    end
  end

  def self.update_item_out(billing)
    billing.billing_details.each do |detail|
      item_in_outs = ItemInOut.where(item_id: detail.item_id, batch_number: detail.batch_number, qty_left_ind: true)
      qty_bill = detail.item_quantity

      item_in_outs.each do |item_in_out|
        balance_qty = item_in_out.qty_left
        qty_out = item_in_out.qty_out + qty_bill
        qty_left = item_in_out.qty_in - qty_out
        if  balance_qty >= qty_bill
          item_in_out.update(
            qty_out: qty_out,
            qty_left: qty_left,
            qty_left_ind: qty_left == 0 ? false : true
          )
          qty_bill -= qty_bill
          break
        else
          item_in_out.update(
            qty_out: qty_out,
            qty_left: qty_left,
            qty_left_ind: qty_left == 0 ? false : true
          )
          qty_bill -= balance_qty
        end
      end

      if qty_bill > 0
        raise RuntimeError, "Quantity left is less than quantity to be billed for item " << detail.item.code
      end
    end
  end
end
