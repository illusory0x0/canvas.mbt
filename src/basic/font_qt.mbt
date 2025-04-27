///|
typealias @qpainter.(QFont, QFontMetricsF, QString, QStringList)

///|
let memo : Map[(Font, String), QFontMetricsF] = {}

///|
pub fn Font::to_qfont(self : Font) -> QFont {
  QFont::new(
    QStringList::new(
      FixedArray::from_array(self.family).map(QString::from_builtin),
    ),
    self.size,
    self.weight,
    match self.style {
      Normal => false
      Italic => true
    },
  )
}

///|
fn Font::measure_text(self : Font, text : String) -> QFontMetricsF {
  match memo[(self, text)] {
    None => {
      let qfont = self.to_qfont()
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
