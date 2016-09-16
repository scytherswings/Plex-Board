source = new EventSource('/services/notifications')

########### Service Online Status ############

source.addEventListener 'online_status', (e) ->
  service = $.parseJSON(e.data)
  console.log service
  console.log service.online_status
  html_offline = """
                 <div class="row" id="service_#{service.service_id}">
                   <div class="col-xs-2 col-sm-2 col-md-4 col-lg-4">
                    <table>
                     <tbody>
                       <tr>
                         <td>
                           <a class="h2_index_link" target="_blank" href="#{service.url}">
                             <button class="btn btn-xs btn-warning" style="width:62px">
                             <span class="glyphicon glyphicon-remove" style="color:white;"></span> Offline</button>
                           </a>
                          <div style="padding:1px"></div>
                         </td>
                         <td style="padding-left: 5px;">
                           <a class="h2_index_link" href="/services/#{service.service_id}">#{service.name}</a>
                         </td>
                       </tr>
                     </tbody>
                   </table>
                 </div>
                 """
  html_online = """
                <div class="row" id="service_#{service.service_id}">
                  <div class="col-xs-2 col-sm-2 col-md-4 col-lg-4">
                     <table>
                       <tbody>
                         <tr>
                           <td>
                             <a class="h2_index_link" target="_blank" href="#{service.url}">
                               <button class="btn btn-xs btn-success" style="width:62px">
                               <span class="glyphicon glyphicon-ok" style="color:white;"></span> Online</button>
                             </a>
                             <div style="padding:1px"></div>
                           </td>
                           <td style="padding-left: 5px;">
                               <a class="h2_index_link" href="/services/#{service.service_id}">#{service.name}</a>
                           </td>
                         </tr>
                       </tbody>
                     </table>
                  </div>
                </div>
                """


  if service.online_status is true
    console.log "service #{service.name} is online"
    if $('#service_' + service.service_id).length
#      console.log "we found the element"
#      console.log "replacing..."
#      console.log "will replace with #{html_online}"
    else
      console.log "we didn't find the element \"service #{service.service_id}\""
    $('#service_' + service.service_id).replaceWith(html_online)
  else
    console.log "service #{service.name} is not online"
    if $('#service_' + service.service_id).length
#      console.log "we found the element"
#      console.log "replacing..."
#      console.log "will replace with #{html_offline}"
    else
      console.log "we didn't find the element \"service #{service.service_id}\""
    $('#service_' + service.service_id).replaceWith(html_offline)



############# Plex Now Playing ################

source.addEventListener 'plex_now_playing', (e) ->
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

  #  console.log "Plex - Now Playing - session #{plex_session.session_id}"
  #.length tests to make sure that the id actually has elements
  if $('#plex_session_' + plex_session.session_id).length
#    console.log "PlexSession " + plex_session.session_id + " has active class? " + $("#plex_session_#{plex_session.session_id}").hasClass("active")
#    console.log "PlexSession " + plex_session.session_id + " has item class? " + $("#plex_session_#{plex_session.session_id}").hasClass("item")
#    console.log "Updating progress bar"
#    console.log "Will replace with #{updated_progressbar}"
    $('#plex_progressbar_' + plex_session.session_id).replaceWith(updated_progressbar)
  else
#    console.log "Didn't find the element \"session #{plex_session.session_id}\""

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


    #    console.log "Adding new session element.."
    if $("[id^=plex_recently_added_]")
      $("[id^=plex_recently_added_]").last().after(new_session)
    else if $("[id^=plex_session_]")
      $("[id^=plex_session_]").last().after(new_session)
    else
      $("[id^=carousel-inner]").append(new_session)

  #Find all the existing elements on the page and compare them to the active ids we got in the SSE

  #set every plex_session as stale so we can remove the sessions that aren't found in the active sessions from the server
  stale_sessions = $.find("[id^=plex_session_]")
  #  console.log "Current active sessions: " + plex_session.active_sessions
  #  console.log "Length of current session array: " + stale_sessions.length
  #iterate over known sessions
  for i in [0...plex_session.active_sessions.length]
#    console.log "i = " + i
#    console.log "Active session is: plex_session_" + plex_session.active_sessions[i]
    for j in [0...stale_sessions.length]
#      console.log "j = " + j
#      console.log "Matching active session against: " + stale_sessions[j].id
      if stale_sessions[j].id == ("plex_session_" + plex_session.active_sessions[i])
#        console.log "Match!"
#at position i, remove one element from the array
        stale_sessions.splice(j, 1)
        #        console.log "Updated stale sessions length should be one less: " + stale_sessions.length
        break
  #      console.log "Known session: " + stale_sessions[j].id + " did not match active session: plex_session_" + plex_session.active_sessions[j]
  #    console.log "Moving to next active session"
  #  console.log "PlexSession " + plex_session.session_id + " has active class? " + $("#plex_session_#{plex_session.session_id}").hasClass("active")
  #  console.log "PlexSession " + plex_session.session_id + " has item class? " + $("#plex_session_#{plex_session.session_id}").hasClass("item")
  for k in [0...stale_sessions.length]
#find the elements by id and remove them from the page
#    console.log "PlexSession " + stale_sessions[k].id + " visible is " + $("#plex_session_" + stale_sessions[k].id).is(":visible")
#    if !$("#plex_session_#{stale_sessions[k].id}").is(":visible")
#    console.log "PlexSession " + stale_sessions[k].id + " visible is " + $("#plex_session_" + stale_sessions[k].id).is(":visible")
#    if !$("#plex_session_#{stale_sessions[k].id}").is(":visible")
#    console.log "PlexSession " + stale_sessions[k].id + " has active class? " + $("#plex_session_#{stale_sessions[k].id}").hasClass("active")
#    console.log "PlexSession " + stale_sessions[k].id + " has item class? " + $("#plex_session_#{stale_sessions[k].id}").hasClass("item")
    if !$("#plex_session_#{stale_sessions[k].id}").hasClass("active")
#      console.log "Stale element found, removing.."
      console.log "Removing element " + stale_sessions[k].id
      $("#" + stale_sessions[k].id).remove()

source.addEventListener 'plex_recently_added', (e) ->
  pra = $.parseJSON(e.data)
  if $('div[id^=plex_session_]').length < 3
#    console.log "There were less than 3 plex_sessions, adding plex recently added"
    if $('#plex_recently_added_' + pra.id).length
#      console.log "The PRA element was found. Not adding it again."
    else
      console.log "ID of new pra: #{pra.id}"
      new_pra = """
                <div id="plex_recently_added_#{pra.id}" class="item">
                  <div style="overflow: auto; height: 90%;">
                    <h2>Recently Added</h2>
                    <div class="thumbnail">
                      <img src="/images/#{pra.image}" alt="#{pra.id}" %>
                      <h3>#{pra.media_title}</h3>
                      <p>#{pra.description}</p>
                      <p>#{pra.added_date}</p>
                    </div>
                  </div>
                </div>
                """
      if $("[id^=plex_session_]")
        $("[id^=plex_session_]").last().after(new_pra)
      else if $("[id^=plex_recently_added_]")
        $("[id^=plex_recently_added_]").last().after(new_pra)
      else
        $("[id^=carousel-inner]").append(new_pra)
#  else
#    console.log "There were more than three PlexSessions, not showing RecentlyAdded"


############# Weather ################

source.addEventListener 'weather', (e) ->
  weather = $.parseJSON(e.data)
  console.log("Here's the weather object id we got: " + weather.id)
  console.log(weather)
  $.get weather.self_uri, (data) ->
    $('#weather_' + weather.id).replaceWith(data)
#    console.log(data)
    return