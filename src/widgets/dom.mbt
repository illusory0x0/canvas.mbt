///|
type Painter @dom.Canvas2D

///|
type Device @dom.Window

///|
fn scale_size() -> Double {
  @dom.window.devicePixelRatio().round() + 1
}

///|
pub fn WindowProperty::sync_from_device(self : WindowProperty, device : Device) -> Unit {
  let w = device._
  let dpr = scale_size().to_int()
  let width = @dom.window.innerWidth()
  let height = @dom.window.innerHeight()
  canvas.set_width(width * dpr)
  canvas.set_height(height * dpr)
  fn to_px(v : Int) {
    "\{v}px"
  }

  canvas.style().setProperty("width", to_px(width))
  canvas.style().setProperty("height", to_px(height))
  // let ctx = canvas_context
  // ctx.scale(dpr.to_double(), dpr.to_double())
  self.size.set(Size::new(width.to_double(), height.to_double()))
  self.dpr.set(dpr)
}

///|
let canvas : @dom.HTMLCanvasElement = @dom.document.querySelector("#canvas")

///|
let canvas_context : @dom.Canvas2D = canvas.getContext("2d")

///|
fn color_to_css(color : Color) -> String {
  let buf = StringBuilder::new(size_hint=40)
  buf.write_char('#')
  buf.write_object(color)
  buf.to_string()
}

///|
fn Renderable::render(
  self : Renderable,
  offset : Vector,
  painter : Painter
) -> Unit {
  let ctx = painter._
  let dpr = window_property.dpr.get()
  let ddpr = dpr.to_double()
  match self {
    RoundedRectangle(size~, color~, radius~) =>
      ctx.draw_offscreen_canvas(
        round_off_csv((color.get(), dpr, size.get(), radius.get())),
        offset.x * ddpr,
        offset.y * ddpr,
      )
    RoundedBorder(size~, color~, radius~, thickness~) =>
      ctx.draw_offscreen_canvas(
        stroke_round_off_csv(
          (color.get(), dpr, size.get(), radius.get(), thickness.get()),
        ),
        offset.x * ddpr,
        offset.y * ddpr,
      )
    Text(color~, size~, text~, font~) => {
      let size = size.get()
      if size.width != 0 && size.height != 0 {
        let dpr = window_property.dpr.get()
        let ocvs = text_off_csv(
          (font.get(), color.get(), dpr, text.get(), size),
        )
        let ddpr = dpr.to_double()
        ctx.draw_offscreen_canvas(ocvs, offset.x * ddpr, offset.y * ddpr)
      }
    }
    Rectangle(color~, size~) => { // fillrect not need memo
      let dpr = window_property.dpr.get().to_double()
      let color = color.get()
      let size = size.get()
      ctx.set_fillStyle(color |> color_to_css)
      ctx.fillRect(
        offset.x * dpr,
        offset.y * dpr,
        size.width * dpr,
        size.height * dpr,
      )
    }
  }
}

///|
/// For the smoothness of the app, we always cache for different dpr
let text_off_csv : ((Font, Color, Int, String, Size)) -> @dom.OffscreenCanvas = memo(fn(
    x : (Font, Color, Int, String, Size)
  ) {
    let (font, color, dpr, text, size) = x
    let ddpr = dpr.to_double()
    let ocvs = @dom.OffscreenCanvas::new(size.width * ddpr, size.height * ddpr)
    let ctx = ocvs.getContext("2d")
    ctx.scale(dpr.to_double(), dpr.to_double())
    ctx.set_fillStyle(color |> color_to_css)
    ctx.set_font(font.to_string())
    ctx.set_textBaseline("top") // TODO
    ctx.fillText(text, 0, 0)
    ocvs
  },
)

///|
/// For the smoothness of the app, we always cache for different dpr
let round_off_csv : ((Color, Int, Size, Double)) -> @dom.OffscreenCanvas = memo(fn(
    x : (Color, Int, Size, Double)
  ) {
    let (color, dpr, size, radius) = x
    let ddpr = dpr.to_double()
    let ocvs = @dom.OffscreenCanvas::new(size.width * ddpr, size.height * ddpr)
    let ctx = ocvs.getContext("2d")
    ctx.scale(dpr.to_double(), dpr.to_double())
    ctx.set_fillStyle(color |> color_to_css)
    ctx.beginPath()
    ctx.roundRect(0, 0, size.width, size.height, radius, radius, radius, radius)
    ctx.fill()
    ocvs
  },
)

