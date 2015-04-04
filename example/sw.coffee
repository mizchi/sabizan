Sabizan = require '../src/index'

console.log('serviceworker started!')

self.addEventListener 'activate', (e) ->
  e.waitUntil(self.clients.claim())

# How to use
proxy = new Sabizan location.origin+'/api'
proxy.get '/users/:id', (req) ->
  {id} = req.params
  {foo} = req.query
  {id, foo}

proxy.post '/post', (req) ->
  # {type: 'posted'}
  debugger
  {type: 'this is post:'+req.params.prop}

self.onfetch = (event) ->
  event.request.json() # => body
  if proxy.isHandleScope event.request.url
    debugger
    event.respondWith(proxy.createResponse(event.request))

# push from worker
# cnt = 0
# setInterval =>
#   push cnt++ # use postmessage
#   clients.matchAll().then (m) ->
#   0].postmessage 'foo'
# , 1000
