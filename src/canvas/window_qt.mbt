///|
pub fn Window::sync_from_native(self : Window, w : @qpainter.Window) -> Unit {
  let width = w.width().to_double()
  let height = w.height().to_double()
  self.size.set(Size::new(width,height))
}
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
