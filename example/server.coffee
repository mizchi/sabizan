express = require('express')
app = express()
bodyParser = require('body-parser')

corser = require("corser")
app.use(corser.create())
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())
app.use(express.static(__dirname + '/'));
app.listen(3000)

Sabizan = require '../src/index'

proxy = new Sabizan.Server app, '/api'
require('./routes')(proxy)
