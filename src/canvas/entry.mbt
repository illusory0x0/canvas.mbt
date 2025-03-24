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

// ///|
// struct App {
//   element : Element
//   origin : Vector
// }

///|
typealias @lazy.Lazy[T]

///|
typealias @lazy.LazyRec[T]

///|
priv struct AppRepr {
  origin : Vector
  count : Int
  handler : Handler
  element : Lazy[Element]
  layout : Lazy[Array[(Vector, Element)]]
}

///|
priv type App LazyRec[AppRepr]

///|
let app : App = LazyRec::new(fn(self : Lazy[AppRepr]) {
  let element = Lazy::new(fn() {
    let count = self.force().count
    let label = Element::text(text="counter: \{count}", font~, color=white).padding(
      thickness=Thinkness::same(10),
      color=black,
    )
    let btn = Element::text(text="+", font~, color=white)
      .padding(thickness=Thinkness::same(10), color=black)
      .add_event_handler(self.force().handler)
    Element::hstack([label, btn], spacing=20)
  })
  {
    count: 0,
    handler: Handler::new(),
    origin: { x: 20, y: 20 },
    element,
    layout: Lazy::new(fn() {
      let self : AppRepr = self.force()
      self.element.force().to_layout_sequence(self.origin)
    }),
  }
})

///|
fn App::render_sequence(self : App) -> Iter[(Vector, Renderable)] {
  self._.force().layout
  .force()
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
  self._.force().layout
  .force()
  .iter()
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
  Renderable::render_sequence(ctx, rs)
}

///|
pub fn entry() -> Unit {
  app._.modify(fn(self) {
    {
      ..self,
      handler: Handler::new(on_click=fn() {
        app._.modify(fn(self) { { ..self, count: self.count + 1 } })
      }),
    }
  })
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
      }
    }
    app.render()
  })
  for i in 0..<1000 {
    let es = app.event_sequence()
    for x in es {
      let (rect, handler) = x
      handler.on_click.map(fn(f) { f() }) |> ignore
    }
    app.render()
  }

  resize()
  app.render()
}
