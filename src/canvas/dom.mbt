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
  let ctx = canvas.getContext("2d")
  ctx.scale(dpr.to_double(), dpr.to_double())
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
pub(open) trait Renderable: DepsKind {
  size(Self) -> Size
  render(Self, Vector, Painter) -> Unit
}

///|
pub impl Renderable for Rectangle with render(self, offset, painter) {
  let ctx = painter._
  let color = self.color.get()
  let { width, height } = self.size.get()
  ctx.set_fillStyle(color |> color_to_css)
  ctx.fillRect(offset.x, offset.y, width, height)
}

///|
pub impl Renderable for RoundedRectangle with render(self, offset, painter) {
  let ctx = painter._
  let size = self.size.get()
  let radius = self.radius.get()
  let color = self.color.get()
  ctx.set_fillStyle(color |> color_to_css)
  ctx.beginPath()
  ctx.roundRect(
    offset.x,
    offset.y,
    size.width,
    size.height,
    radius,
    radius,
    radius,
    radius,
  )
  ctx.fill()
}

///|
pub impl Renderable for RoundedBorder with render(self, offset, painter) {
  let ctx = painter._
  let size = self.size.get()
  let radius = self.radius.get()
  let thickness = self.thickness.get()
  let color = self.color.get()
  ctx.set_strokeStyle(color |> color_to_css)
  ctx.set_lineWidth(thickness)
  ctx.beginPath()
  ctx.roundRect(
    offset.x,
    offset.y,
    size.width,
    size.height,
    radius,
    radius,
    radius,
    radius,
  )
  ctx.stroke()
}

///|
pub impl Renderable for Text with render(self, offset, painter) {
  let ctx = painter._
  let color = self.color.get()
  let font = self.font.get()
  let text = self.text.get()
  ctx.set_fillStyle(color |> color_to_css)
  ctx.set_font(font.to_string())
  ctx.set_textBaseline("bottom")
  let height = font.height(text)
  ctx.fillText(text, offset.x, offset.y + height)
}
