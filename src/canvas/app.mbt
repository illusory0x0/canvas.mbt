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
let origin : Vector = { x: 20, y: 20 }

///|
priv struct App {
  widget : Widget[Int]
  cache : Dependency[Array[(Vector, Element)]]
}

///|
fn App::new() -> App {
  let mut counter = 0
  let source = Dependency::new(fn() { counter })
  let button = Element::text(text="+", font~, color=white)
    .round_padding(thickness=16, color=black, radius=50)
    .handle(
      Handler::new(on_click=fn() {
        counter += 1
        source.update()
      }),
    )
  let text = Dependency::new(fn() {
    Element::text(text="counter: \{source.value}", font~, color=white)
  })
  let label = Widget::hover(
    text,
    leave=fn(e) {
      e.round_padding(thickness=20, color=hsl(0, 0, 60), radius=20)
    },
    enter=fn(e) {
      e.round_padding(thickness=20, color=hsl(0, 0, 20), radius=20)
    },
  )

  // println(label.target.value)

  let target = Dependency::new(fn() {
    Element::hstack([label.target.value, button], spacing=40)
  })
  let cache = Dependency::new(fn() { target.value.to_layout_sequence(origin) })
  let widget = { source, target }
  widget.depend_on(label)
  cache.depend_on(target)
  { widget, cache }
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
