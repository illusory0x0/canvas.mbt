///|
pub fn &Renderable::render_iter(
  ctx : @qpainter.QPainter,
  xs : Iter[(Vector, &Renderable)]
) -> Unit {
  for x in xs {
    let (offset, renderable) = x
    guard offset.x >= 0 && offset.y >= 0
    if window.contains(offset) {
      renderable.render(offset, ctx)
    }
  }
}
