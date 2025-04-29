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

///|
fn Renderable_::render(
  self : Renderable_,
  offset : Vector,
  painter : Painter
) -> Unit {
  let painter = painter._
  match self {
    RoundedRectangle(size~, color~, radius~) => {
      let size = size.get()
      let radius = radius.get()
      let color = color.get()
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
    RoundedBorder(size~, color~, radius~, thickness~) => {
      let size = size.get()
      let radius = radius.get()
      let thickness = thickness.get()
      let color = color.get()
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
    Text(color~, size~, text~, font~) => {
      let color = color.get()
      let font = font.get()
      let text = text.get()
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
      painter.setFont(qfont)
      let m = @qt.QFontMetricsF::new(qfont)
      let br = m.boundingRect(QString::from_builtin(text))
      painter.drawText(
        offset.x,
        offset.y - br.top(),
        @qt.QString::from_builtin(text),
      )
    }
    Rectangle(color~, size~) => {
      let color = color.get()
      let { width, height } = size.get()
      let brush = color |> color_to_qbrush
      let pen = brush |> @qt.QPen::new(0) // QPen width == 0, always draw 1 pixel
      painter.setBrush(brush)
      painter.setPen(pen)
      painter.drawRect(offset.x, offset.y, width, height)
    }
  }
}
