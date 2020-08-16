class CreateVendors < ActiveRecord::Migration[5.0]
  def change
    create_table :vendors do |t|
      t.string :name
      t.string :contact_number1
      t.string :contact_number2
      t.string :contact_number3
      t.string :address1
      t.string :address2

      t.timestamps
    end
  end
end
