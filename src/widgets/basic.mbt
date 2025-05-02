///|
pub(all) struct Size {
  width : Double
  height : Double
} derive(Default, Show, Compare, Eq, Hash)

///|
pub(all) struct Rect {
  offset : Vector
  size : Size
} derive(Default, Show, Compare, Eq, Hash)

///|
pub(all) struct Vector {
  x : Double
  y : Double
} derive(Default, Show, Compare, Eq, Hash)

///|
pub(all) struct Thinkness {
  left : Double
  top : Double
  right : Double
  bottom : Double
} derive(Default, Show, Compare, Eq, Hash)

///|
pub(all) enum FontStyle {
  Normal
  Italic
} derive(Compare, Eq, Hash)

///|
pub(all) enum GenericFontFamily {
  Serif
  SansSerif
  Monospace
  Cursive
  Fantasy
  SystemUI
  UISerif
  UISansSerif
  UIMonospace
  UIRounded
  Math
  Emoji
  FangSong
} derive(Compare, Eq, Hash)

///|
pub(all) struct Font {
  family : Array[String]
  genericFamily : Array[GenericFontFamily]
  size : Int
  style : FontStyle
  weight : Int
} derive(Compare, Eq, Hash)

///|
pub impl Add for Vector with op_add(self, other) {
  { x: self.x + other.x, y: self.y + other.y }
}

///|
pub impl Sub for Vector with op_sub(self, other) {
  { x: self.x - other.x, y: self.y - other.y }
}

///|
pub fn Vector::new(x : Double, y : Double) -> Vector {
  { x, y }
}

///|
pub fn Vector::inside(self : Vector, rect : Rect) -> Bool {
  rect.left() < self.x &&
  self.x < rect.right() &&
  rect.top() < self.y &&
  self.y < rect.bottom()
}

///|
pub fn Thinkness::new(
  left : Double,
  top : Double,
  right : Double,
  bottom : Double
) -> Thinkness {
  { left, top, right, bottom }
}

///|
pub fn Thinkness::same(x : Double) -> Thinkness {
  Thinkness::new(x, x, x, x)
}

///|
pub fn Size::new(width : Double, height : Double) -> Size {
  { width, height }
}

///|
pub fn Rect::new(offset : Vector, size : Size) -> Rect {
  { offset, size }
}

///|
pub fn Rect::left(self : Rect) -> Double {
  self.offset.x
}

///|
pub fn Rect::right(self : Rect) -> Double {
  self.offset.x + self.size.width
}

///|
pub fn Rect::top(self : Rect) -> Double {
  self.offset.y
}

///|
pub fn Rect::bottom(self : Rect) -> Double {
  self.offset.y + self.size.height
}

///|
pub impl Show for FontStyle with to_string(self) {
  match self {
    Normal => "normal"
    Italic => "italic"
  }
}

///|
pub impl Show for FontStyle with output(self, logger) {
  logger.write_string(self.to_string())
}

///|
pub impl Show for GenericFontFamily with to_string(self) {
  match self {
    Serif => "serif"
    SansSerif => "sans-serif"
    Monospace => "monospace"
    Cursive => "cursive"
    Fantasy => "fantasy"
    SystemUI => "system-ui"
    UISerif => "ui-serif"
    UISansSerif => "ui-sans-serif"
    UIMonospace => "ui-monospace"
    UIRounded => "ui-rounded"
    Math => "math"
    Emoji => "emoji"
    FangSong => "fangsong"
  }
}

///|
pub impl Show for GenericFontFamily with output(self, logger) {
  logger.write_string(self.to_string())
}

// String values must be quoted but may contain any Unicode character.
// https://developer.mozilla.org/en-US/docs/Web/CSS/font-family#values

// Generic family names are keywords and must not be quoted. 
// https://developer.mozilla.org/en-US/docs/Web/CSS/font-family#generic-name

///|
pub impl Show for Font with output(self, logger) {
  let { family, size, style, genericFamily, weight } = self
  // write style
  style.output(logger)
  logger.write_char(' ')
  // write weight
  weight.output(logger)
  logger.write_char(' ')
  // write size
  size.output(logger)
  logger.write_string("px")
  logger.write_char(' ')
  if family.is_empty() {
    if not(genericFamily.is_empty()) {
      let hd = genericFamily[0]
      let tl = genericFamily[1:]
      hd.output(logger)
      for x in tl {
        logger.write_char(',')
        x.output(logger)
      }
    }
  } else {
    let hd = family[0]
    let tl = family[1:]
    logger.write_char('"')
    logger.write_string(hd)
    logger.write_char('"')
    for x in tl {
      logger.write_string(",\"")
      logger.write_string(x)
      logger.write_char('"')
    }
    for x in genericFamily {
      logger.write_char(',')
      x.output(logger)
    }
  }
}

///|
test {
  let font : Font = {
    family: [],
    genericFamily: [],
    size: 12,
    style: FontStyle::Normal,
    weight: 400,
  }
  inspect!(font, content="normal 400 12px ")
  let font : Font = {
    family: ["Arial"],
    genericFamily: [],
    size: 12,
    style: FontStyle::Normal,
    weight: 400,
  }
  inspect!(font, content="normal 400 12px \"Arial\"")
  let font : Font = {
    family: ["Arial"],
    genericFamily: [GenericFontFamily::Monospace],
    size: 12,
    style: FontStyle::Normal,
    weight: 400,
  }
  inspect!(font, content="normal 400 12px \"Arial\",monospace")
}

///|
pub impl Default for Font with default() {
  Font::new()
}

///|
pub fn Font::new(
  family~ : Array[String] = ["Cascadia Mono"],
  genericFamily~ : Array[GenericFontFamily] = [GenericFontFamily::Monospace],
  size~ : Int = 16,
  style~ : FontStyle = FontStyle::Normal,
  weight~ : Int = 400
) -> Font {
  { family, genericFamily, size, style, weight }
}
