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
