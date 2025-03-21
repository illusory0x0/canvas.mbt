///|
pub fn Text::new(
  text~ : Cache[String],
  font~ : Cache[Font],
  color~ : Cache[Color]
) -> Text {
  let size = Cache::new(fn() {
    let font = font.cache
    let text = text.cache
    debug("Text::measure font size")
    Size::new(font.width(text), font.height(text))
  })
  size.depend_on(font)
  size.depend_on(text)
  { text, font, color, size }
}

///|
pub impl RequiredBy for Text with require_by(self, refresh) {
  self.size.require_by(refresh)
}

///|
pub impl Renderable for Text with size(self) {
  self.size.cache
}

///|
pub impl Renderable for Text with render(self, offset, ctx) {
  let color = self.color.cache
  let font = self.font.cache
  let text = self.text.cache
  ctx.set_fillStyle(color.to_string())
  ctx.set_font(font.to_string())
  ctx.set_textBaseline("top")
  ctx.fillText(text, offset.x, offset.y)
}
