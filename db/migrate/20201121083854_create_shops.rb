class CreateShops < ActiveRecord::Migration[5.0]
  def change
    create_table :shops do |t|
      t.string :shop_name, limit: 50
      t.string :shop_address, limit: 500
      t.string :shop_mobile, limit: 50
      t.string :shop_email, limit: 50
      t.string :shop_img

      t.timestamps
    end
  end
end
