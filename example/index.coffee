require 'whatwg-fetch'

window.addEventListener 'load', =>
  navigator.serviceWorker.register 'sw.js', scope: '.'
  .then (r) ->
    console.log('service-worker registered')
  .catch (whut) ->
    console.error('fail to register', whut)

window.sendGetId = ->
  fetch 'api/user/mizchi?foo=faaaa',
    method: 'GET'
  .then (res) => res.json()
  .then (json) => console.log json

window.sendPost = ->
  fetch 'api/post',
    method: 'POST'
    bodyUsed: true
    headers:
      'Accept': 'application/json',
      'Content-Type': 'application/json'
    body: JSON.stringify({prop: 'is body prop'})
  .then (res) => res.json()
  .then (json) => console.log json
