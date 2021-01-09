class Item < ApplicationRecord
	belongs_to :receiving_uom, class_name: 'Uom', :dependent => :destroy
	belongs_to :billing_uom, class_name: 'Uom', :dependent => :destroy

	validates :code, presence: true, length: {maximum: 10}, uniqueness: { case_sensitive: false }
	validates :name, presence: true, length: {maximum: 50}
  validates :brand_name, length: {maximum: 250}
  validates :manufacture_by, length: {maximum: 500}

  scope :qty_in_stock_greater_than_zero, -> { where("qty_in_stock > 0") }

  def self.search(params= {})
    items = Item.includes(:receiving_uom, :billing_uom).order(:name)
    items = items.where('LOWER(code) LIKE :term OR LOWER(name) LIKE :term', term: "#{params[:key_lookup].downcase}%") if params[:key_lookup].present?
    items = items.where('LOWER(name) LIKE ?', "%#{params[:key_item_name].downcase}%") if params[:key_item_name].present?
    items
  end
end
