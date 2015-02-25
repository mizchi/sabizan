Sabizan = require '../src/index'

# How to use
proxy = new Sabizan location.origin+'/api'
proxy.get '/user/:id', ({id}, {foo}, req) ->
  {id, foo}

proxy.post '/post', ({}, params) ->
  {type: 'this is post:'+params.prop}

self.onfetch = (event) ->
  if proxy.isHandleScope event.request.url
    event.respondWith(proxy.createResponse(event.request))
