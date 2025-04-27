///|
pub fn Text::new(
  text~ : Thunk[String],
  font~ : Thunk[Font],
  color~ : Thunk[Color]
) -> Text {
  let size = thunk(fn() {
    let font = font.get()
    let text = text.get()
    debug("Text::measure font size")
    Size::new(font.width(text), font.height(text))
  })
  let rnode = action(fn() {
      size.get() |> ignore
      font.get() |> ignore
      color.get() |> ignore
    })._
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
pub impl Renderable for Text with render(self, offset, painter) {
  let color = self.color.get()
  let font = self.font.get()
  let text = self.text.get()
  let qcolor = @qpainter.QColor::new(
    color.red().to_int(),
    color.green().to_int(),
    color.blue().to_int(),
    color.alpha().to_int(),
  )
  let qbrush = @qpainter.QBrush::new(qcolor)
  let qpen = @qpainter.QPen::new(qbrush, 1)
  painter.setBrush(qbrush)
  painter.setPen(qpen)
  let qfont = font.to_qfont()
  let height = Font::height(font, " ")
  painter.setFont(qfont)
  painter.drawText(
    offset.x,
    offset.y + height,
    @qpainter.QString::from_builtin(text),
  )
}
