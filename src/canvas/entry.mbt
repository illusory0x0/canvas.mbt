///|
let canvas : @dom.HTMLCanvasElement = document.querySelector("#canvas")

///|
fn resize() -> Unit {
  let dpr = window.devicePixelRatio()
  let dpr = dpr.round().to_int() + 1
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
fn render() -> Unit {
  try {
    let text = Renderable::text(
      text="hello world",
      font= { ..Font::default(), weight:320},
      color=hsl!(0, 0, 100),
    )
    let ctx = canvas.getContext("2d")
    text.render(Vector::new(20, 20), ctx)
  } catch {
    e => println(e)
  }
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
