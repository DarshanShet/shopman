var receiving = new function () {
  var me = this;

  this.pageLoad = function(){
    loadDatepicker();
    me.onNewItemRender();
    me.calculatePendingAmount();
    me.addNewRow();

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
    })
  }

  this.onNewItemRender = function(){
  	lookup.itemLookup();
    me.selectAllText();
    me.calculateItemTotal();
  }

  this.selectAllText = function(){
  	$(".selectAllText").unbind("click");
  	$(".selectAllText").bind("click", function(){
  		this.setSelectionRange(0, this.value.length)
  	});
  }

  this.addNewRow = function(){
  	$(".add_fields").click(function(){
  		var time = new Date().getTime();
    	var regexp = new RegExp($(this).data('id'), 'g');
    	$("#renderDetails").append($(this).data('fields').replace(regexp, time));
    	me.onNewItemRender();
  	});
  }

  this.calculateItemTotal = function(){
    $(".selectAllText").unbind("change");
  	$(".itemQuantity").bind("change",function(){
  		var itemQty = $(this).val();
      var itemRate = $(this).parents("tr").find("input.itemRate").val();
  		//var conversionRate = $(this).parents("tr").find("input.conversionRate").val();
      
  		var totalAmoutInput = $(this).parents("tr").find(".itemTotal");

  		var totalAmout = parseFloat(itemQty)  * parseFloat(itemRate);

  		$(totalAmoutInput).val(totalAmout.toFixed(2));
  		me.calculateTotalReceivingAmout();
  	});

    $(".itemRate").unbind("change");
  	$(".itemRate").bind("change", function(){
  		var itemRate = $(this).val();
  		var itemQty = $(this).parents("tr").find("input.itemQuantity").val();
  		var totalAmoutInput = $(this).parents("tr").find(".itemTotal");

  		var totalAmout = parseFloat(itemQty) * parseFloat(itemRate);

  		$(totalAmoutInput).val(totalAmout.toFixed(2));
  		me.calculateTotalReceivingAmout();
  	});
  }

  this.calculateTotalReceivingAmout = function(){
  	var totalAmout = 0;
  	$.each($("#renderDetails").find("tr"), function(){
  		totalAmout += parseFloat($(this).find(".itemTotal").val());
  	});

    $("#txtTotalAmount").val(totalAmout.toFixed(2));
    $("#txtPaidAmount").val(totalAmout.toFixed(2));

    if($("#txtPaidAmount").val() > 0) {
      var pendingAmount = parseFloat($("#txtTotalAmount").val()) - parseFloat($("#txtPaidAmount").val());
    
      $("#txtPendingAmount").val(pendingAmount.toFixed(2));
    } else {
      $("#txtPendingAmount").val(totalAmout.toFixed(2));
    }
  }

  this.calculatePendingAmount = function(){
    $("#txtPaidAmount").change(function(){
      var pendingAmount = parseFloat($("#txtTotalAmount").val()) - parseFloat($(this).val());
    
      $("#txtPendingAmount").val(pendingAmount.toFixed(2));
    });
  }
}