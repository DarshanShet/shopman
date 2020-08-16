class CreateBillings < ActiveRecord::Migration[5.0]
  def change
    create_table :billings do |t|
      t.references :customer,  index: true, foreign_key: true
      t.datetime :billing_date
      t.string :billing_number, limit: 20, null: false 
      t.decimal :total_amount, :precision => 12, :scale => 3, :default => 0
      t.decimal :paid_amount, :precision => 12, :scale => 3, :default => 0
      t.decimal :pending_amount, :precision => 12, :scale => 3, :default => 0

      t.timestamps
    end
  end
end
