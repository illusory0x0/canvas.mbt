///|
pub fn Element::spacer(size : Size) -> Element {
  let layout = thunk(fn() { (size, []) })
  Layout(layout)
}

///|
pub fn Element::hstack(xs : Array[Element], spacing~ : Double) -> Element {
  let layout = thunk(fn() {
    let mut w = 0.0
    let mut h = 0.0
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
  Layout(layout)
}

///|
pub fn Element::vstack(xs : Array[Element], spacing~ : Double) -> Element {
  let layout = thunk(fn() {
    let mut w = 0.0
    let mut h = 0.0
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
  Layout(layout)
}

///|
pub fn Element::layer(xs : Array[(Vector, Element)]) -> Element {
  let layout = thunk(fn() {
    let window = window.size.get()
    let mut w = 0.0
    let mut h = 0.0
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
  thickness~ : Thunk[Double],
  color~ : Thunk[Color],
  radius~ : Thunk[Double]
) -> Element {
  let layout = thunk(fn() {
    let size = self.margin_size(Thinkness::same(thickness.get()))
    let offset = Element::margin_offset(Thinkness::same(thickness.get()))
    let render = RoundedBorder::new(
      color~,
      size=thunk(fn() { self.margin_size(Thinkness::same(thickness.get())) }),
      radius~,
      thickness~,
    )
    let children = [(Vector::default(), Render(render)), (offset, self)]
    (size, children)
  })
  Layout(layout)
}

///|
pub fn Element::round_padding(
  self : Element,
  thinkness~ : Thunk[Double],
  color~ : Thunk[Color],
  radius~ : Thunk[Double]
) -> Element {
  let layout = thunk(fn() {
    let size = self.margin_size(Thinkness::same(thinkness.get()))
    let offset = Element::margin_offset(Thinkness::same(thinkness.get()))
    let render = RoundedRectangle::new(
      color~,
      size=thunk(fn() { self.margin_size(Thinkness::same(thinkness.get())) }),
      radius~,
    )
    let children = [(Vector::default(), Render(render)), (offset, self)]
    (size, children)
  })
  Layout(layout)
}
