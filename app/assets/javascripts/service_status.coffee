source = new EventSource('/services/online_status')
source.addEventListener 'message', (e) ->
  service = $.parseJSON(e.data)
  console.log service
  console.log service.service_id
  console.log service.name
  console.log service.online_status
  if service.online_status is true
    $("#service #{service.service_id}").replaceWith("""
      <div class="row" id="service #{service.service_id}">
        <div class="col-lg-4">
          <a class="services_link" target="_blank" href="#{service.url}">
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
    """)
  else
    $("#service #{service.service_id}").replaceWith("""
      <div class="row" id="service #{service.service_id}">
        <div class="col-lg-4">
          <a class="services_link" target="_blank" href="#{service.url}">
            <button class="btn btn-xs btn-warning" style="width:62px">
            <span class="glyphicon glyphicon-remove"
              style="color:white;"></span> Offline</button>
            <div style="padding:1px"></div>
          </a>
        </div>
        <div class="col-lg-8" style="padding-left:20px">
          <a class="services_link"
            href="/services/#{service.service_id}">#{service.name}</a>
        </div>
      </div>
    """)