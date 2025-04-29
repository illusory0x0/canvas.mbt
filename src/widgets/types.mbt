///|
typealias @basic.(Color, Size, Font, Thinkness, Vector, Rect)

///|
typealias @adapton.(Cell, Thunk)

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
}

///|
pub(all) struct RoundedBorder {
  color : Thunk[Color]
  size : Thunk[Size]
  radius : Thunk[Double]
  thickness : Thunk[Double]
}

///|
pub(all) struct RoundedRectangle {
  color : Thunk[Color]
  size : Thunk[Size]
  radius : Thunk[Double]
}

///|
pub(all) struct Rectangle {
  color : Thunk[Color]
  size : Thunk[Size]
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
  Render(Renderable_)
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

// ///|
// pub impl Eq for &Renderable with op_equal(self, other) {
//   false
// }

///|
typealias TColor = Thunk[Color]

///|
typealias TSize = Thunk[Size]

///|
typealias TString = Thunk[String]

///|
typealias TFont = Thunk[Font]

///|
typealias TDouble = Thunk[Double]

///|
enum Renderable_ {
  Text(color~ : TColor, size~ : TSize, text~ : TString, font~ : TFont)
  RoundedBorder(
    color~ : TColor,
    size~ : TSize,
    radius~ : TDouble,
    thickness~ : TDouble
  )
  RoundedRectangle(color~ : TColor, size~ : TSize, radius~ : TDouble)
  Rectangle(color~ : TColor, size~ : TSize)
}

///|
fn Renderable_::size(self : Renderable_) -> Size {
  match self {
    RoundedRectangle(size~, ..) => size.get()
    RoundedBorder(size~, ..) => size.get()
    Text(size~, ..) => size.get()
    Rectangle(size~, ..) => size.get()
  }
}

///|
pub impl Eq for Renderable_ with op_equal(self, other) {
  match (self, other) {
    (Rectangle(color=c1, size=s1), Rectangle(color=c2, size=s2)) =>
      c1.get() == c2.get() && s1.get() == s2.get()
    (
      RoundedRectangle(color=c1, size=s1, radius=r1),
      RoundedRectangle(color=c2, size=s2, radius=r2),
    ) => c1.get() == c2.get() && s1.get() == s2.get() && r1.get() == r2.get()
    (
      RoundedBorder(color=c1, size=s1, radius=r1, thickness=t1),
      RoundedBorder(color=c2, size=s2, radius=r2, thickness=t2),
    ) =>
      c1.get() == c2.get() &&
      s1.get() == s2.get() &&
      r1.get() == r2.get() &&
      t1.get() == t2.get()
    (
      Text(color=c1, size=s1, text=t1, font=f1),
      Text(color=c2, size=s2, text=t2, font=f2),
    ) =>
      c1.get() == c2.get() &&
      s1.get() == s2.get() &&
      t1.get() == t2.get() &&
      f1.get() == f2.get()
    (_, _) => false
  }
}
