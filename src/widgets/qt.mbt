///|
type Painter @qt.QPainter

///|
type Device @qt.Window

///|
typealias @qt.(QFontMetricsF, QFont, QStringList, QString)

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
fn Renderable::render(
  self : Renderable,
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

///|
type App

///|
fn App::run(ls : Thunk[LayoutSequence]) -> Unit {
  let argc : Ref[Int] = Ref::new(1)
  let argv : FixedArray[Bytes] = [b"painter\x00"]
  let app = @qt.QApplication::new(argc, argv)
  let rs = thunk(fn() { ls.get().filter_map(Element::to_render) })
  let w = @qt.Window::new(
    paint=fn(w, p) { Renderable::render_iter(p, rs.get().iter()) },
    key_press=fn(w, k, m) {  },
    key_release=fn(w, k, m) {  },
    mouse_double_click=fn(w, x, y, k, b) {
      App::on_double_click(ls, x, y)
      w.update()
    },
    mouse_release=fn(w, x, y, k, b) {
      App::on_mouse_release(ls, x, y)
      w.update()
    },
    mouse_press=fn(w, x, y, k, b) {
      App::on_mouse_press(ls, x, y)
      w.update()
    },
    mouse_move=fn(w, x, y, m, b) {
      App::on_mouse_move(ls, x, y)
      w.update()
    },
    resize=fn(win, w, h) {
      window.sync_from_device(win)
      win.update()
    },
  )
  window.sync_from_device(w)
  w.show()
  let exit_code = @qt.QApplication::exec()
  @qt.drop([w, app, exit_code])
}

///|
let memo : Map[(Font, String), QFontMetricsF] = {}

///|
fn Font::measure_text(self : Font, text : String) -> QFontMetricsF {
  match memo[(self, text)] {
    None => {
      let qfont = self |> font_to_qfont
      let x = QFontMetricsF::new(qfont)
      memo[(self, text)] = x
      x
    }
    Some(x) => x
  }
}

///|
pub fn Font::width(self : Font, text : String) -> Double {
  self.measure_text(text).horizontalAdvance(QString::from_builtin(text))
}

///|
pub fn Font::height(self : Font, text : String) -> Double {
  let metrics = self.measure_text(text)
  return metrics.height()
}
