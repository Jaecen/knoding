Q = require 'q'
Entity = require './entity.coffee'

class SystemController
  constructor: (@redis) ->
    
  getSystem: (req, res, next) =>
    systemName = req.params.system

    console.log "GET system #{ systemName }"

    @redis.sismember('_.systems', systemName)
    .then (result) =>
      console.log "\tSystem exists: #{ result }"
      if result == 0 then throw code: 404, message: 'System does not exist'
      @redis.smembers("#{ systemName }.entities")
    .then (result) =>
      console.log "\tEntity ID's: #{ result }"
      Q.all result.map (entityId) =>
        @redis.hgetall entityId
    .then (result) =>
      console.log "\tEntities: #{ result.length }"
      res.send name: systemName, entities: result
    .then(
      ((success) => success ),
      (error) => res.send error.code, new Error error.message)

  putSystem: (req, res, next) =>
    systemName = req.params.system

    console.log "PUT system #{ systemName }"

    # Reserve underscore
    if systemName == '_' then throw code: 403, reason: 'Invalid system name'
  
    @redis.sadd('_.systems', systemName)
    .then (result) =>
      if result == 0 then throw code: 409, reason: 'System already exists'
      res.send name: systemName
    .then(
      ((success) => success ),
      (error) => res.send error.code, new Error error.message)
  
  getEntity: (req, res, next) =>
    systemName = req.params.system
    entityName = req.params.entity
    entityId = "#{ systemName }.#{ entityName }"
    
    console.log "GET entity #{ entityId }"

    @redis.sismember('_.systems', systemName)
    .then (result) =>
      if result == 0 then throw code: 404, message: 'System does not exist'
      @redis.sismember "#{ systemName }.entities", entityId
    .then (result) =>
      if result == 0 then throw code: 404, message: 'Entity does not exist'
      @redis.hgetall entityId
    .then (result) =>
      res.send result
    .then(
      ((success) => success ),
      (error) => res.send error.code, new Error error.message)
  
  putEntity: (req, res, next) =>
    systemName = req.params.system
    entityName = req.params.entity
    entityRequest = req.body
    entityId = "#{ systemName }.#{ entityName }"
    
    console.log "PUT entity #{ entityId }"

    if entityRequest.mass == null then throw code: 400, reason: 'mass property required'
    if entityRequest.position == null then throw code: 400, reason: 'position property required'
    if entityRequest.velocity == null then throw code: 400, reason: 'velocity property required'

    entity = new Entity entityName, entityRequest.mass, entityRequest.position.x, entityRequest.position.y, entityRequest.velocity.x, entityRequest.velocity.y

    @redis.sismember('_.systems', systemName)
    .then (result) =>
      if result == 0 then throw code: 404, message: 'System does not exist'
      @redis.sadd "#{ systemName }.entities", entityId
    .then (result) =>
      if result == 0 then throw code: 409, message: 'Entity already exists'
      @redis.hmset entityId, entity
    .then (result) =>
      res.send entity
    .then(
      ((success) => success ),
      (error) => res.send error.code, new Error error.message)

module.exports = SystemController