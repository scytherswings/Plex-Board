source = new EventSource('/services/plex_now_playing')
source.addEventListener 'message', (e) ->
  plex_session = $.parseJSON(e.data)
#  console.log plex_session
  updated_progressbar = """
                         <div id="plex_progressbar_#{plex_session.session_id}"
                         class="progress-bar progress-bar-warning"
                         role="progressbar"
                         aria-valuenow="#{plex_session.progress}"
                         aria-valuemin="0" aria-valuemax="100"
                         style="width: #{plex_session.progress}%"></div>
                        """

  console.log "Plex session #{plex_session.session_id}"
#.length tests to make sure that the id actually has elements
  if $('#plex_session_' + plex_session.session_id).length
    console.log "Found the element!"
    console.log "Updating progress bar"
#    console.log "Will replace with #{updated_progressbar}"
    $('#plex_progressbar_' + plex_session.session_id).replaceWith(updated_progressbar)
  else
    console.log "Didn't find the element \"session #{plex_session.session_id}\""

    new_session = """
                  <div id="plex_session_#{plex_session.session_id}" class="item">
                    <div style="overflow: auto; height: 90%;">
                      <h2>Now Playing</h2>
                      <div class="thumbnail">
                        <img src="/images/#{plex_session.image}" alt="#{plex_session.session_id}" %>
                        <div class="progress now-playing-progress-bar" style="height: 5px">
                          <div id="plex_progressbar_#{plex_session.session_id}"
                             class="progress-bar progress-bar-warning"
                             role="progressbar"
                             aria-valuenow="#{plex_session.progress}"
                             aria-valuemin="0" aria-valuemax="100"
                             style="width: #{plex_session.progress}%">
                          </div>
                        </div>
                        <h3>#{plex_session.media_title}</h3>
                        <p>#{plex_session.description}</p>
                      </div>
                    </div>
                  </div>
                  """



    console.log "Adding new session element.."
    $("[id^=plex_session_]").last().after(new_session)

#Find all the existing elements on the page and compare them to the active ids we got in the SSE

  #set every plex_session as stale so we can remove the sessions that aren't found in the active sessions from the server
  stale_sessions = $.find("[id^=plex_session_]")
  console.log "Current active sessions: " + plex_session.active_sessions
  console.log "Length of current session array: " + stale_sessions.length
  #iterate over known sessions
  for i in [0...plex_session.active_sessions.length]
#    console.log "i = " + i
    console.log "Active session is: plex_session_" + plex_session.active_sessions[i]
    for j in [0...stale_sessions.length]
#      console.log "j = " + j
      console.log "Matching active session against: " + stale_sessions[j].id
      if stale_sessions[j].id == ("plex_session_" + plex_session.active_sessions[i])
        console.log "Match!"
        #at position i, remove one element from the array
        stale_sessions.splice(j, 1)
#        console.log "Updated stale sessions length should be one less: " + stale_sessions.length
        break
#      console.log "Known session: " + stale_sessions[j].id + " did not match active session: plex_session_" + plex_session.active_sessions[j]
#    console.log "Moving to next active session"

  for k in [0...stale_sessions.length]
    #find the elements by id and remove them from the page
    console.log "Session " + stale_sessions[k].id + " hidden is " + $("#plex_session_" + stale_sessions[k].id).is(":hidden")
    if $("#plex_session_#{stale_sessions[k].id}").is(":hidden")
      console.log "Stale element found, removing.."
      console.log "Removing element " + stale_sessions[k].id
      $("#" + stale_sessions[k].id).remove()