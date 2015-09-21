source = new EventSource('/services/online_status')
source.addEventListener 'onlinestatus', (e) ->
    alert e.data