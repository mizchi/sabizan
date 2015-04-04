module.exports = (proxy) ->
  proxy.get '/users/:id', (req) ->
    {id} = req.params
    {foo} = req.query
    {id, foo}

  proxy.post '/users/:id', (req) ->
    {type: 'this is post:'+req.body.prop}
