class AddBatchNumberAndManufactureDateAndExpiryDateToBillingDetails < ActiveRecord::Migration[5.0]
  def change
    add_column :billing_details, :batch_number, :string, limit: 20
    add_column :billing_details, :manufacture_date, :datetime
    add_column :billing_details, :expiry_date, :datetime
  end
end
