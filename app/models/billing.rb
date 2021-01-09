class Billing < ApplicationRecord
  belongs_to :customer

  validates :billing_number, presence: true, length: {maximum: 20}
	validates :billing_date, presence: true
  validates :billing_details, presence: true

	has_many :billing_details, inverse_of: :billing, :dependent => :destroy
	accepts_nested_attributes_for :billing_details, :allow_destroy => true, reject_if: proc { |attributes| attributes['item_id'].blank? }

	attr_accessor :customer_name, :contact_number1, :contact_number2, :address1, :address2

  after_create :update_item_out

  scope :get_billing_by_year, -> (year){
    where(billing_date: Date.new(year,1,1)..Date.new(year,12,31))
  }

  scope :pending_amount_bills, -> { where("pending_amount > 0") }
  scope :sum_paid_amount, -> { sum(:paid_amount) }
  scope :sum_pending_amount, -> { sum(:pending_amount) }

  scope :filter_by_billings_number, -> (key_billings_number) { where(billings_number: key_billings_number.to_i < 9 ? "0#{key_billings_number}" : key_billings_number ) }
  scope :filter_by_bill_date, -> (key_billings_date) { where(billing_date: key_billings_date.to_date) }
  scope :filter_by_bill_date_range, -> (key_from_date, key_to_date) { where("billing_date > ? and billing_date < ?", (key_from_date.to_date - 1.day), (key_to_date.to_date + 1.day)) }
  scope :filter_by_customer_id, -> (key_customer_id) { where(customer_id: key_customer_id) }

	def self.get_next_number
		next_number = Billing.maximum(:billing_number).to_i + 1
		return next_number <= 9 ? "0#{next_number}" : next_number
  end
  
  def self.search(params)
    billings = Billing.includes(:customer).order("created_at desc")
    billings = billings.filter_by_billings_number(params[:key_billings_number]) if params[:key_billings_number].present?
    billings = billings.filter_by_bill_date(params[:key_billings_date]) if params[:key_billings_date].present?
    billings = billings.filter_by_customer_id(params[:key_customer_id]) if params[:key_customer_id].present?
    billings
  end
  
  def self.sales_by_month
    @billing_sales = Billing.get_billing_by_year(Date.current.year).select("billing_date, sum(paid_amount) AS paid_amount").group('month(billing_date)')
    
    month_sale = {}
    @billing_sales.each do |billing_sale|
      month_sale[billing_sale.billing_date.strftime("%b")] = billing_sale.paid_amount
    end
    month_sale
  end

  def self.last_year_sale
    @last_year_sale = Billing.get_billing_by_year(Date.current.year - 1).sum_paid_amount
  end

  def update_item_out
    ItemInOut.update_item_out(self)
  end
end
