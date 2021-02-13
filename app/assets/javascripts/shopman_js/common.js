function searchForm(){
  $("#btnSearch").click(function(){
    $.ajax({
      cache: true,
      type: 'GET',
      url: $("#searchForm").attr("action"),
      dataType: 'script',
      data: $("#searchForm").serialize(),
      success: function(){},
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

function formatDate(dateObject) {
  if(dateObject && dateObject !== undefined){
    let d = new Date(dateObject);
    let day = d.getDate();
    let month = d.getMonth() + 1;
    let year = d.getFullYear();

    if (day < 10) {
      day = `0${day}`;
    }

    if (month < 10) {
      month = `0${month}`;
    }

    return `${day}-${month}-${year}`;
  } else {
    return dateObject
  }
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
      } else if (action == "new") {
        receiving.pageLoad(false);
      } else if (action == "edit") {
        receiving.pageLoad(true);
      } else {
        receiving.pageLoad(false);
      }
      break;
    case "receivings":
      if(action == "new"  || action == "index")
        lookup.vendorLookup();

      if(action == "index"){
        loadDatepicker();
      } else if (action == "new") {
        receiving.pageLoad(false);
      } else if (action == "edit") {
        receiving.pageLoad(true);
      } else {
        receiving.pageLoad(false);
      }
      break;
    case "dashbords":
        dashboards.pageLoad();
      break;
    case "reports":
        loadDatepicker();
        lookup.customerLookup();
        lookup.vendorLookup();
      break;
  }

  if ($("#btnFlot") !== undefined){
    $( "#btnFlot" ).draggable();
  }
});