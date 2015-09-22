
// $(document).ready(function(){
$(function hideStuff(){
  $('[id=service_service_type]').val( "Generic Service");
      $(function() {
      var serviceType = localStorage.getItem("serviceType");
      if(serviceType != null) {
        $("select[id=service_service_type]").val(serviceType);
          var value = $('#service_service_type').children("option").filter(":selected").text();
          if (value == "Generic Service"){
            $("#login_div").hide();
            $("#api_div").hide();
          }
          else if (value == "Plex" || value == "Deluge"){
            $("#login_div").show();
            $("#api_div").hide();
            $("#default_info_div").show();
            $("#url_div").show();
          }
          else {
            $("#login_div").show();
            $("#api_div").show();
            $("#default_info_div").show();
            $("#url_div").show();
          }
      }
      
      $("select[id=service_service_type]").on("change", function() {
        localStorage.setItem("serviceType", $(this).val());
      });
    });


  $( '#wrapper' ).on( 'click', 'select', function(){
    var value = $('#service_service_type').children("option").filter(":selected").text();
    if (value == "Generic Service"){
      $("#login_div").hide();
      $("#api_div").hide();
    }
    else if (value == "Plex" || value == "Deluge"){
      $("#login_div").show();
      $("#api_div").hide();
      $("#default_info_div").show();
      $("#url_div").show();
    }
    else {
     $("#login_div").show();
     $("#api_div").show();
     $("#default_info_div").show();
     $("#url_div").show();
    }
  });
});
// });

  // $("#service_service_type").change(function(){

$(document).on('page:load', function(){
  $(function hideStuff(){
  $('[id=service_service_type]').val( "Generic Service");
      $(function() {
      var serviceType = localStorage.getItem("serviceType");
      if(serviceType != null) {
        $("select[id=service_service_type]").val(serviceType);
          var value = $('#service_service_type').children("option").filter(":selected").text();
          if (value == "Generic Service"){
            $("#login_div").hide();
            $("#api_div").hide();
          }
          else if (value == "Plex" || value == "Deluge"){
            $("#login_div").show();
            $("#api_div").hide();
            $("#default_info_div").show();
            $("#url_div").show();
          }
          else {
            $("#login_div").show();
            $("#api_div").show();
            $("#default_info_div").show();
            $("#url_div").show();
          }
      }
      
      $("select[id=service_service_type]").on("change", function() {
        localStorage.setItem("serviceType", $(this).val());
      });
    });


  $( '#wrapper' ).on( 'click', 'select', function(){
    var value = $('#service_service_type').children("option").filter(":selected").text();
    if (value == "Generic Service"){
      $("#login_div").hide();
      $("#api_div").hide();
    }
    else if (value == "Plex" || value == "Deluge"){
      $("#login_div").show();
      $("#api_div").hide();
      $("#default_info_div").show();
      $("#url_div").show();
    }    
    else {
     $("#login_div").show();
     $("#api_div").show();
     $("#default_info_div").show();
     $("#url_div").show();
    }
  });
});
});

