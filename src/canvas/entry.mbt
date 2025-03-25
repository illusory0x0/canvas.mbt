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
  cache : Dependency[Array[(Vector, Element)]]
}

///|
fn App::new() -> App {
  let counter = Dependency::new(fn() { 0 })
  let button = Element::text(text="+", font~, color=white)
    .round_padding(thickness=16, color=black, radius=50)
    .handle(on_click=fn() { counter.modify(fn { x => x + 1 }) })
  let element = Dependency::new(fn() {
    let label = Element::text(
      text="counter: \{counter.value}",
      font~,
      color=white,
    ).round_padding(thickness=20, color=black, radius=20)
    Element::hstack([label, button], spacing=40)
  })
  let layout = Dependency::new(fn() { element.value.to_layout_sequence(origin) })
  element.depend_on(counter)
  layout.depend_on(element)
  { counter, element, cache: layout, button }
}

///|
fn App::render_sequence(self : App) -> Iter[(Vector, Renderable)] {
  self.cache.value
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
  self.cache.value
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

///|
let hover : Ref[(Rect, Handler)?] = Ref::new(None)

///|
let app : App = App::new()

///|
pub fn entry() -> Unit {
  fn run(action) {
    match action {
      None => ()
      Some(f) => f()
    }
  }

  let render = Dependency::new(fn() { app.render() })
  render.depend_on(app.cache)


  window.addEventListener("resize", fn(_) {
    resize()
  })
  window.addEventListener("click", fn(e) {
    let e : @dom.MouseEvent = e.downcast()
    for x in app.event_sequence() {
      let (rect, handler) = x
      let p = { x: e.clientX(), y: e.clientY() }
      if p.inside(rect) {
        handler.on_click |> run
        break
      }
    }
  })
  window.addEventListener("mousemove", fn(e) {
    let e : @dom.MouseEvent = e.downcast()
    let p = { x: e.clientX(), y: e.clientY() }
    match hover.val {
      None =>
        for x in app.event_sequence() {
          let (rect, handler) = x
          if p.inside(rect) {
            handler.on_mouse_enter |> run
            hover.val = Some(x)
            break
          }
        }
      Some((rect, handler)) =>
        if not(p.inside(rect)) {
          handler.on_mouse_leave |> run
          hover.val = None
        }
    }
  })
  resize()
  app.render()
}

///|
pub fn add_1000() -> Unit {
  for _ in 0..<1000 {
    app.counter.modify(fn { x => x + 1 })
  }
}
