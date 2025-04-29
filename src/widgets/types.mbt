///|
typealias @basic.(Color, Size, Font, Thinkness, Vector, Rect)

///|
typealias @adapton.(Cell[T], Thunk[T])

///|
typealias Node = &@adapton.Source

///|
fnalias @adapton.(cell, thunk)

///|
pub(all) struct Text {
  color : Thunk[Color]
  size : Thunk[Size]
  text : Thunk[String]
  font : Thunk[Font]
  rnode : Node
}

///|
pub(all) struct RoundedBorder {
  color : Thunk[Color]
  size : Thunk[Size]
  radius : Thunk[Double]
  thickness : Thunk[Double]
  rnode : Node
}

///|
pub(all) struct RoundedRectangle {
  color : Thunk[Color]
  size : Thunk[Size]
  radius : Thunk[Double]
  rnode : Node
}

///|
pub(all) struct Rectangle {
  color : Thunk[Color]
  size : Thunk[Size]
  rnode : Node
}

///|
pub typealias OnClick = () -> Unit

///|
pub typealias OnMouseEnter = () -> Unit

///|
pub typealias OnMouseLeave = () -> Unit

///|
pub typealias OnMouseDown = (Vector) -> Unit

///|
pub typealias OnMouseUp = (Vector) -> Unit

///|
pub typealias OnMouseMove = (Vector) -> Unit

///|
typealias Layout = Thunk[(Size, Array[(Vector, Element)])]

///|
pub enum Element {
  Layout(Layout)
  Render(&Renderable)
  Handle(Element, Handler)
}

///|
pub struct Handler {
  id : Int
  on_click : OnClick?
  on_double_click : OnClick?
  on_mouse_enter : OnMouseEnter?
  on_mouse_leave : OnMouseLeave?
  on_mouse_move : OnMouseMove?
  on_mouse_down : OnMouseDown?
  on_mouse_up : OnMouseUp?
}

///|
pub struct Window {
  size : Cell[Size]
  dpr : Cell[Int]
}

///|
pub impl Show for Window with output(self, logger) {

}

///|
pub impl Show for Element with output(self, logger) {

}

///|
pub impl Eq for Element with op_equal(self, other) {
  false
}

///|
pub impl Eq for &Renderable with op_equal(self, other) {
  false
}
