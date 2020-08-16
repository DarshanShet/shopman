class Uom < ApplicationRecord
	validates :code, presence: true, length: {maximum: 10}, uniqueness: { case_sensitive: false }
	validates :name, presence: true, length: {maximum: 50}

  def self.search(params)
    uoms = Uom.order(:name)
    uoms = uoms.where('LOWER(name) LIKE ?', "%#{params[:key_uom_name].downcase}%") if params[:key_uom_name].present?
    uoms
  end
end
