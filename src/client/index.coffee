$(document).ready ->
  adjustLayout()
  
  ctx = $('#canvas')[0].getContext("2d")
  ctx.width = ctx.canvas.width
  ctx.height = ctx.canvas.height
  
  clearBackground ctx
  drawAlignmentGrid ctx
  
adjustLayout = ->
  canvasContainer = $('.canvasContainer')
  
  # Make canvas container take up remainder of page
  parentHeight = canvasContainer.offsetParent().height()
  offset = canvasContainer.offset().top
  canvasContainer.height(parentHeight - offset - 5)

  # Size the canvas to the container
  canvas = $('#canvas')
  canvas[0].width = canvasContainer.width()
  canvas[0].height = canvasContainer.height()

clearBackground = (ctx) ->
  ctx.fillStyle = '#000'
  ctx.fillRect 0, 0, ctx.width, ctx.height
  
drawAlignmentGrid = (ctx) ->
  ctx.beginPath()
  ctx.setStrokeColor '#333'

  ctx.arc ctx.width / 2, ctx.height / 2, 10, 0, Math.PI * 2, false
  
  ctx.moveTo ctx.width / 2, 0
  ctx.lineTo ctx.width / 2, ctx.height
  
  ctx.moveTo 0, ctx.height / 2
  ctx.lineTo ctx.width, ctx.height / 2

  ctx.stroke()
