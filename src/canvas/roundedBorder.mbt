///|
pub fn RoundedBorder::new(
  color : () -> Color,
  size : () -> Size,
  radius : () -> Int,
  thickness : () -> Int
) -> RoundedBorder {
  let color = Cache::new(color)
  let size = Cache::new(size)
  let radius = Cache::new(radius)
  let thickness = Cache::new(thickness)
  { color, size, radius, thickness }
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
