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
pub impl Renderable for Rectangle with render(self, offset, p) {
  let color = self.color.get()
  let { width, height } = self.size.get()
  p.setBrush(color |> color_to_qbrush)
  p.drawRect(offset.x,offset.y,width,height)
}
