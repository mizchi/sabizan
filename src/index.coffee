PathToRegexp = require 'path-to-regexp'
url = require 'url'

class Request
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
    @inNode = !@isServiceWorker

module.exports =
class Proxy
  constructor: (@root) ->
    @routes = [] # {path: Regexp, callback: Function}[]

  isHandleScope: (path) ->
    path.indexOf(@root) > -1

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

    if result instanceof Error
      new Response JSON.stringify({error: result.message}),
        status: 404
        headers:
          'Content-Type': 'application/json'
    else
      [route, match] = result
      debugger
      query = url.parse(request.url, true).query
      req = new Request {
        query: query
        params: match
        _request: request
        body: {}
      }

      if request.method is 'GET'
        Promise.resolve route.callback(req)
        .then (data) -> new Response JSON.stringify(data),
          status: 200
          headers:
            'Content-Type': 'application/json'
      else
        debugger
        request.json()
        .then (body) ->
          req.body = body
          debugger
          route.callback(request)
        .then (data) -> new Response JSON.stringify(data),
          status: 200
          headers:
            'Content-Type': 'application/json'
