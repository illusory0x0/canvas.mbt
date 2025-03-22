///|
let canvas : @dom.HTMLCanvasElement = document.querySelector("#canvas")

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


pub fn View::text(text~: String, font~ : Font, color~: Color) -> View {
  Render(Renderable::text(text~,font~,color~))
}

let ctx : Canvas2D = canvas.getContext("2d")

let white : Color = hsl(0,0,100)
let black : Color = hsl(0,0,0)
let font : Font = {..Font::default(), weight:320}
///|
fn render() -> Unit {

  let text = View::text(text="Hello, world!", font~, color=white)

  let view = text.padding(thickness=Thinkness::same(14), color=black)
  let rs = view.to_render_sequence(Vector::new(20,20))

  Renderable::render_sequence(ctx,rs)

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
