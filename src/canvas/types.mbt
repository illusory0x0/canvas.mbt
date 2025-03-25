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
  RoundedBorder(color~ : Color, size~ : Size, radius~ : Int, thickness~ : Int)
  RoundedRectangle(color~ : Color, size~ : Size, radius~ : Int)
} derive(Show)

///|
typealias @dom.Canvas2D

///|
pub typealias OnClick = () -> Unit

///|
pub typealias OnMouseEnter = () -> Unit

///|
pub typealias OnMouseLeave = () -> Unit

///|
pub enum Element {
  Layout(sort~ : String, size~ : Size, children~ : Array[(Vector, Element)])
  Render(Renderable)
  Control(Element, Handler)
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
let default_handler : Handler = {
  id: 0,
  on_click: None,
  on_double_click: None,
  on_mouse_enter: None,
  on_mouse_leave: None,
}

///|
pub impl Default for Handler with default() {
  default_handler
}

///|
struct Widget[S] {
  source : Dependency[S]
  target : Dependency[Element]
}

///|
pub fn Widget::hover[T](
  make_content : () -> T,
  leave~ : (T) -> Element,
  enter~ : (T) -> Element
) -> Widget[T] {
  let source = Dependency::new(make_content)
  let target = Dependency::new(fn() { leave(source.value) })
  fn add_handler(x : Element) {
    x.handle(on_mouse_enter~, on_mouse_leave~)
  }

  fn on_mouse_enter() {
    target.update(fn() { enter(source.value) |> add_handler })
  }

  fn on_mouse_leave() {
    target.update(fn() { leave(source.value) |> add_handler })
  }

  target.modify(fn(e) { e.handle(on_mouse_enter~, on_mouse_leave~) })
  target.depend_on(source)
  { source, target }
}

///|
///     self.source ------------------⇒ other.source
///         |                                 |
///         |                                 |   
///         |                                 |     
///         |                                 |
///         |                                 |
///         ⇓                                 ⇓ 
///     self.target ⇐------------------ other.target                                               
pub fn Widget::depend_on[A, B](self : Widget[A], other : Widget[B]) -> Unit {
  other.source.depend_on(self.source)
  self.target.depend_on(other.target)
}
