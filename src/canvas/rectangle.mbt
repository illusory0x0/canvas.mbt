///|
pub fn Rectangle::new(color~ : () -> Color, size~ : () -> Size) -> Rectangle {
  let color = Node::from_fun(color)
  let size = Node::from_fun(size)
  let rnode = Node::from_fun(fn() {
    color.sync()
    size.sync()
  })
  { color, size, rnode }
}

///|
pub impl Renderable for Rectangle with size(self) {
  self.size.get()
}

///|
pub impl DepsKind for Rectangle with render_node(self) {
  self.rnode
}

///|
pub impl DepsKind for Rectangle with layout_node(self) {
  self.size
}

///|
pub impl Renderable for Rectangle with render(self, offset, ctx) {
  let color = self.color.get()
  let { width, height } = self.size.get()
  ctx.set_fillStyle(color.to_string())
  ctx.fillRect(offset.x, offset.y, width, height)
}
