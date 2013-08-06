class Entity
  constructor: (@name, mass, positionX, positionY, velocityX, velocityY) ->
    @mass = Number(mass ? 1)
    @position_x = Number(positionX ? 0)
    @position_y = Number(positionY ? 0)
    @velocity_x = Number(velocityX ? 0)
    @velocity_y = Number(velocityY ? 0)

module.exports = Entity