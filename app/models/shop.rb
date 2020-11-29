class Shop < ApplicationRecord

  validates :shop_name,:shop_address,:shop_mobile,:shop_email, length: {maximum: 50}
end
