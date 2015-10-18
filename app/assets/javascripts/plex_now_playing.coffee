source = new EventSource('/services/plex_now_playing')
source.addEventListener 'message', (e) ->
  plex_session = $.parseJSON(e.data)
  console.log plex_session
  updated_progressbar = """
                         <div id="plex_progressbar_#{plex_session.session_id}"
                         class="progress-bar progress-bar-warning"
                         role="progressbar"
                         aria-valuenow="#{plex_session.progress}"
                         aria-valuemin="0" aria-valuemax="100"
                         style="width: #{plex_session.progress}%"></div>
                        """

  console.log "Plex session #{plex_session.session_id}"
#I don't remember what this does. That's why you always comment your code, kids
  if $('#plex_session_' + plex_session.session_id).length
    console.log "we found the element"
    console.log "will replace with #{updated_progressbar}"
    $('#plex_progressbar_' + plex_session.session_id).replaceWith(updated_progressbar)
  else
    console.log "we didn't find the element \"session #{plex_session.session_id}\""
    console.log "adding new session element"
    $('#plex_session_' + plex_session.session_id).append



