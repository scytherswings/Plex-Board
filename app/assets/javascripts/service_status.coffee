source = new EventSource('/services/online_status')
source.addEventListener 'message', (e) ->
  service = $.parseJSON(e.data)
  console.log service
  html_offline = """
                 <div class="row" id="service_#{service.service_id}">
                   <div class="col-lg-4">
                     <a class="services_link" target="_blank"
                      href="#{service.url}">
                       <button class="btn btn-xs btn-warning"
                        style="width:62px">
                       <span class="glyphicon glyphicon-remove"
                         style="color:white;"></span> Offline</button>
                       <div style="padding:1px"></div>
                     </a>
                   </div>
                   <div class="col-lg-8" style="padding-left:20px">
                     <a class="services_link"
                       href=
                       "/services/#{service.service_id}">#{service.name}</a>
                   </div>
                 </div>
                 """
  html_online = """
                <div class="row" id="service_#{service.service_id}">
                  <div class="col-lg-4">
                    <a class="services_link" target="_blank"
                      href="#{service.url}">
                      <button class="btn btn-xs btn-success" style="width:62px">
                      <span class="glyphicon glyphicon-ok"
                        style="color:white;"></span> Online</button>
                      <div style="padding:1px"></div>
                    </a>
                  </div>
                  <div class="col-lg-8" style="padding-left:20px">
                    <a class="services_link"
                      href="/services/#{service.service_id}">#{service.name}</a>
                  </div>
                </div>
                """


  if service.online_status is "true"
    console.log "service #{service.name} is online"
    if $('#service_' + service.service_id).length
      console.log "we found the element"
      console.log "will replace with #{html_online}"
    else
      console.log "we didn't find the element \"service #{service.service_id}\""
    $('#service_' + service.service_id).replaceWith(html_online)
  else
    console.log "service #{service.name} is not online"
    if $('#service_' + service.service_id).length
      console.log "we found the element"
      console.log "will replace with #{html_offline}"
    else
      console.log "we didn't find the element \"service #{service.service_id}\""
    $('#service_' + service.service_id).replaceWith(html_offline)
