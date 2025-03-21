///|
pub fn RoundedBorder::new(
  color : Cache[Color],
  size : Cache[Size],
  radius : Cache[Int],
  thickness : Cache[Int]
) -> RoundedBorder {
  { color, size, radius, thickness }
}

///|
pub impl RequiredBy for RoundedBorder with require_by(self, refresh) {
  self.color.require_by(refresh)
  self.size.require_by(refresh)
  self.radius.require_by(refresh)
  self.thickness.require_by(refresh)
}

///|
pub impl Renderable for RoundedBorder with size(self) {
  self.size.cache
}

///|
pub impl Renderable for RoundedBorder with render(self, offset, ctx) {
  let size = self.size.cache
  let radius = self.radius.cache
  let thickness = self.thickness.cache
  let color = self.color.cache
  ctx.set_strokeStyle(color.to_string())
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
