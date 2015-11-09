$(document).ready ->
  $("#carousel-inner").bind 'DOMSubtreeModified', ->
#    console.log "carousel-inner div was modified"
    if $("[id^=plex_session_").length
#      console.log "plex_session_exists, not showing recently added"
    else
      console.log "Show recently added"

