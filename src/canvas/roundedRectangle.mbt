///|
pub fn RoundedRectangle::new(
  color~ : Node[Color],
  size~ : Node[Size],
  radius~ : Node[Int]
) -> RoundedRectangle {
  let rnode = Node::from_fun(fn() {
    color.sync()
    size.sync()
    radius.sync()
  })
  { color, size, radius, rnode }
}

///|
pub impl Renderable for RoundedRectangle with size(self) {
  self.size.get()
}

///|
pub impl DepsKind for RoundedRectangle with render_node(self) {
  self.rnode
}

///|
pub impl DepsKind for RoundedRectangle with layout_node(self) {
  self.size
}

///|
pub impl Renderable for RoundedRectangle with render(self, offset, ctx) {
  let size = self.size.get()
  let radius = self.radius.get()
  let color = self.color.get()
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
