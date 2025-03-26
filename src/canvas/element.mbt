///|
pub fn Element::size(self : Element) -> Size {
  match self {
    Layout(layout) => layout.cache.0
    Render(x) => x.size()
    Handle(element, _) => element.size()
  }
}

///|
pub impl RequiredBy for Element with require_by(self, refresh) {
  match self {
    Layout(layout) => layout.require_by(refresh)
    Render(render) => render.require_by(refresh)
    Handle(element, _) => element.require_by(refresh)
  }
}

///|
pub fn Element::spacer(size : Size) -> Element {
  let layout = Cache::new(fn() { (size, []) })
  Layout(layout)
}

///|
pub fn Element::hstack(xs : Array[Element], spacing~ : Int) -> Element {
  let layout = Cache::new(fn() {
    let mut w = 0
    let mut h = 0
    let len = xs.length()
    let children : Array[(Vector, Element)] = Array::new(capacity=len)
    for x in xs {
      children.push(({ x: w, y: 0 }, x))
      let { width, height } = x.size()
      w += width + spacing
      h = @math.maximum(h, height)
    }
    let size = Size::new(w - spacing, h)
    (size, children)
  })
  for x in xs {
    layout.depend_on(x)
  }
  Layout(layout)
}

///|
pub fn Element::vstack(xs : Array[Element], spacing~ : Int) -> Element {
  let layout = Cache::new(fn() {
    let mut w = 0
    let mut h = 0
    let len = xs.length()
    let children = Array::new(capacity=len)
    for x in xs {
      children.push((({ x: 0, y: h } : Vector), x))
      let { width, height } = x.size()
      w = @math.maximum(w, width)
      h += height + spacing
    }
    let size = Size::new(w, h - spacing)
    (size, children)
  })
  for x in xs {
    layout.depend_on(x)
  }
  Layout(layout)
}

///|
test "vstack" {
  let xs = [
    Element::spacer(Size::new(10, 10)),
    Element::spacer(Size::new(20, 20)),
    Element::spacer(Size::new(30, 30)),
  ]
  let view = Element::vstack(xs, spacing=2)
  inspect!(
    view,
    content="Layout(({width: 30, height: 64}, [({x: 0, y: 0}, Layout(({width: 10, height: 10}, []))), ({x: 0, y: 12}, Layout(({width: 20, height: 20}, []))), ({x: 0, y: 34}, Layout(({width: 30, height: 30}, [])))]))",
  )
}

///|
test "hstack" {
  let xs = [
    Element::spacer(Size::new(10, 10)),
    Element::spacer(Size::new(20, 20)),
    Element::spacer(Size::new(30, 30)),
  ]
  let view = Element::hstack(xs, spacing=2)
  inspect!(
    view,
    content="Layout(({width: 64, height: 30}, [({x: 0, y: 0}, Layout(({width: 10, height: 10}, []))), ({x: 12, y: 0}, Layout(({width: 20, height: 20}, []))), ({x: 34, y: 0}, Layout(({width: 30, height: 30}, [])))]))",
  )
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
    if origin.inside_window() {
      match root {
        Layout(layout) =>
          for x in layout.cache.1 {
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
pub fn Element::layer(xs : Array[(Vector, Element)]) -> Element {
  let layout = Cache::new(fn() {
    let mut w = 0
    let mut h = 0
    for x in xs {
      let (offset, view) = x
      let sz = view.size()
      w = @math.maximum(w, offset.x + sz.width)
      h = @math.maximum(h, offset.y + sz.height)
    }
    let size = Size::new(w, h)
    (size, xs)
  })
  for x in xs {
    layout.depend_on(x.1)
  }
  Layout(layout)
}

///|
fn Element::margin_offset(thickness : Thinkness) -> Vector {
  { x: thickness.left, y: thickness.top }
}

///|
fn Element::margin_size(self : Element, thickness : Thinkness) -> Size {
  let { width, height } = self.size()
  Size::new(
    width + thickness.left + thickness.right,
    height + thickness.top + thickness.bottom,
  )
}

///|
pub fn Element::round_border(
  self : Element,
  thickness~ : Cache[Int],
  color~ : Cache[Color],
  radius~ : Cache[Int]
) -> Element {
  let layout = Cache::new(fn() {
    let size = self.margin_size(Thinkness::same(thickness.cache))
    let offset = Element::margin_offset(Thinkness::same(thickness.cache))
    let render = RoundedBorder::new(
      color,
      thickness.cache(fn(t) { self.margin_size(Thinkness::same(t)) }),
      radius,
      thickness,
    )
    let children = [(Vector::default(), Render(render)), (offset, self)]
    (size, children)
  })
  layout.depend_on(self)
  layout.depend_on(thickness)
  layout.depend_on(color)
  layout.depend_on(radius)
  Layout(layout)
}

///|
pub fn Element::round_padding(
  self : Element,
  thickness~ : Cache[Int],
  color~ : Cache[Color],
  radius~ : Cache[Int]
) -> Element {
  let layout = Cache::new(fn() {
    let size = self.margin_size(Thinkness::same(thickness.cache))
    let offset = Element::margin_offset(Thinkness::same(thickness.cache))
    let render = RoundedRectangle::new(
      color,
      thickness.cache(fn(t) { self.margin_size(Thinkness::same(t)) }),
      radius,
    )
    let children = [(Vector::default(), Render(render)), (offset, self)]
    (size, children)
  })
  layout.depend_on(self)
  layout.depend_on(thickness)
  layout.depend_on(color)
  layout.depend_on(radius)
  Layout(layout)
}

///|
pub fn Element::handle(self : Element, handler : Handler) -> Element {
  Handle(self, handler)
}
