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
/// 
///     self.source ------------------⇒ other.source
///         |                                 |
///         |                                 |   
///         |                                 |     
///         |                                 |
///         |                                 |
///         ⇓                                 ⇓ 
///     self.target ⇐------------------ other.target   
///                                             
pub fn Widget::depend_on[A, B](self : Widget[A], other : Widget[B]) -> Unit {
  other.source.depend_on(self.source)
  self.target.depend_on(other.target)
}
