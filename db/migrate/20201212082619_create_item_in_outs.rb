class CreateItemInOuts < ActiveRecord::Migration[5.0]
  def change
    create_table :item_in_outs do |t|
      t.string :document_in_number
      t.references :item, foreign_key: true
      t.string :batch_number
      t.datetime :manufacture_date
      t.datetime :expiry_date
      t.decimal :qty_in, :precision => 12, :scale => 3, :default => 0
      t.decimal :qty_out, :precision => 12, :scale => 3, :default => 0
      t.decimal :qty_left, :precision => 12, :scale => 3, :default => 0
      t.decimal :item_rate, :precision => 12, :scale => 3, :default => 0
      t.boolean :qty_left_ind, default: false, null: false
      
      t.timestamps null: false
    end
  end
end
