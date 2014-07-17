dpr = window.devicePixelRatio or 1
canvas = document.getElementsByTagName("canvas")[0]
header = document.getElementsByTagName("header")[0]
cta = document.getElementById "cta"
ctx = canvas.getContext("2d")
size = null
to = null
x = 0
y = 0
posx = true
posy = true


setup = ->
  # (Re)calculate sizes (if the window changes size etc)
  canvas.width = header.clientWidth
  canvas.height = header.clientHeight
  size = canvas.width + canvas.height

  x = ~~(Math.random() * canvas.width)
  y = ~~(Math.random() * canvas.height)


normalize = (c) ->
  return 255 if c > 255
  return 20  if c < 20
  return c


generateColors = (x, y) ->
  xc = ~~(256 * x / canvas.width) + 100
  yc = ~~(256 * x / canvas.width) + 100

  normalize xc
  normalize yc

  # Work out colors for the gradient
  colors =
    stop0 : "rgb(#{-xc}, #{xc}, #{yc})"
    stop1 : "rgb(#{-yc}, #{yc}, #{xc - 220})"

  # This is great for testing
  #colors.stop0 = "#fff"

  xc += 100
  yc += 100

  normalize xc
  normalize yc

  # Work out a color to keep the CTA's contrast sufficient
  colors.cta = "rgb(#{xc}, #{yc / 1.5}, #{xc / 2})"
  colors


createGradient = (x, y, colors) ->
  # Work out the size of the gradient radius
  rx = size * x / canvas.width
  ry = size * y / canvas.height

  # Create the gradient
  grad = ctx.createRadialGradient x, y, 0, rx, ry, size

  # Color it in
  grad.addColorStop 0.2, colors.stop0
  grad.addColorStop 1, colors.stop1

  # Add the gradient to the canvas
  ctx.fillStyle = grad
  ctx.fillRect 0, 0, canvas.width, canvas.height


run = ->
  posx = false if x >= canvas.width
  posy = false if y >= canvas.height
  posx = true if x <= 0
  posy = true if y <= 0
  i = ~~(Math.random() * (size * 2.75) / canvas.height)
  j = ~~(Math.random() * (size * 2.75) / canvas.width)

  if posx
    x += i
  else
    x -= i

  if posy
    y += j
  else
    y -= j

  colors = generateColors x, y
  createGradient x, y, colors
  cta.style.color = colors.cta

  to = setTimeout ->
    af = window.requestAnimationFrame(run)
  , 1000/48


# Run the setup() fn before anything
setup()
# If the window is resized, recalculate everything
window.onresize = setup
# Automatically wibble the canvas
if requestAnimationFrame?
  af = requestAnimationFrame(run)


# Override the animation when the mouse touches the page
# (don't even try if it's a touchscreen, it dies)
document.body.onmousemove = ->
  cancelAnimationFrame(af)
  clearTimeout(to)

  x = event.clientX
  y = event.clientY

  colors = generateColors x, y
  createGradient x, y, colors
  cta.style.color = colors.cta


# Analytics and stuff
analytics = ->
  ((i, s, o, g, r, a, m) ->
    i["GoogleAnalyticsObject"] = r
    i[r] = i[r] or ->
      (i[r].q = i[r].q or []).push arguments

    i[r].l = 1 * new Date()

    a = s.createElement(o)
    m = s.getElementsByTagName(o)[0]

    a.async = 1
    a.src = g
    m.parentNode.insertBefore a, m
  ) window, document, "script", "//www.google-analytics.com/analytics.js", "ga"


  ga 'create', 'UA-XXXXXXX-XX', 'example.com'
  ga 'send', 'pageview'
