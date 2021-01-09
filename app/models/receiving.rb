class Receiving < ApplicationRecord
	
	belongs_to :vendor

	validates :receiving_number, presence: true, length: {maximum: 20}
	validates :receiving_date, presence: true
	validates :bill_number, length: {maximum: 20}
  validates :receiving_details, presence: true
  
	has_many :receiving_details, inverse_of: :receiving, :dependent => :destroy
	accepts_nested_attributes_for :receiving_details, :allow_destroy => true, reject_if: proc { |attributes| attributes['item_id'].blank? }

	attr_accessor :vendor_name, :contact_number1, :contact_number2, :contact_number3, :month
  
  after_create :create_item_in


  scope :get_receiving_by_year, -> (year) {
    where(receiving_date: Date.new(year,1,1)..Date.new(year,12,31))
  }

  scope :pending_amount_bills, -> { where("pending_amount > 0") }
  scope :sum_paid_amount, -> { sum(:paid_amount) }
  scope :sum_pending_amount, -> { sum(:pending_amount) }

  scope :filter_by_receiving_number, -> (key_receiving_number) { where(receiving_number: key_receiving_number.to_i < 9 ? "0#{key_receiving_number}" : key_receiving_number) }
  scope :filter_by_receiving_date, -> (key_receiving_date) { where(receiving_date: key_receiving_date.to_date) }
  scope :filter_by_receiving_date_range, -> (key_from_date, key_to_date) { where("receiving_date > ? and receiving_date < ?", (key_from_date.to_date - 1.day), (key_to_date.to_date + 1.day)) }
  scope :filter_by_vendor_id, -> (key_vendor_id) { where(vendor_id: key_vendor_id) }

	def self.get_next_number
		next_number = Receiving.maximum(:receiving_number).to_i + 1
		return next_number <= 9 ? "0#{next_number}" : next_number
  end
  
  def self.search(params)
    receiving = Receiving.includes(:vendor).order("created_at desc")
    receiving = receiving.filter_by_receiving_number(params[:key_receiving_number]) if params[:key_receiving_number].present?
    receiving = receiving.filter_by_receiving_date(params[:key_receiving_date]) if params[:key_receiving_date].present?
    receiving = receiving.filter_by_vendor_id(params[:key_vendor_id]) if params[:key_vendor_id].present?
    receiving
  end
  
  def self.sales_by_month
    @receiving_sales = Receiving.get_receiving_by_year(Date.current.year).select("receiving_date, sum(paid_amount) AS paid_amount").group('month(receiving_date)')
    
    month_sale = {}
    @receiving_sales.each do |receiving_sale|
      month_sale[receiving_sale.receiving_date.strftime("%b")] = receiving_sale.paid_amount
    end
    month_sale
  end

  def create_item_in
    ItemInOut.create_item_in(self)
  end
end
