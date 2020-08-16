function searchForm(){
  $("#btnSearch").click(function(){
    $.ajax({
      cache: true,
      type: 'GET',
      url: $("#searchForm").attr("action"),
      dataType: 'script',
      data: $("#searchForm").serialize(),
      success: function(){
  
      },
      error: function(status, errors){
        console.log(errors);
      }
    });
  });
}

function loadDatepicker() {
  $('.datepicker').datepicker({
	   buttonImageOnly: false,
	   inline: true,
     showOtherMonths: true,
	   dateFormat: 'dd-mm-yy',
	   changeMonth: true,
	   changeYear: true,
     dayNamesMin: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
  });
}

$(document).on('turbolinks:load', function() {
  let controller = $("body").data("controller");
  let action = $("body").data("action");

  if(action == "index" && controller != "reports"){
    searchForm();
  }
  
  switch(controller) {
    case "billings":
      if(action == "new" || action == "index")
        lookup.customerLookup();

      if(action == "index"){
        loadDatepicker();
      } else if (action == "new" || action == "edit") {
        receiving.pageLoad();
      }
      break;
    case "receivings":
      if(action == "new"  || action == "index")
        lookup.vendorLookup();

      if(action == "index"){
        loadDatepicker();
      } else if (action == "new" || action == "edit") {
        receiving.pageLoad();
      }
      break;
    case "dashbords":
        dashbords.pageLoad();
      break;
    case "reports":
        loadDatepicker();
        lookup.customerLookup();
        lookup.vendorLookup();
      break;
  }
});