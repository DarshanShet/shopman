class Vendor < ApplicationRecord

  validates :name, presence: true
    
  def self.search(params)
    vendors = Vendor.order(:name)
    vendors = vendors.where('LOWER(name) LIKE ?', "%#{params[:key_lookup].downcase}%") if params[:key_lookup].present?
    vendors
  end
end
