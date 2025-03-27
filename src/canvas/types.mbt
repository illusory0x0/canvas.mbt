///|
typealias @basic.(Color, Size, Font, Thinkness, Vector, Rect)

///|
typealias @cache.Node[T]

///|
traitalias @cache.VNode

///|
fnalias @basic.hsl

///|
pub(all) struct Text {
  color : Node[Color]
  size : Node[Size]
  text : Node[String]
  font : Node[Font]
  rnode : &VNode
}

///|
pub(all) struct RoundedBorder {
  color : Node[Color]
  size : Node[Size]
  radius : Node[Int]
  thickness : Node[Int]
  rnode : &VNode
}

///|
pub(all) struct RoundedRectangle {
  color : Node[Color]
  size : Node[Size]
  radius : Node[Int]
  rnode : &VNode
}

///|
pub(all) struct Rectangle {
  color : Node[Color]
  size : Node[Size]
  rnode : &VNode
}

///|
pub typealias OnClick = () -> Unit

///|
pub typealias OnMouseEnter = () -> Unit

///|
pub typealias OnMouseLeave = () -> Unit

///|
typealias Layout = Node[(Size, Array[(Vector, Element)])]

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

///|
pub struct Window {
  size : Node[Size]
  dpr : Node[Int]
} derive(Show)
