///|
let canvas : @dom.HTMLCanvasElement = document.querySelector("#canvas")

///|
fn scale_size() -> Double {
  window.devicePixelRatio().round() + 1
}

///|
fn resize() -> Unit {
  let dpr = scale_size().to_int()
  let width = window.innerWidth()
  let height = window.innerHeight()
  canvas.set_width(width * dpr)
  canvas.set_height(height * dpr)
  fn to_px(v : Int) {
    "\{v}px"
  }

  canvas.style().setProperty("width", to_px(width))
  canvas.style().setProperty("height", to_px(height))
  let ctx = canvas.getContext("2d")
  ctx.scale(dpr, dpr)
}

///|
let ctx : Canvas2D = canvas.getContext("2d")

///|
let white : Color = hsl(0, 0, 100)

///|
let black : Color = hsl(0, 0, 0)

///|
let yellow : Color = hsl(60, 100, 50)

///|
let font : Font = { ..Font::default(), weight: 320 }

///|
fn render() -> Unit {
  let e1 = Element::ellipse(
    center={ x: 0, y: 0 },
    strokeColor=yellow,
    fillColor=white,
    radiusX=100,
    radiusY=50,
    rotation=@math.PI / 2,
    startAngle=0,
    endAngle=@math.PI * 2,
    counterclockwise=false,
    lineWidth=10,
  )
  let e2 = Element::ellipse(
    center={ x: 0, y: 0 },
    strokeColor=yellow,
    fillColor=white,
    radiusX=50,
    radiusY=100,
    rotation=0,
    startAngle=0,
    endAngle=@math.PI * 2,
    counterclockwise=false,
    lineWidth=10,
  )
  let view = Element::coordinate([e1, e2])
  println(e1.size())
  println(e2.size())
  let rs = view.to_render_sequence({ x: 100 + 20, y: 100 + 20 })
  Renderable::render_sequence(ctx, rs)
}

///|
pub fn entry() -> Unit {
  window.addEventListener("resize", fn(_) {
    resize()
    render()
  })
  resize()
  render()
}
