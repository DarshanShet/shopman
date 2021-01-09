class BillingDetail < ApplicationRecord
  after_create :update_qty_in_stock
  
  belongs_to :billing
  belongs_to :item

	validates :item, :item_rate, :item_quantity, :item_total, presence: true
	validates :item_quantity, :item_rate, :item_total, numericality: { greater_than: 0 }
  validates :batch_number, presence: true, length: {maximum: 20}
  
  validate :item_qty_in_stock, on: :create

  attr_accessor :item_name, :brand_name, :manufacture_by, :uom

  # def item_qty_in_stock
  #   item = Item.find(self.item_id)
  #   next_qty_in_stock = item.qty_in_stock - self.item_quantity

  #   if next_qty_in_stock < 0
  #     errors.add(:item_quantity, "#{item.name} quantity in stock less than zero ")
  #   end
  # end

  def item_qty_in_stock
    item_in_out_qty = ItemInOut.where(item_id: self.item_id, batch_number: self.batch_number, qty_left_ind: true).sum(:qty_left)
    next_qty_in_stock = item_in_out_qty - self.item_quantity

    if next_qty_in_stock < 0
      errors.add(:item_quantity, "#{self.item.name} quantity in stock less than zero for batch number #{self.batch_number}")
    end
  end


	def update_qty_in_stock
    item = Item.find(self.item_id)
    item.update_attributes(qty_in_stock: (item.qty_in_stock - self.item_quantity))
  end
  
  def self.top_selling_items
    sql = <<-SQL 
      SELECT items.code, items.name, SUM(billing_details.item_quantity) AS total_quantity
      FROM billing_details 
      INNER JOIN items on billing_details.item_id = items.id
      INNER JOIN billings on billing_details.billing_id = billings.id
      WHERE (`billings`.`billing_date` BETWEEN MAKEDATE(year(now()),1) AND DATE_FORMAT(NOW(),'%Y-12-31'))
      GROUP BY code
      ORDER BY total_quantity DESC
      LIMIT 10;
    SQL

    results = ActiveRecord::Base.connection.exec_query(sql)
    return results.to_a
  end

end
