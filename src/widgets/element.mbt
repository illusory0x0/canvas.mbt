///|
pub fn Element::size(self : Element) -> Size {
  match self {
    Layout(layout) => layout.get().0
    Render(x) => x.size()
    Handle(element, _) => element.size()
  }
}

///|
pub fn Element::to_render_sequence(
  self : Element,
  origin : Vector
) -> Iter[(Vector, Renderable)] {
  self
  .to_layout_sequence(origin)
  .iter()
  .filter_map(fn {
    (offset, element) =>
      match element {
        Render(x) => Some((offset, x))
        _ => None
      }
  })
}

///|
typealias LayoutSequence = Array[(Vector, Element)]

///|
pub fn Element::to_layout_sequence(
  self : Element,
  origin : Vector
) -> LayoutSequence {
  guard origin.x >= 0 && origin.y >= 0
  let buf = []
  fn dfs(root : Element, origin : Vector) {
    if window.contains(origin) {
      match root {
        Layout(layout) =>
          for x in layout.get().1 {
            let (offset, view) = x
            dfs(view, origin + offset)
          }
        Render(_) => buf.push((origin, root))
        Handle(element, _) => {
          buf.push((origin, root))
          dfs(element, origin)
        }
      }
    }
  }

  dfs(self, origin)
  buf
}

///|
pub fn Element::add_handler(self : Element, handler : Handler) -> Element {
  Handle(self, handler)
}

///|
fn Element::to_handler(x : (Vector, Element)) -> (Rect, Handler)? {
  let (offset, element) = x
  match element {
    Handle(element, handler) =>
      Some((Rect::new(offset, element.size()), handler))
    _ => None
  }
}

///|
fn Element::to_render(x : (Vector, Element)) -> (Vector, Renderable)? {
  let (offset, x) = x
  match x {
    Render(rander) => Some((offset, rander))
    _ => None
  }
}
