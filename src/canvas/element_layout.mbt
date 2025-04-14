///|
pub fn Element::spacer(size : Size) -> Element {
  let layout = Node::from_fun(fn() { (size, []) })
  Layout(layout)
}

///|
pub fn Element::hstack(xs : Array[Element], spacing~ : Int) -> Element {
  let layout = Node::from_fun(fn() {
    let mut w = 0
    let mut h = 0
    let children : Array[(Vector, Element)] = Array::new(capacity=xs.length())
    for x in xs {
      guard w < window.size.get().width else { break } // doesn't layout beyond window
      children.push(({ x: w, y: 0 }, x))
      let { width, height } = x.size()
      w += width + spacing
      h = @math.maximum(h, height)
    }
    let size = Size::new(w - spacing, h)
    (size, children)
  })
  for x in xs {
    layout.depend_on(x.layout_node())
  }
  Layout(layout)
}

///|
pub fn Element::vstack(xs : Array[Element], spacing~ : Int) -> Element {
  let layout = Node::from_fun(fn() {
    let mut w = 0
    let mut h = 0
    let children = Array::new(capacity=xs.length())
    for x in xs {
      guard h < window.size.get().height else { break } // doesn't layout beyond window
      children.push((({ x: 0, y: h } : Vector), x))
      let { width, height } = x.size()
      w = @math.maximum(w, width)
      h += height + spacing
    }
    let size = Size::new(w, h - spacing)
    (size, children)
  })
  for x in xs {
    layout.depend_on(x.layout_node())
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
pub fn Element::layer(xs : Array[(Vector, Element)]) -> Element {
  let layout = Node::from_fun(fn() {
    let window = window.size.get()
    let mut w = 0
    let mut h = 0
    for x in xs {
      let (offset, view) = x
      guard offset.x < window.width && offset.y < window.height else { break } // doesn't layout beyond window
      let sz = view.size()
      w = @math.maximum(w, offset.x + sz.width)
      h = @math.maximum(h, offset.y + sz.height)
    }
    let size = Size::new(w, h)
    (size, xs)
  })
  for x in xs {
    layout.depend_on(x.1.layout_node())
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
  thickness~ : Node[Int],
  color~ : Node[Color],
  radius~ : Node[Int]
) -> Element {
  let layout = Node::from_fun(fn() {
    let size = self.margin_size(Thinkness::same(thickness.get()))
    let offset = Element::margin_offset(Thinkness::same(thickness.get()))
    let render = RoundedBorder::new(
      color~,
      size=thickness.map(fn(t) { self.margin_size(Thinkness::same(t)) }),
      radius~,
      thickness~,
    )
    let children = [(Vector::default(), Render(render)), (offset, self)]
    (size, children)
  })
  layout.depend_on(self.layout_node())
  layout.depend_on(thickness)
  layout.depend_on(color)
  layout.depend_on(radius)
  Layout(layout)
}

///|
pub fn Element::round_padding(
  self : Element,
  thickness~ : Node[Int],
  color~ : Node[Color],
  radius~ : Node[Int]
) -> Element {
  let layout = Node::from_fun(fn() {
    let size = self.margin_size(Thinkness::same(thickness.get()))
    let offset = Element::margin_offset(Thinkness::same(thickness.get()))
    let render = RoundedRectangle::new(
      color~,
      size=thickness.map(fn(t) { self.margin_size(Thinkness::same(t)) }),
      radius~,
    )
    let children = [(Vector::default(), Render(render)), (offset, self)]
    (size, children)
  })
  layout.depend_on(self.layout_node())
  layout.depend_on(thickness)
  layout.depend_on(color)
  layout.depend_on(radius)
  Layout(layout)
}
