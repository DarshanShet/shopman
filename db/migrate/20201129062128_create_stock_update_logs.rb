class CreateStockUpdateLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :stock_update_logs do |t|
      t.references :item, foreign_key: true
      t.decimal :old_stock
      t.decimal :new_stock
      t.decimal :discrepancy

      t.timestamps null: false
    end
  end
end
