///|
pub fn Renderable::render_iter(
  painter : Painter,
  xs : Iter[(Vector, Renderable)]
) -> Unit {
  for x in xs {
    let (offset, renderable) = x
    guard offset.x >= 0 && offset.y >= 0
    if window.contains(offset) {
      renderable.render(offset, painter._)
    }
  }
}

///|
pub fn mk_text(
  text~ : Thunk[String],
  font~ : Thunk[Font],
  color~ : Thunk[Color]
) -> Renderable {
  let size = thunk(fn() {
    let font = font.get()
    let text = text.get()
    Size::new(font.width(text), font.height(text))
  })
  Text(text~, font~, color~, size~)
}
