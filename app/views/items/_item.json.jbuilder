json.extract! item, :id, :code, :name, :qty_in_stock, :last_receiving_rate, :receiving_uom, :conversion_rate, :billing_uom, :created_at, :updated_at
json.url item_url(item, format: :json)
