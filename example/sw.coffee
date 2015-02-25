Sabizan = require '../src/index'

# How to use
router = new Sabizan location.origin+'/api'
router.get '/user/:id', ({id}, {foo}, req) ->
  {id, foo}

router.post '/post', ({}, params) ->
  {type: 'this is post:'+params.prop}

self.onfetch = (event) ->
  if router.isHandleScope event.request.url
    event.respondWith(router.createResponse(event.request))
