///|
pub fn Element::size(self : Element) -> Size {
  match self {
    Layout(size~, ..) => size
    Render(x) => x.size()
    Control(element~, ..) => element.size()
  }
}

///|
pub fn Element::spacer(size : Size) -> Element {
  Layout(size~, sort="spacer", children=[])
}

///|
pub fn Element::hstack(xs : Array[Element], spacing~ : Int) -> Element {
  let mut w = 0
  let mut h = 0
  let len = xs.length()
  let children = Array::new(capacity=len)
  for x in xs {
    let { width, height } = x.size()
    w += width
    h = @math.maximum(h, height)
    children.push(Positioned::new({ x: w, y: 0 }, x))
  }
  let size = Size::new(w + (len - 1) * spacing, h)
  Element::Layout(sort="hstack", size~, children~)
}

///|
pub fn Element::vstack(xs : Array[Element], spacing~ : Int) -> Element {
  let mut w = 0
  let mut h = 0
  let len = xs.length()
  let children = Array::new(capacity=len)
  for x in xs {
    let { width, height } = x.size()
    w = @math.maximum(w, width)
    h += height
    children.push(Positioned::new({ x: 0, y: h }, x))
  }
  let size = Size::new(w, h + (len - 1) * spacing)
  Element::Layout(sort="vstack", size~, children~)
}

///|
test "vstack" {
  let xs = [
    Element::spacer(Size::new(10, 10)),
    Element::spacer(Size::new(20, 20)),
    Element::spacer(Size::new(30, 30)),
  ]
  let view = Element::vstack(xs, spacing=2)
  inspect!(view.size(), content="{width: 30, height: 64}")
}

///|
test "hstack" {
  let xs = [
    Element::spacer(Size::new(10, 10)),
    Element::spacer(Size::new(20, 20)),
    Element::spacer(Size::new(30, 30)),
  ]
  let view = Element::hstack(xs, spacing=2)
  inspect!(view.size(), content="{width: 64, height: 30}")
}

///|
pub fn Element::to_render_sequence(
  self : Element,
  origin : Vector
) -> Array[Positioned[Renderable]] {
  guard origin.x >= 0 && origin.y >= 0
  let buf = []
  fn dfs(root : Element, origin : Vector) {
    if origin.inside_window() {
      match root {
        Layout(children~, ..) =>
          for x in children {
            let { offset, view } = x
            dfs(view, origin + offset)
          }
        Render(x) => buf.push(Positioned::new(origin, x))
        Control(element~, ..) => dfs(element, origin)
      }
    }
  }

  dfs(self, origin)
  buf
}

///|
pub fn Element::layer(xs : Array[Positioned[Element]]) -> Element {
  let mut w = 0
  let mut h = 0
  for x in xs {
    let { view, offset } = x
    let sz = view.size()
    w = @math.maximum(w, offset.x + sz.width)
    h = @math.maximum(h, offset.y + sz.height)
  }
  let size = Size::new(w, h)
  Element::Layout(sort="layer", size~, children=xs)
}

///|
pub fn Element::coordinate(xs : Array[Element]) -> Element {
  let mut w = 0
  let mut h = 0
  let children = Array::new(capacity=xs.length())
  for x in xs {
    let sz = x.size()
    w = @math.maximum(w, sz.width)
    h = @math.maximum(h, sz.height)
    children.push({ offset: { x: 0, y: 0 }, view: x })
  }
  let size = Size::new(w, h)
  Element::Layout(sort="coordinate", size~, children~)
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
fn Element::margin(
  self : Element,
  thickness~ : Thinkness,
  color~ : Color,
  sort~ : String,
  background~ : Renderable
) -> Element {
  let size = self.margin_size(thickness)
  let offset = Element::margin_offset(thickness)
  let children = [
    Positioned::new(Vector::default(), Render(background)),
    Positioned::new(offset, self),
  ]
  Layout(sort~, size~, children~)
}

///|
pub fn Element::border(
  self : Element,
  thickness~ : Thinkness,
  color~ : Color
) -> Element {
  let size = self.margin_size(thickness)
  let offset = Element::margin_offset(thickness)
  let children = [
    Positioned::new(
      Vector::default(),
      Render(Renderable::border(color~, thickness~, size~)),
    ),
    Positioned::new(offset, self),
  ]
  Layout(sort="border", size~, children~)
}

///|
pub fn Element::padding(
  self : Element,
  thickness~ : Thinkness,
  color~ : Color
) -> Element {
  let size = self.margin_size(thickness)
  let offset = Element::margin_offset(thickness)
  let children = [
    Positioned::new(
      Vector::default(),
      Render(Renderable::rectangle(color~, size~)),
    ),
    Positioned::new(offset, self),
  ]
  Layout(sort="padding", size~, children~)
}

///|
pub fn Element::text(text~ : String, font~ : Font, color~ : Color) -> Element {
  Render(Renderable::text(text~, font~, color~))
}

///|
pub fn Element::rectangle(color~ : Color, size~ : Size) -> Element {
  Render(Renderable::rectangle(color~, size~))
}

///|
pub fn Element::line(
  p1~ : Vector,
  p2~ : Vector,
  color~ : Color,
  lineWidth~ : Int = 1
) -> Element {
  Render(Renderable::line(p1~, p2~, lineWidth~, color~))
}

///|
pub fn Element::ellipse(
  center~ : Vector,
  strokeColor~ : Color,
  fillColor~ : Color,
  radiusX~ : Int,
  radiusY~ : Int,
  rotation~ : Double,
  startAngle~ : Double,
  endAngle~ : Double,
  counterclockwise~ : Bool,
  lineWidth~ : Int
) -> Element {
  Render(
    Renderable::ellipse(
      center~,
      strokeColor~,
      fillColor~,
      radiusX~,
      radiusY~,
      rotation~,
      startAngle~,
      endAngle~,
      counterclockwise~,
      lineWidth~,
    ),
  )
}

///|
pub impl Show for Element with to_string(self) {
  match self {
    Render(x) => "Render(\{x})"
    Layout(sort~, size~, children~) =>
      "Layout(sort=\{sort},size=\{size},children=\{children})"
    Control(element~, on_click~) =>
      "Control(element=\{element},on_click=\{not(on_click.is_empty())})"
  }
}

///|
pub impl Show for Element with output(self, logger) {
  logger.write_string(self.to_string())
}
