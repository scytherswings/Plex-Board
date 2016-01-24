#$(document).on 'page:change', ->
#  $ ->
#    $('[id=service_service_type]').val 'Generic Service'
#    $ ->
#      serviceType = localStorage.getItem('serviceType')
#      if serviceType != null
#        $('select[id=service_service_type]').val serviceType
#        value = $('#service_service_type').children('option').filter(':selected').text()
#        if value == 'Generic Service'
#          $('#login_div').hide()
#          $('#api_div').hide()
#        else if value == 'Plex' or value == 'Deluge'
#          $('#login_div').show()
#          $('#api_div').hide()
#          $('#default_info_div').show()
#          $('#url_div').show()
#        else
#          $('#login_div').show()
#          $('#api_div').show()
#          $('#default_info_div').show()
#          $('#url_div').show()
#      $('select[id=service_service_type]').on 'change', ->
#        localStorage.setItem 'serviceType', $(this).val()
#        return
#      return
#    $('#wrapper').on 'click', 'select', ->
#      value = $('#service_service_type').children('option').filter(':selected').text()
#      if value == 'Generic Service'
#        $('#login_div').hide()
#        $('#api_div').hide()
#      else if value == 'Plex' or value == 'Deluge'
#        $('#login_div').show()
#        $('#api_div').hide()
#        $('#default_info_div').show()
#        $('#url_div').show()
#      else
#        $('#login_div').show()
#        $('#api_div').show()
#        $('#default_info_div').show()
#        $('#url_div').show()
#      return
#    return
#  return
#
#$(document).on 'page:load', ->
#  $ ->
#    $('[id=service_service_type]').val 'Generic Service'
#    $ ->
#      serviceType = localStorage.getItem('serviceType')
#      if serviceType != null
#        $('select[id=service_service_type]').val serviceType
#        value = $('#service_service_type').children('option').filter(':selected').text()
#        if value == 'Generic Service'
#          $('#login_div').hide()
#          $('#api_div').hide()
#        else if value == 'Plex' or value == 'Deluge'
#          $('#login_div').show()
#          $('#api_div').hide()
#          $('#default_info_div').show()
#          $('#url_div').show()
#        else
#          $('#login_div').show()
#          $('#api_div').show()
#          $('#default_info_div').show()
#          $('#url_div').show()
#      $('select[id=service_service_type]').on 'change', ->
#        localStorage.setItem 'serviceType', $(this).val()
#        return
#      return
#    $('#wrapper').on 'click', 'select', ->
#      value = $('#service_service_type').children('option').filter(':selected').text()
#      if value == 'Generic Service'
#        $('#login_div').hide()
#        $('#api_div').hide()
#      else if value == 'Plex' or value == 'Deluge'
#        $('#login_div').show()
#        $('#api_div').hide()
#        $('#default_info_div').show()
#        $('#url_div').show()
#      else
#        $('#login_div').show()
#        $('#api_div').show()
#        $('#default_info_div').show()
#        $('#url_div').show()
#      return
#    return
#  return
