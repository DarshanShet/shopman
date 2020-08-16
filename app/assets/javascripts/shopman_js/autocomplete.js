var lookup = new function () {
    var me = this;

  this.itemLookup = function(){
		$(".itemLookup").autocomplete({
			source: function( request, response ) {
			  $.ajax({
			  	cache: true,
          url: "/items",
          dataType: "json",
          data: {
            key_lookup: request.term
          },
          success: function(data) {
          	var mapData = $.map(data, function (item) {
              return {
                label: `${item.name} (${item.qty_in_stock})`,
                name: item.name,
                value: item.id,
                last_receiving_rate: me.getReceivingRate(item),
                conversion_rate: item.conversion_rate == null || item.conversion_rate == undefined ? 1 : item.conversion_rate,
                qty_in_stock: item.qty_in_stock
              }
	          });
            response(mapData);
          }
        });
			},
      focus: function( event, ui ) {
        $(this).val( ui.item.name );
        return false;
      },
      select: function( event, ui ) {
        event.preventDefault();
        if ($(`.itemId[value='${ui.item.value}'`).length > 0) {
          $(this).val("");
          toastr.options = {
            "closeButton": true,
            "debug": true,
            "newestOnTop": true,
            "progressBar": true,
            "positionClass": "toast-top-right",
            "preventDuplicates": false,
            "onclick": null
            // "showDuration": "300",
            // "hideDuration": "5000",
            // "timeOut": "1500",
            // "extendedTimeOut": "500",
            // "showEasing": "swing",
            // "hideEasing": "linear",
            // "showMethod": "fadeIn",
            // "hideMethod": "fadeOut"
          }
          toastr["error"]('Item already selected can not select same item');
        } else {
          $(this).val(ui.item.name);
          $(this).siblings(".itemId").val(ui.item.value);
          $(this).parents("tr").find(".itemRate").val(ui.item.last_receiving_rate);
          $(this).parents("tr").find(".conversionRate").val(ui.item.conversion_rate);
          $(this).parents("tr").find(".currentQtyInStock").val(ui.item.qty_in_stock);
        }
      },
      change: function (event, ui) {
        if (ui.item == null || ui.item == undefined ) {
          $(this).val("");
          $(this).siblings("input.itemId").val("");
          $(this).parents("tr").find(".itemRate").val("");
          $(this).parents("tr").find(".conversionRate").val("");
          $(this).parents("tr").find(".currentQtyInStock").val("");
        }
        $(this).siblings("input.itemId").trigger('change');
      }
		});
  }

  this.vendorLookup = function(){
    var cache = {};
    $(".vendorLookup").autocomplete({
      source: function( request, response ) {
        var term = request.term;
        if ( term in cache ) {
          response( cache[ term ] );
          return;
        }

        $.ajax({
          cache: true,
          url: "/vendors",
          dataType: "json",
          data: {
            key_lookup: request.term
          },
          success: function(data) {
            var mapData = $.map(data, function (item) {
              return {
                label: item.name,
                value: item.id,
                contact_number1: item.contact_number1,
                contact_number2: item.contact_number2
              }
            });
            cache[term] = mapData;
            response(mapData);
          }
        });
      },
      focus: function( event, ui ) {
        $(this).val( ui.item.label );
        return false;
      },
      select: function( event, ui ) {
        event.preventDefault();
        $(this).val(ui.item.label);
        $(this).siblings(".vendorId").val(ui.item.value);
        $(".vendorContactNumber1").val(ui.item.contact_number1);
        $(".vendorContactNumber2").val(ui.item.contact_number2);
      },
      change: function (event, ui) {
        if (ui.item == null || ui.item == undefined ) {
          $(this).val("");
          $(this).siblings("input.vendorId").val("");
          $(".vendorContactNumber1").val("");
          $(".vendorContactNumber2").val("");
        }
        $(this).siblings("input.vendorId").trigger('change');
      }
    });
  }

  this.customerLookup = function(){
    var cache = {};
    $(".customerLookup").autocomplete({
      source: function( request, response ) {
        var term = request.term;
        if ( term in cache ) {
          response( cache[ term ] );
          return;
        }

        $.ajax({
          cache: true,
          url: "/customers",
          dataType: "json",
          data: {
            key_lookup: request.term
          },
          success: function(data) {
            var mapData = $.map(data, function (item) {
              return {
                label: item.name,
                value: item.id,
                contact_number1: item.contact_number1,
                contact_number2: item.contact_number2,
                address1: item.address1,
                address2: item.address2
              }
            });
            cache[term] = mapData;
            response(mapData);
          }
        });
      },
      focus: function( event, ui ) {
        $(this).val( ui.item.label );
        return false;
      },
      select: function( event, ui ) {
        event.preventDefault();
        $(this).val(ui.item.label);
        $(this).siblings(".customerId").val(ui.item.value);
        $(".customerContactNumber1").val(ui.item.contact_number1);
        $(".customerContactNumber2").val(ui.item.contact_number2);
        $(".customerAddress1").val(ui.item.address1);
        $(".customerAddress2").val(ui.item.address2);
      }
    });
  }

  this.getReceivingRate = function(item){
    let controller = $("body").data("controller");
    let receivingRate = 0;

    if (controller == "receivings") {
      receivingRate = item.last_receiving_rate
    } else {
      if (item.conversion_rate < 1){
        receivingRate = parseFloat(item.last_receiving_rate / (item.conversion_rate * 100)).toFixed(2)
      } else if (item.conversion_rate > 1) {
        receivingRate = parseFloat(item.last_receiving_rate / item.conversion_rate).toFixed(2)
      } else {
        receivingRate = item.last_receiving_rate;
      }
     
    }
    return receivingRate
  }
}