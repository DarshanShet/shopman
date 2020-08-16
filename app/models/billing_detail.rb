class BillingDetail < ApplicationRecord
  attr_accessor :item_name

  after_create :update_qty_in_stock
  
  belongs_to :billing
  belongs_to :item

	validates :item, :item_rate, :item_quantity, :item_total, presence: true
	validates :item_quantity, :item_rate, :item_total, numericality: { greater_than: 0 }

  validate :item_qty_in_stock, on: :create

  def item_qty_in_stock
    item = Item.find(self.item_id)
    next_qty_in_stock = item.qty_in_stock - self.item_quantity

    if next_qty_in_stock < 0
      errors.add(:item_quantity, "#{item.name} quantity in stock less than zero ")
    end
  end

	def update_qty_in_stock
    item = Item.find(self.item_id)
    item.update_attributes(qty_in_stock: (item.qty_in_stock - self.item_quantity))
	end
end
