///|
fn Element::hover(
  self : Element,
  leave~ : Color,
  enter~ : Color,
  padding~ : (Element, Node[Color]) -> Element
) -> Element {
  let is_hoved = Node::from_val(false)
  let color = is_hoved.map(fn { b => if b { enter } else { leave } })
  fn on_mouse_enter() {
    is_hoved.set(true)
  }

  fn on_mouse_leave() {
    is_hoved.set(false)
  }

  let handler = Handler::new(on_mouse_enter~, on_mouse_leave~)
  padding(self, color).add_handler(handler)
}
