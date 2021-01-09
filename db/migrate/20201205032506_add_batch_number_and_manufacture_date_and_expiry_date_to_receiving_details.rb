class AddBatchNumberAndManufactureDateAndExpiryDateToReceivingDetails < ActiveRecord::Migration[5.0]
  def change
    add_column :receiving_details, :batch_number, :string, limit: 20
    add_column :receiving_details, :manufacture_date, :datetime
    add_column :receiving_details, :expiry_date, :datetime
  end
end
