class CreateReceivings < ActiveRecord::Migration[5.0]
  def change
    create_table :receivings do |t|
      t.references :vendor,  index: true, foreign_key: true
      t.datetime :receiving_date
      t.string :receiving_number, limit: 20, null: false 
      t.string :bill_number, limit: 20 
      t.datetime :bill_date
      t.decimal :total_amount, :precision => 12, :scale => 3, :default => 0
      t.decimal :paid_amount, :precision => 12, :scale => 3, :default => 0
      t.decimal :pending_amount, :precision => 12, :scale => 3, :default => 0

      t.timestamps
    end
  end
end
