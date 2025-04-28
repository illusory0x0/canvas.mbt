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
