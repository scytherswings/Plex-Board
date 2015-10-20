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
    console.log "Found the element!"
    console.log "Will replace with #{updated_progressbar}"
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



    console.log "Adding new session element #{new_session}"
    $("[id^=plex_session_]").last().after(new_session);



