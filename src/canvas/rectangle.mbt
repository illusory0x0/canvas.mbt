///|
pub fn Rectangle::new(color~ : () -> Color, size~ : () -> Size) -> Rectangle {
  let color = Cache::new(color)
  let size = Cache::new(size)
  { color, size }
}

///|
pub impl RequiredBy for Rectangle with require_by(self, refresh) {
  self.color.require_by(refresh)
  self.size.require_by(refresh)
}

///|
pub impl Renderable for Rectangle with size(self) {
  self.size.cache
}

///|
pub impl Renderable for Rectangle with render(self, offset, ctx) {
  let color = self.color.cache
  let { width, height } = self.size.cache
  ctx.set_fillStyle(color.to_string())
  ctx.fillRect(offset.x, offset.y, width, height)
}
