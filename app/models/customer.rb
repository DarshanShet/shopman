class Customer < ApplicationRecord

  validates :name, presence: true
  
  def self.search(params)
    customers = Customer.order(:name)
    customers = customers.where('LOWER(name) LIKE ?', "%#{params[:key_lookup].downcase}%") if params[:key_lookup].present?
    customers
  end
end
