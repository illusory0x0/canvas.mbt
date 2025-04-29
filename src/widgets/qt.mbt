///|
type Painter @qt.QPainter

///|
type Device @qt.Window

///|
pub fn Window::sync_from_device(self : Window, device : Device) -> Unit {
  let device = device._
  let width = device.width().to_double()
  let height = device.height().to_double()
  self.size.set(Size::new(width, height))
}

///|
fn color_to_qbrush(color : Color) -> @qt.QBrush {
  let qcolor = @qt.QColor::new(
    color.red().to_int(),
    color.green().to_int(),
    color.blue().to_int(),
    color.alpha().to_int(),
  )
  let qbrush = @qt.QBrush::new(qcolor)
  qbrush
}

///|
pub(open) trait Renderable: DepsKind {
  size(Self) -> Size
  render(Self, Vector, Painter) -> Unit
}

///|
pub impl Renderable for Rectangle with render(self, offset, painter) {
  let painter = painter._
  let color = self.color.get()
  let { width, height } = self.size.get()
  let brush = color |> color_to_qbrush
  let pen = brush |> @qt.QPen::new(0) // QPen width == 0, always draw 1 pixel
  painter.setBrush(brush)
  painter.setPen(pen)
  painter.drawRect(offset.x, offset.y, width, height)
}

///|
pub impl Renderable for RoundedBorder with render(self, offset, painter) {
  let painter = painter._
  let size = self.size.get()
  let radius = self.radius.get()
  let thickness = self.thickness.get()
  let color = self.color.get()
  let brush = color |> color_to_qbrush
  let pen = @qt.QPen::new(brush, thickness)
  painter.setBrush(brush)
  painter.setPen(pen)
  painter.drawRoundedRect(
    offset.x,
    offset.y,
    size.width,
    size.height,
    radius,
    radius,
  )
}

///|
pub impl Renderable for RoundedRectangle with render(self, offset, painter) {
  let painter = painter._
  let size = self.size.get()
  let radius = self.radius.get()
  let color = self.color.get()
  let brush = color_to_qbrush(color)
  let pen = @qt.QPen::new(brush, 0)
  painter.setBrush(brush)
  painter.setPen(pen)
  painter.drawRoundedRect(
    offset.x,
    offset.y,
    size.width,
    size.height,
    radius,
    radius,
  )
}

///|
pub impl Renderable for Text with render(self, offset, painter) {
  let painter = painter._
  let color = self.color.get()
  let font = self.font.get()
  let text = self.text.get()
  let qcolor = @qt.QColor::new(
    color.red().to_int(),
    color.green().to_int(),
    color.blue().to_int(),
    color.alpha().to_int(),
  )
  let brush = @qt.QBrush::new(qcolor)
  let pen = @qt.QPen::new(brush, 1)
  painter.setBrush(brush)
  painter.setPen(pen)
  let qfont = font_to_qfont(font)
  let height = Font::height(font, " ")
  painter.setFont(qfont)
  painter.drawText(offset.x, offset.y + height, @qt.QString::from_builtin(text))
}

///|
typealias @qt.(QFont, QStringList, QString)

///|
fn font_to_qfont(font : Font) -> QFont {
  QFont::new(
    QStringList::new(
      FixedArray::from_array(font.family).map(QString::from_builtin),
    ),
    font.size,
    font.weight,
    match font.style {
      Normal => false
      Italic => true
    },
  )
}
