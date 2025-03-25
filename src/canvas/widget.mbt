///|
pub fn Widget::hover[T](
  source : Dependency[T],
  leave~ : (T) -> Element,
  enter~ : (T) -> Element
) -> Widget[(T)] {
  let mut is_hoved = false
  let tmp = Dependency::new(fn() {
    (source.value, if is_hoved { leave } else { enter })
  })
  is_hoved = false
  fn on_mouse_enter() {
    is_hoved = true
    source.update()
  }

  fn on_mouse_leave() {
    is_hoved = false
    source.update()
  }

  let handler = Handler::new(on_mouse_enter~, on_mouse_leave~)
  let target = Dependency::new(fn() {
    let (element, modifier) = tmp.value
    modifier(source.value).handle(handler)
  })
  tmp.depend_on(source)
  target.depend_on(tmp)
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
