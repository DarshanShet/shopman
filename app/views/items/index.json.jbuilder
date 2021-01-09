json.array!(@items) do |item|
  json.id item.id
  json.code item.code
  json.name item.name
  json.brand_name item.brand_name
  json.manufacture_by item.manufacture_by
  json.qty_in_stock item.qty_in_stock
  json.last_receiving_rate item.last_receiving_rate
  json.conversion_rate item.conversion_rate
  json.receiving_uom item.receiving_uom.code
end