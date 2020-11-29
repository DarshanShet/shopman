# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


uoms = [{
	code: "KG",
	name: "Kilogram"
}, {
	code: "PKT",
	name: "Packet"
}, {
	code: "Box",
	name: "Box"
}, {
	code: "Btl",
	name: "Bottle"
}]

Uom.create(uoms)

Shop.find_or_create_by!(shop_name: "Shopman") do |r|
	r.shop_address = "Sai Market, APMC, Near Axis Bank, Vashi"
	r.shop_mobile = "7208516101"
	r.shop_email = "darshan@shopman.com"
end