///|
typealias @basic.(Color, Size, Font, Thinkness, Vector, Rect)

///|
typealias @cache.(Cache[T], State[T], Trigger)

///|
traitalias @cache.RequiredBy

///|
fnalias @basic.hsl

///|
pub(all) struct Text {
  color : Cache[Color]
  size : Cache[Size]
  text : Cache[String]
  font : Cache[Font]
}

///|
pub(all) struct RoundedBorder {
  color : Cache[Color]
  size : Cache[Size]
  radius : Cache[Int]
  thickness : Cache[Int]
}

///|
pub(all) struct RoundedRectangle {
  color : Cache[Color]
  size : Cache[Size]
  radius : Cache[Int]
}

///|
pub(all) struct Rectangle {
  color : Cache[Color]
  size : Cache[Size]
}

///|
pub typealias OnClick = () -> Unit

///|
pub typealias OnMouseEnter = () -> Unit

///|
pub typealias OnMouseLeave = () -> Unit

///|
typealias Layout = Cache[(Size, Array[(Vector, Element)])]

///|
pub enum Element {
  Layout(Layout)
  Render(&Renderable)
  Handle(Element, Handler)
} derive(Show)

///|
pub struct Handler {
  id : Int
  on_click : OnClick?
  on_double_click : OnClick?
  on_mouse_enter : OnMouseEnter?
  on_mouse_leave : OnMouseLeave?
}
