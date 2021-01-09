var receiving = new function () {
  var me = this;

  this.pageLoad = function(searching){
    loadDatepicker();
    me.onNewItemRender();
    me.calculatePendingAmount();
    me.addNewRow();
    me.addDataTable(searching);

    $("button[type='submit']").click(function(){
      if (parseFloat($("#txtPaidAmount").val()) > parseFloat($("#txtTotalAmount").val())){
        toastr.options = {
          "closeButton": true,
          "debug": true,
          "newestOnTop": true,
          "progressBar": false,
          "positionClass": "toast-top-right",
          "preventDuplicates": false,
          "onclick": null
        }

        toastr["error"]("Paid amount cant be greater than pending amount");

        return false;
      }
    });
  }

  this.onNewItemRender = function(){
  	lookup.itemLookup();
    me.selectAllText();
    me.getBatchDetails();
    me.calculateItemTotal();
  }

  this.getBatchDetails = function(){
    if($("body").data("controller") == "billings") {
      $(".batchNumber").unbind("change");
      $(".batchNumber").bind("change", function(){
        let batchNumber = $(this).val();
        let itemId = $(this).parents("tr").find("input.itemId").val();
        let targetTr = $(this).parents("tr");

        $.ajax({
			  	cache: true,
          url: "/item_in_outs",
          dataType: "json",
          data: {
            key_item: itemId,
            key_batch: batchNumber
          },
          success: function(item_in_outs) {
            if (item_in_outs.length > 0) {
              let item_in_out = item_in_outs[0]
            
              targetTr.find(".manufactureDate").val(formatDate(item_in_out.manufacture_date));
              targetTr.find(".expiryDate").val(formatDate(item_in_out.expiry_date));
              targetTr.find(".currentQtyInStock").val(item_in_out.qty_left);
              targetTr.find(".itemRate").val(item_in_out.item_rate);
            }
          }
        });
      });
    }
  }

  this.selectAllText = function(){
  	$(".selectAllText").unbind("click");
  	$(".selectAllText").bind("click", function(){
  		this.setSelectionRange(0, this.value.length)
  	});
  }

  this.addNewRow = function(){
  	$(".add_fields").click(function(){
  		let time = new Date().getTime();
    	let regexp = new RegExp($(this).data('id'), 'g');
    	$("#renderDetails").append($(this).data('fields').replace(regexp, time));
      me.onNewItemRender();
  	});
  }

  this.deleteRow = function(thisA){
    $(thisA).parents("tr").remove();
    me.calculateTotalReceivingAmount();
  }

  this.calculateItemTotal = function(){
    $(".itemQuantity").unbind("change");
  	$(".itemQuantity").bind("change",function(){
      let itemQty = $(this).val();
      let itemRate = $(this).parents("tr").find("input.itemRate").val();
      let totalAmountInput = $(this).parents("tr").find(".itemTotal");

      if(itemRate && !isNaN(itemRate) && itemQty && !isNaN(itemQty)) {
        let totalAmount = parseFloat(itemQty)  * parseFloat(itemRate);
  
        $(totalAmountInput).val(totalAmount.toFixed(2));
        me.calculateTotalReceivingAmount();
      } else {
        $(totalAmountInput).val(0);
        me.calculateTotalReceivingAmount();
      }
  	});

    $(".itemRate").unbind("change");
  	$(".itemRate").bind("change", function(){
      let itemRate = $(this).val();
      let itemQty = $(this).parents("tr").find("input.itemQuantity").val();
      let totalAmountInput = $(this).parents("tr").find(".itemTotal");

      if(itemRate && !isNaN(itemRate) && itemQty && !isNaN(itemQty)){
        let totalAmount = parseFloat(itemQty) * parseFloat(itemRate);
        $(totalAmountInput).val(totalAmount.toFixed(2));
      } else {
        $(totalAmountInput).val(0);
        me.calculateTotalReceivingAmount();
      }
  	});
  }

  this.calculateTotalReceivingAmount = function(){
  	let totalAmount = 0;
  	$.each($("#renderDetails").find("tr"), function(){
  		totalAmount += parseFloat($(this).find(".itemTotal").val());
  	});

    $("#txtTotalAmount").val(totalAmount.toFixed(2));
    $("#txtPaidAmount").val(totalAmount.toFixed(2));

    if($("#txtPaidAmount").val() > 0) {
      let pendingAmount = parseFloat($("#txtTotalAmount").val()) - parseFloat($("#txtPaidAmount").val());
    
      $("#txtPendingAmount").val(pendingAmount.toFixed(2));
    } else {
      $("#txtPendingAmount").val(totalAmount.toFixed(2));
    }
  }

  this.calculatePendingAmount = function(){
    $("#txtPaidAmount").change(function(){
      let pendingAmount = parseFloat($("#txtTotalAmount").val()) - parseFloat($(this).val());
    
      $("#txtPendingAmount").val(pendingAmount.toFixed(2));
    });
  }

  this.addDataTable = function(searching){
    if (searching){
      let table = $("#detailsTable").DataTable({
        "fixedHeader": true,
        "scrollX": true
      });


      $("#exportButtons").parent("div").show();

      new $.fn.dataTable.Buttons(table, {
        buttons: [
          'copyHtml5',
          { 
            extend: 'excelHtml5',
            messageTop: me.getMessageTop(),
            messageBottom: me.getMessageBottom()
          },
          { 
            extend: 'pdfHtml5',
            messageTop: me.getMessageTop(),
            messageBottom: me.getMessageBottom()
          }
        ]
      }).container().appendTo($('#exportButtons'));
    } else {
      $("#detailsTable").DataTable({
        "ordering": false,
        "searching": false,
        "fixedHeader": true,
        "scrollX": true
      });
    }
  }

  this.getMessageTop = function(){
    let controller = $("body").data("controller");

    if(controller == "receivings") {
      return "Supplier name: " + $("#receiving_vendor_name").val() + ", Bill number: " + $("#receiving_bill_number").val()
    } else {
      return "Customer name: " + $("#billing_customer_name").val() + ", Customer number: " + $("#billing_contact_number1").val()
    }
  }

  this.getMessageBottom = function(){
    let controller = $("body").data("controller");

    if(controller == "receivings") {
      return "Total Amout: " + $("#txtTotalAmount").val()
    } else {
      return "Total Amount: " + $("#txtTotalAmount").val()
    }
  }
}