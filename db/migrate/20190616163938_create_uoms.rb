class CreateUoms < ActiveRecord::Migration[5.0]
  def change
    create_table :uoms do |t|
      t.string :code, limit: 10, null: false 
      t.string :name, limit: 50, null: false

      t.timestamps
    end
  end
end
