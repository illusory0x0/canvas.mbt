///|
pub fn Rectangle::new(color~ : Thunk[Color], size~ : Thunk[Size]) -> Rectangle {
  let rnode = action(fn() {
      color.get() |> ignore
      size.get() |> ignore
    })._
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
