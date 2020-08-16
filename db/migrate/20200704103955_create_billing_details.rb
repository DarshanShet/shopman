class CreateBillingDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :billing_details do |t|
      t.references :billing, index: true, foreign_key: true
      t.references :item, index: true, foreign_key: true
      t.decimal :item_rate, :precision => 12, :scale => 3, :default => 0
      t.decimal :item_quantity, :precision => 12, :scale => 3, :default => 0
      t.decimal :item_total, :precision => 12, :scale => 3, :default => 0

      t.timestamps
    end
  end
end
