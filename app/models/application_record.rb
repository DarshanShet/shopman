class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.open_spreadsheet(file)
	  case File.extname(file.original_filename)
		  when ".csv" then Roo::CSV.new(file.path, nil, :ignore)
		  when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
		  when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
		  else raise "Unknown file type: #{file.original_filename}"
  	end
  end
  
  def self.year_sales
    month_sale = sales_by_month

    year_sale = {}
    beginning_of_month_date_list.each do |month|
      year_sale[month] = 0
      year_sale[month] = month_sale[month].to_f if month_sale[month].present?
    end

    year_sale
  end

  def self.beginning_of_month_date_list
    start = Time.now.beginning_of_year
    finish = Time.now.end_of_year
    (start.to_date..finish.to_date).map(&:beginning_of_month).uniq.map{ |date| date.strftime("%b")}
  end
  
end
