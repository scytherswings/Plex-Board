
// $(document).ready(function(){ 
$(function hideStuff(){
    $('[id=service_service_type]').val( "Plex");
  $( '#wrapper' ).on( 'click', 'select', function(){
  var value = $('#service_service_type').children("option").filter(":selected").text()
    if (value == "Generic Service"){
      $("#login_div").hide();
      $("#api_div").hide();
   }
    else 
     $("#login_div").show();
     $("#api)_div").show();
     $("#default_info_div").show();
     $("#url_div").show();
  });
});
// });

  // $("#service_service_type").change(function(){
    
    
$(document).on('page:load', hideStuff())

