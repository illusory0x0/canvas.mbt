///|
type Painter @dom.Canvas2D

///|
type Device @dom.Window

///|
fn scale_size() -> Double {
  @dom.window.devicePixelRatio().round() + 1
}

///|
pub fn Window::sync_from_device(self : Window, device : Device) -> Unit {
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
  let dpr = window.dpr.get()
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
        let dpr = window.dpr.get()
        let ocvs = text_off_csv(
          (font.get(), color.get(), dpr, text.get(), size),
        )
        let ddpr = dpr.to_double()
        ctx.draw_offscreen_canvas(ocvs, offset.x * ddpr, offset.y * ddpr)
      }
    }
    Rectangle(color~, size~) => { // fillrect not need memo
      let dpr = window.dpr.get().to_double()
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
fn App::run(ls : Thunk[LayoutSequence]) -> Unit {
  window.sync_from_device(@dom.window)
  let rs = thunk(fn() { ls.get().filter_map(Element::to_render) })
  fn render() {
    window.dpr.get() |> ignore
    Renderable::render_iter(canvas_context, rs.get().iter())
    @dom.requestAnimationFrame(render)
  }

  @dom.requestAnimationFrame(render)
  @dom.window.addEventListener("resize", fn(_) {
    window.sync_from_device(@dom.window)
  })
  fn get_xy(e : @dom.Event) {
    let e : @dom.MouseEvent = e.downcast()
    let x = e.clientX().to_double()
    let y = e.clientY().to_double()
    (x, y)
  }

  @dom.window.addEventListener("mousemove", fn(e) {
    let (x, y) = get_xy(e)
    App::on_mouse_move(ls, x, y)
  })
  @dom.window.addEventListener("mousedown", fn(e) {
    let (x, y) = get_xy(e)
    App::on_mouse_press(ls, x, y)
  })
  @dom.window.addEventListener("mouseup", fn(e) {
    let (x, y) = get_xy(e)
    App::on_mouse_release(ls, x, y)
  })
  @dom.window.addEventListener("dblclick", fn(e) {
    let (x, y) = get_xy(e)
    App::on_double_click(ls, x, y)
  })
}
