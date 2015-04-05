module.exports = (router) ->
  # req.params
  # req.query
  # req.body
  router.get '/users/:id', (req) ->
    {id} = req.params
    {foo} = req.query
    {id, foo}

  router.post '/users/:id', (req) ->
    {type: 'this is post:'+req.body.prop}
