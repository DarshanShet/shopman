class AddShopToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :shop, foreign_key: true
  end
end
