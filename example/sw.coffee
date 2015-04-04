console.log('serviceworker started!')
Sabizan = require '../src/index'

self.addEventListener 'activate', (e) ->
  e.waitUntil(self.clients.claim())

self.onfetch = (event) ->
  if proxy.isHandleScope event.request.url
    proxy.wrapFetchEvent(event)

proxy = new Sabizan location.origin+'/api'
require('./api')(proxy)

# push from worker
# cnt = 0
# setInterval =>
#   push cnt++ # use postmessage
#   clients.matchAll().then (m) ->
#   0].postmessage 'foo'
# , 1000
