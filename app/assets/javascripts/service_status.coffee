source = new EventSource('/services/online_status')
source.addEventListener 'online_status', (e) ->
  alert e.data