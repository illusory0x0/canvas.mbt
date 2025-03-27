///|
pub fn Text::new(
  text~ : Node[String],
  font~ : Node[Font],
  color~ : Node[Color]
) -> Text {
  let size = Node::from_fun(fn() {
    let font = font.get()
    let text = text.get()
    debug("Text::measure font size")
    Size::new(font.width(text), font.height(text))
  })
  size.depend_on(font)
  size.depend_on(text)
  let rnode = Node::from_fun(fn() {
    size.sync()
    font.sync()
    color.sync()
  })
  { text, font, color, size, rnode }
}

///|
pub impl Renderable for Text with size(self) {
  self.size.get()
}

///|
pub impl DepsKind for Text with render_node(self) {
  self.rnode
}

///|
pub impl DepsKind for Text with layout_node(self) {
  self.size
}

///|
pub impl Renderable for Text with render(self, offset, ctx) {
  let color = self.color.get()
  let font = self.font.get()
  let text = self.text.get()
  ctx.set_fillStyle(color.to_string())
  ctx.set_font(font.to_string())
  ctx.set_textBaseline("top")
  ctx.fillText(text, offset.x, offset.y)
}
