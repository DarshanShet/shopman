module ApplicationHelper

  def per_page_count
    return 7
  end

  def show_pagination(obj)
    paginate(obj, left: 1, right: 3)
  end

	def uoms_for_select
	  Uom.all.collect { |m| [m.code, m.id] }
	end

	def link_to_add_fields(name, f, association)
    new_object = f.object.send(association).klass.new
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s, f: builder)
    end
    button_tag(name, type: "button", class: "btn btn-sm btn-sm btn-primary add_fields", data: {id: id, fields: fields.gsub("\n", "")})
  end

  def display_date(date)
  	return date.present? ? date.to_date.strftime("%d-%m-%Y") : ""
  end

  def get_vendor_details(obj)
		return obj.present? && obj.vendor_id.present? ? obj.vendor : {name: "", contact_number1: "", contact_number2: ""}
  end

  def get_customer_details(obj)
		return obj.present? && obj.customer_id.present? ? obj.customer : {name: "", contact_number1: "", contact_number2: "", address1: "", address2: ""}
  end

  def get_item_details(obj)
    return obj.present? && obj.item_id.present? ? obj.item : { name: "", conversion_rate: 1, qty_in_stock: 0, brand_name: "", manufacture_by: ""}
  end

  def flash_message(type, text)
    flash[type] ||= []
    flash[type] << text
  end

  def nav_bar_class
    {
      "customers": "ni ni-circle-08",
      "vendors": "ni ni-shop",
      "receivings": "ni ni-delivery-fast",
      "billings": "ni ni-cart",
      "uoms": "ni ni-compass-04",
      "dashbords": "fa fa-home",
      "items": "ni ni-ruler-pencil",
      "reports": "ni ni-paper-diploma",
      "shops": "fa fa-cogs"
    }
  end

  def nav_bar_page_name
    {
      "customers": "Customers",
      "vendors": "Supplier",
      "receivings": "Receivings",
      "billings": "Billings",
      "uoms": "UNIT OF MEASUREMENT",
      "dashbords": "Dashboard",
      "items": "Items",
      "reports": "Reports",
      "shops": "Settings"
    }
  end

  def get_icon_class(name=nil)
    controller_name = name.present? ? name.to_sym : params[:controller].to_sym
    nav_bar_class[controller_name]
  end
  
  def get_page_name
    nav_bar_page_name[params[:controller].to_sym]
  end
end
