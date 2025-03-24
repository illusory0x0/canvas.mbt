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
typealias @lazy.Lazy[T]

///|
typealias @lazy.LazyRec[T]

///|
let origin : Vector = { x: 20, y: 20 }

///|
priv struct App {
  counter : Dependency[Int]
  button : Element
  element : Dependency[Element]
  layout : Dependency[Array[(Vector, Element)]]
}

///|
fn App::new() -> App {
  let counter = Dependency::new(fn() { 0 })
  let button = Element::text(text="+", font~, color=white)
      .padding(thickness=Thinkness::same(10), color=black)
      .control(on_click=fn() { counter.modify(fn { x => x + 1 }) })

  let element = Dependency::new(fn() {
    let label = Element::text(
      text="counter: \{counter.value}",
      font~,
      color=white,
    ).padding(thickness=Thinkness::same(10), color=black)
    Element::hstack([label, button], spacing=20)
  })
  let layout = Dependency::new(fn() { element.value.to_layout_sequence(origin) })
  element.depend_on(counter)
  layout.depend_on(element)
  { counter, element, layout , button}
}

///|
fn App::render_sequence(self : App) -> Iter[(Vector, Renderable)] {
  self.layout.value
  .iter()
  .filter_map(fn {
    (o, e) =>
      match e {
        Render(x) => Some((o, x))
        _ => None
      }
  })
}

///|
fn App::event_sequence(self : App) -> Iter[(Rect, Handler)] {
  self.layout.value
  .rev_iter()
  .filter_map(fn {
    (offset, e) =>
      match e {
        Control(e, h) => Some(({ offset, size: e.size() }, h))
        _ => None
      }
  })
}

///|
fn App::render(self : App) -> Unit {
  let rs = self.render_sequence()
  ctx.clearRect(0, 0, window.innerWidth(), window.innerHeight())
  Renderable::render_sequence(ctx, rs)
}

let app : App = App::new()

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
      let (rect, handler) = x
      let p = { x: e.clientX(), y: e.clientY() }
      if p.inside(rect) {
        handler.on_click.map(fn(f) { f() }) |> ignore
        break
      }
    }
    app.render()
  })
  resize()
  app.render()
}

pub fn add_1000() -> Unit {
  for _ in 0..<1000 {
    app.counter.modify(fn { x => x + 1})
    app.render()
  }
}