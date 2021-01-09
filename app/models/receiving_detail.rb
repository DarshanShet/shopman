class ReceivingDetail < ApplicationRecord
	belongs_to :item
	belongs_to :receiving

	validates :item, :item_rate, :item_quantity, :item_total, presence: true
	validates :item_quantity, :item_rate, :item_total, numericality: { greater_than: 0 }
  validates :batch_number, presence: true, length: {maximum: 20}

	attr_accessor :item_name, :brand_name, :manufacture_by, :uom

	after_create :update_qty_in_stock


	def update_qty_in_stock
		item = Item.find(self.item_id)
		item.update_attributes(qty_in_stock: (item.qty_in_stock + self.item_quantity) , last_receiving_rate: self.item_rate)
	end
end
