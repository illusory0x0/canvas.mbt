///|
pub fn RoundedRectangle::new(
  color : Cache[Color],
  size : Cache[Size],
  radius : Cache[Int]
) -> RoundedRectangle {
  { color, size, radius }
}

///|
pub impl RequiredBy for RoundedRectangle with require_by(self, refresh) {
  self.color.require_by(refresh)
  self.size.require_by(refresh)
  self.radius.require_by(refresh)
}

///|
pub impl Renderable for RoundedRectangle with size(self) {
  self.size.cache
}

///|
pub impl Renderable for RoundedRectangle with render(self, offset, ctx) {
  let size = self.size.cache
  let radius = self.radius.cache
  let color = self.color.cache
  ctx.set_fillStyle(color.to_string())
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
