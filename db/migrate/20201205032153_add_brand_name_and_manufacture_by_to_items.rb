class AddBrandNameAndManufactureByToItems < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :brand_name, :string, limit: 250
    add_column :items, :manufacture_by, :string, limit: 500
  end
end
