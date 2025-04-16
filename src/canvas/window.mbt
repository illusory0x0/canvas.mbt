///|
fn scale_size() -> Double {
  @dom.window.devicePixelRatio().round() + 1
}

///|
pub fn Window::sync_from_dom(self : Window, w : @dom.Window) -> Unit {
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
pub fn Window::sync(self : Window) -> Unit {
  self.sync_from_dom(@dom.window)
}
// let window : Window = cell(Size::new(0, 0))

///|
let window : Window = { size: cell(Size::new(1280, 720)), dpr: cell(1) }

///|
fn Window::width(self : Window) -> Double {
  self.size.get().width
}

///|
fn Window::height(self : Window) -> Double {
  self.size.get().height
}

///|
fn Window::contains(self : Window, v : Vector) -> Bool {
  v.x < self.width() && v.y < self.height()
}
