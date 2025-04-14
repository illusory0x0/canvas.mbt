///|
pub fn Element::size(self : Element) -> Size {
  match self {
    Layout(layout) => layout.get().0
    Render(x) => x.size()
    Handle(element, _) => element.size()
  }
}

///|
pub impl DepsKind for Element with render_node(self) {
  match self {
    Render(x) => x.render_node()
    Layout(l) => l
    Handle(e, _) => e.render_node()
  }
}

///|
pub impl DepsKind for Element with layout_node(self) {
  match self {
    Render(x) => x.layout_node()
    Layout(l) => l
    Handle(e, _) => e.layout_node()
  }
}

///|
pub fn Element::to_render_sequence(
  self : Element,
  origin : Vector
) -> Iter[(Vector, &Renderable)] {
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
