require 'whatwg-fetch'

# window.addEventListener 'load', =>
#   navigator.serviceWorker.register 'sw.js', scope: '.'
#   .then (r) ->
#     console.log('service-worker registered')
#   .catch (whut) ->
#     console.error('fail to register', whut)

window.start = ->
  navigator.serviceWorker.register 'sw.js', scope: '.'
  .then (r) ->
    console.log('service-worker registered')
  .catch (whut) ->
    console.error('fail to register', whut)

window.sendGetId = ->
  fetch 'api/users/mizchi?foo=faaaa',
    method: 'GET'
  .then (res) => res.json()
  .then (json) => console.log json

window.sendPost = ->
  body = JSON.stringify({prop: 'is body prop'})
  fetch 'api/users/mizchi?aaa=aaa',
    method: 'POST'
    headers:
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    body: body
  .then (res) =>
    res.json()
  .then (json) =>
    console.log json
