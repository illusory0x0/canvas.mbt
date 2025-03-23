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
struct App {
  element : Element
  origin : Vector
}

///|
let app : App = {
  element: Element::Control(
    element=Element::text(text="click me", font~, color=white).padding(
      thickness=Thinkness::same(10),
      color=black,
    ),
    on_click=Some(fn() { println("clicked") }),
  ),
  origin: { x: 20, y: 20 },
}

///|
pub fn App::render_sequence(self : App) -> Array[(Vector,Renderable)] {
  self.element.to_render_sequence(self.origin)
}

///|
pub fn App::event_sequence(self : App) -> Array[(Vector,Element)] {
  self.element.to_handler_sequence(self.origin)
}

///|
pub fn App::render(self : App) -> Unit {
  let rs = self.render_sequence()
  Renderable::render_sequence(ctx, rs)
}

///|
pub fn entry() -> Unit {
  window.addEventListener("resize", fn(_) {
    resize()
    app.render()
  })
  window.addEventListener("click", fn(e) {
    let e : @dom.MouseEvent = e.downcast()
    let es = app.event_sequence()
    for x in es {
      let (offset, view) = x 
      let rect = { offset, size : view.size() }
      let p = { x: e.clientX(), y: e.clientY() }
      if p.inside(rect) {
        match view {
          Control(on_click~,..) => on_click.unwrap()()
          _ => panic()
        }
      }

    }
  })
  resize()
  app.render()
}
