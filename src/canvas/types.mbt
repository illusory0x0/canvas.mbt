///|
pub(all) struct Size {
  width : Int
  height : Int
} derive(Default, Show, Compare, Eq, Hash)

///|
pub(all) struct Rect {
  offset : Vector
  size : Size
} derive(Default, Show, Compare, Eq, Hash)

///|
pub(all) struct Vector {
  x : Int
  y : Int
} derive(Default, Show, Compare, Eq, Hash)

///|
pub(all) struct Thinkness {
  left : Int
  top : Int
  right : Int
  bottom : Int
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
} derive(Compare, Eq)

///|
pub enum Renderable {
  Text(color~ : Color, size~ : Size, text~ : String, font~ : Font)
  Rectangle(color~ : Color, size~ : Size)
  Border(color~ : Color, size~ : Size, thickness~ : Thinkness)
  Line(
    color~ : Color,
    size~ : Size,
    p1~ : Vector,
    p2~ : Vector,
    lineWidth~ : Int
  )
  Ellipse(
    strokeColor~ : Color,
    fillColor~ : Color,
    size~ : Size,
    center~ : Vector,
    radiusX~ : Int,
    radiusY~ : Int,
    rotation~ : Double,
    startAngle~ : Double,
    endAngle~ : Double,
    counterclockwise~ : Bool,
    lineWidth~ : Int
  )
} derive(Show)

///|
typealias @dom.Canvas2D

///|
pub typealias OnClick = () -> Unit

///|
pub enum Element {
  Layout(sort~ : String, size~ : Size, children~ : Array[(Vector, Element)])
  Render(Renderable)
  Control(element~ : Element, on_click~ : OnClick?)
}
