///|
pub struct Size {
  width : Int
  height : Int
} derive(Default, Show, Compare, Eq, Hash)

///|
pub struct Rect {
  offset : Vector
  size : Size
} derive(Default, Show, Compare, Eq, Hash)

///|
pub struct Vector {
  x : Int
  y : Int
} derive(Default, Show, Compare, Eq, Hash)

///|
pub struct Thinkness {
  left : Int
  top : Int
  right : Int
  bottom : Int
} derive(Default, Show, Compare, Eq, Hash)

///|
enum FontStyle {
  Normal
  Italic
} derive(Compare, Eq, Hash)

///|
enum GenericFontFamily {
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
pub struct Font {
  family : Array[String]
  genericFamily : Array[GenericFontFamily]
  size : Int
  style : FontStyle
  weight : Int
} derive(Compare, Eq)

///|
pub enum Renderable {
  Text(color~ : Color, size~ : Size, text~ : String, font~ : Font)
  Rectangle(color~ : Color, size~ : Size)
  Border(color~ : Color, size~ : Size, thickness~ : Thinkness)
} derive(Show)

///|
typealias @dom.Canvas2D

///|
pub struct Positioned[T] {
  offset : Vector
  view : T
} derive(Show)

///|
pub enum View {
  Layout(sort~ : String, size~ : Size, children~ : Array[Positioned[View]])
  Render(Renderable)
} derive(Show)