///| For the smoothness of the app, we always cache for different dpr
let stroke_round_off_csv : ((Color, Int, Size, Double, Double)) -> @dom.OffscreenCanvas = memo(fn(
    x : (Color, Int, Size, Double, Double)
  ) {
    let (color, dpr, size, radius, thickness) = x
    let ddpr = dpr.to_double()
    let ocvs = @dom.OffscreenCanvas::new(size.width * ddpr, size.height * ddpr)
    let ctx = ocvs.getContext("2d")
    ctx.scale(dpr.to_double(), dpr.to_double())
    ctx.set_strokeStyle(color |> color_to_css)
    ctx.set_lineWidth(thickness)
    ctx.beginPath()
    ctx.roundRect(0, 0, size.width, size.height, radius, radius, radius, radius)
    ctx.stroke()
    ocvs
  },
)

///|
fn memo[A : Eq + Hash, B](f : (A) -> B) -> (A) -> B {
  let cache : Map[A, B] = {}
  fn g(a : A) -> B {
    match cache[a] {
      None => {
        let b = f(a)
        cache[a] = b
        b
      }
      Some(b) => b
    }
  }

  g
}

///|
type App

///|
fn App::run(e : Element) -> Unit {
  let ls = thunk(fn() { e.to_layout_sequence(Vector::default()) })
  window_property.sync_from_device(@dom.window)
  let rs = thunk(fn() { ls.get().filter_map(Element::to_render) })
  let ra = action(fn() {
    window_property.dpr.get() |> ignore
    let { width, height } = window_property.size.get()
    canvas_context.clearRect(0, 0, width, height)
    Renderable::render_iter(canvas_context, rs.get().iter())
  })
  fn render() {
    ra.run()
    @dom.requestAnimationFrame(render)
  }

  @dom.requestAnimationFrame(render)
  @dom.window.addEventListener("resize", fn(_) {
    window_property.sync_from_device(@dom.window)
  })
  fn get_xy(e : @dom.Event) {
    let e : @dom.MouseEvent = e.downcast()
    let x = e.clientX().to_double()
    let y = e.clientY().to_double()
    (x, y)
  }

  @dom.window.addEventListener("mousemove", fn(e) {
    let (x, y) = get_xy(e)
    App::on_mouse_move(ls.get(), x, y)
  })
  @dom.window.addEventListener("mousedown", fn(e) {
    let (x, y) = get_xy(e)
    App::on_mouse_press(ls.get(), x, y)
  })
  @dom.window.addEventListener("mouseup", fn(e) {
    let (x, y) = get_xy(e)
    App::on_mouse_release(ls.get(), x, y)
  })
  @dom.window.addEventListener("dblclick", fn(e) {
    let (x, y) = get_xy(e)
    App::on_double_click(ls.get(), x, y)
  })
}

///|
let context : @dom.Canvas2D = {
  let canvas : @dom.HTMLCanvasElement = @dom.document.createElement("canvas")
    |> @dom.coerce
  canvas.getContext("2d")
}

///|
let memo_font : Map[(Font, String), @dom.TextMetrics] = {}

///|
fn Font::measure_text(self : Font, text : String) -> @dom.TextMetrics {
  match memo_font[(self, text)] {
    None => {
      context.set_font(self.to_string())
      let x = context.measureText(text)
      memo_font[(self, text)] = x
      x
    }
    Some(x) => x
  }
}

///|
pub fn Font::width(self : Font, text : String) -> Double {
  self.measure_text(text).width()
}

///|
pub fn Font::height(self : Font, text : String) -> Double {
  let metrics = self.measure_text(text)
  let ascent = metrics.fontBoundingBoxAscent()
  let descent = metrics.fontBoundingBoxDescent()
  return ascent + descent
}
