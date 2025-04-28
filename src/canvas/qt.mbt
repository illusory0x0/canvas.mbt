///|
type Painter @qpainter.QPainter
type Device @qpainter.Window 

///|
pub fn Window::sync_from_device(self : Window, device : Device) -> Unit {
  let device = device._
  let width = device.width().to_double()
  let height = device.height().to_double()
  self.size.set(Size::new(width, height))
}

///|
fn color_to_qbrush(color : Color) -> @qpainter.QBrush {
  let qcolor = @qpainter.QColor::new(
    color.red().to_int(),
    color.green().to_int(),
    color.blue().to_int(),
    color.alpha().to_int(),
  )
  let qbrush = @qpainter.QBrush::new(qcolor)
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
  painter.setBrush(color |> color_to_qbrush)
  painter.drawRect(offset.x, offset.y, width, height)
}

///|
pub impl Renderable for RoundedBorder with render(self, offset, painter) {
  let painter = painter._
  let size = self.size.get()
  let radius = self.radius.get()
  let thickness = self.thickness.get()
  let color = self.color.get()
  let qbrush = color |> color_to_qbrush
  let qpen = @qpainter.QPen::new(qbrush, thickness)
  painter.setPen(qpen)
  painter.drawRoundedRect(offset.x, offset.y, size.width, size.height, radius, radius)
}

///|
pub impl Renderable for RoundedRectangle with render(self, offset, painter) {
  let painter = painter._
  let size = self.size.get()
  let radius = self.radius.get()
  let color = self.color.get()
  painter.setBrush(color |> color_to_qbrush)
  painter.drawRoundedRect(offset.x, offset.y, size.width, size.height, radius, radius)
}

///|
pub impl Renderable for Text with render(self, offset, painter) {
  let painter = painter._
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
  let qfont = font |> font_to_qfont
  let height = Font::height(font, " ")
  painter.setFont(qfont)
  painter.drawText(
    offset.x,
    offset.y + height,
    @qpainter.QString::from_builtin(text),
  )
}

///|
typealias @qpainter.(QFont, QStringList, QString)

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
