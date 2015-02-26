# Sabizan

Sabizan is network proxy by ServiceWorker.
Tested on Chrome Canary 43.

```
npm install sabizan --save
```

## Goal

1. Behave as isomorphic middle layer
2. Mock network request for test

## How to use

Sabizan only works in ServiceWorker.

```coffee
Sabizan = require 'sabizan' # with browserify or importScript('dist/sabizan.js')
proxy = new Sabizan location.origin+'/api'

# it will respond to https://localhost:3000/api/user/fuga?foo=bar
proxy.get '/user/:id', ({id}, {foo}, req) ->
  {id, foo}

# Return with promise
proxy.post '/post', ({}, body) ->
  new Promise (done) ->
    setTimeout ->
      done {type: 'this is post:'+params.prop}
    , 300

self.onfetch = (event) ->
  if proxy.isHandleScope event.request.url
    event.respondWith(proxy.createResponse(event.request))
```

See example detail

## Build

```
$ npm install
$ npm run build
```

## TODO

- Test
- Documentation

## LICENSE

MIT
