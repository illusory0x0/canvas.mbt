///|
pub fn &Renderable::render_iter(
  ctx : @dom.Canvas2D,
  xs : Iter[(Vector, &Renderable)]
) -> Unit {
  for x in xs {
    let (offset, renderable) = x
    guard offset.x >= 0 && offset.y >= 0
    if offset.inside_window() {
      renderable.render(offset, ctx)
    }
  }
}
