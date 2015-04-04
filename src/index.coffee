PathToRegexp = require 'path-to-regexp'
url = require 'url'

module.exports =
class Sabizan
  constructor: (@root) ->
    @routes = [] # {path: Regexp, callback: Function}[]

  isHandleScope: (path) ->
    path.indexOf(@root) > -1

  wrapFetchEvent: (event) ->
    event.respondWith @createResponse(event.request)

  search: (method, path) ->
    for r in @routes when r.method is method
      m = r.regexp.exec(path)
      if m?
        match = {}
        for key, n in r.regexp.keys
          match[key.name] = m[n+1]
        return [r, match]
      else
        continue
    return new Error path+' is not routed to anywhere'

  route: (method, path, callback) ->
    @routes.push
      method: method
      regexp: PathToRegexp(path)
      callback: callback

  get: (path, callback) -> Promise.resolve @route 'GET', path, callback
  post: (path, callback) -> Promise.resolve @route 'POST', path, callback
  put: (path, callback) -> Promise.resolve @route 'PUT', path, callback
  patch: (path, callback) -> Promise.resolve @route 'PATCH', path, callback
  delete: (path, callback) -> Promise.resolve @route 'DELETE', path, callback

  # Request -> Response
  createResponse: (request) ->
    path = request.url
      .replace(@root, '') # strip
      .replace(url.parse(request.url).search, '')
    result = @search(request.method.toUpperCase(), path)
    [route, params] = result

    if result instanceof Error
      new Response JSON.stringify({error: result.message}),
        status: 404
        headers:
          'Content-Type': 'application/json'
    else
      query = url.parse(request.url, true).query
      r = new Request {
        query: query
        params: params
        _request: request
        body: {}
      }

      if request.method is 'GET'
        Promise.resolve route.callback(r)
        .then (data) -> new Response JSON.stringify(data),
          status: 200
          headers:
            'Content-Type': 'application/json'
      else
        request.json()
        .then (body) ->
          r.body = body
          route.callback(r)
        .then (data) ->
          new Response JSON.stringify(data),
            status: 200
            headers:
              'Content-Type': 'application/json'

class Sabizan.Server
  constructor: (@_app) ->
  wrap = (app, method, path, callback) ->
    app[method] path, (req, res) ->
      Promise.resolve(callback(req))
      .then (data) ->
        res.json data
  get: (path, callback) -> wrap @_app, 'get', path, callback
  put: (path, callback) -> wrap @_app, 'put', path, callback
  post: (path, callback) -> wrap @_app, 'post', path, callback
  patch: (path, callback) -> wrap @_app, 'patch', path, callback
  delete: (path, callback) -> wrap @_app, 'delete', path, callback

Request = class Sabizan.Request
  # query: Object
  # body: Object
  # params: Object
  # inNode: boolean
  # inServiceWorker: boolean
  # _request: Request
  constructor: (
    {@query, @body, @params, @_request}
  ) ->
    @inBrowser = ServiceWorkerGlobalScope?
    @inNode = !@inBrowser
