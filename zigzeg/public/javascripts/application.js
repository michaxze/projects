$(function() {
  var faye = new Faye.Client('http://localhost:9292/faye');
  faye.subscribe("/account", function(data) {
    fetch_updates();
  });

  function fetch_updates()
  {
    $.ajax({
      type: "GET",
      url: "/update_listing_notification",
      success: function(data){
        if (parseInt(data.total) > 0) {
          $(".updates").text(data.total);
          $("#ziglist_updates").empty();
          $("#ziglist_updates").append(data.html);
          $(".updates").attr('href', '#updatesListing');
          $(".updates").attr('name', 'modal');
          $(".updates").removeClass("noHover");
          $(".updates").removeClass("noCursor");
        }else{
          $(".updates").addClass("noHover");
          $(".updates").addClass("noCursor");
          $(".updates").attr('href', '');
          $(".updates").attr('name', '');
          $(".updates").text(data.total);
        }
      }
    });
  }

});
