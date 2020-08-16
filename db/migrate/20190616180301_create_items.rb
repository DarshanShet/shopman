class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string :code, limit: 10, null: false 
      t.string :name, limit: 50, null: false 
      t.decimal :qty_in_stock, :precision => 12, :scale => 3, :default => 0
      t.decimal :last_receiving_rate, :precision => 12, :scale => 3, :default => 0
      t.decimal :conversion_rate, :precision => 12, :scale => 3, :default => 1
      t.decimal :adjustmented_qty, :precision => 12, :scale => 3, :default => 0
      
      t.timestamps
    end
      add_reference :items, :receiving_uom, references: :uoms
      add_reference :items, :billing_uom, references: :uoms

  end
end
