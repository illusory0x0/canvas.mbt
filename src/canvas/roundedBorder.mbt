///|
pub fn RoundedBorder::new(
  color~ : Thunk[Color],
  size~ : Thunk[Size],
  radius~ : Thunk[Double],
  thickness~ : Thunk[Double]
) -> RoundedBorder {
  let rnode = thunk(fn() {
    color.get() |> ignore
    size.get() |> ignore
    radius.get() |> ignore
  })
  { color, size, radius, thickness, rnode }
}

///|
pub impl Renderable for RoundedBorder with size(self) {
  self.size.get()
}

///|
pub impl DepsKind for RoundedBorder with render_node(self) {
  self.rnode
}

///|
pub impl DepsKind for RoundedBorder with layout_node(self) {
  self.size
}

///|
pub impl Renderable for RoundedBorder with render(self, offset, ctx) {
  let size = self.size.get()
  let radius = self.radius.get()
  let thickness = self.thickness.get()
  let color = self.color.get()
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
