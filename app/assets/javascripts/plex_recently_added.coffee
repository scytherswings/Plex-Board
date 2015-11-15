$(document).ready ->
  $("#carousel-inner").bind 'DOMSubtreeModified', ->
#    console.log "carousel-inner div was modified"
    if $("[id^=plex_session_]").length <= 1
      console.log "Show recently added"

      recently_added_item = $.parseJSON(e.data)
    else
      console.log "plex_session_exists, not showing recently added"




