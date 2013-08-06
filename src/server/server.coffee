restify = require 'restify'
thenRedis = require 'then-redis'
SystemController = require './systemController.coffee'

redis = thenRedis.createClient()
systemController = new SystemController redis

# Setup server
server = restify.createServer()
server.use restify.bodyParser mapParams: false

server.get 'system/:system', systemController.getSystem
server.put 'system/:system', systemController.putSystem
server.get 'system/:system/:entity', systemController.getEntity
server.put 'system/:system/:entity', systemController.putEntity

server.listen 1337, -> console.log "#{ server.name } listening at #{ server.url }"