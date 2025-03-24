///|
pub fn Element::size(self : Element) -> Size {
  match self {
    Layout(size~, ..) => size
    Render(x) => x.size()
    Control(element,_) => element.size()
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
    children.push(({ x: w, y: 0 }, x))
    let { width, height } = x.size()
    w += width + spacing
    h = @math.maximum(h, height)
  }
  let size = Size::new(w - spacing, h)
  Element::Layout(sort="hstack", size~, children~)
}

///|
pub fn Element::vstack(xs : Array[Element], spacing~ : Int) -> Element {
  let mut w = 0
  let mut h = 0
  let len = xs.length()
  let children = Array::new(capacity=len)
  for x in xs {
    children.push(({ x: 0, y: h }, x))
    let { width, height } = x.size()
    w = @math.maximum(w, width)
    h += height + spacing
  }
  let size = Size::new(w, h - spacing)
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
  inspect!(view, content=
    #|Layout(sort="vstack", size={width: 30, height: 64}, children=[({x: 0, y: 0}, Layout(sort="spacer", size={width: 10, height: 10}, children=[])), ({x: 0, y: 12}, Layout(sort="spacer", size={width: 20, height: 20}, children=[])), ({x: 0, y: 34}, Layout(sort="spacer", size={width: 30, height: 30}, children=[]))])
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
  inspect!(view, content=
    #|Layout(sort="hstack", size={width: 64, height: 30}, children=[({x: 0, y: 0}, Layout(sort="spacer", size={width: 10, height: 10}, children=[])), ({x: 12, y: 0}, Layout(sort="spacer", size={width: 20, height: 20}, children=[])), ({x: 34, y: 0}, Layout(sort="spacer", size={width: 30, height: 30}, children=[]))])
  )
}

///|
pub fn Element::to_render_sequence(
  self : Element,
  origin : Vector
) -> Iter[(Vector,Renderable)] {
  self.to_layout_sequence(origin).iter().filter_map(fn { (offset,element) => {
    match element {
      Render(x) => Some((offset, x))
      _ => None
    }
  }})
}

pub fn Element::to_layout_sequence(
  self : Element,
  origin : Vector
) -> Array[(Vector,Element)] {
  guard origin.x >= 0 && origin.y >= 0
  let buf = []
  fn dfs(root : Element, origin : Vector) {
    if origin.inside_window() {
      match root {
        Layout(children~, ..) =>
          for x in children {
            let (offset,view) = x
            dfs(view, origin + offset)
          }
        Render(_) => buf.push((origin, root))
        Control(element, _) =>  { 
          buf.push((origin,root))
          dfs(element, origin) 
        }
      }
    }
  }
  dfs(self, origin)
  buf
}

///|
pub fn Element::layer(xs : Array[(Vector,Element)]) -> Element {
  let mut w = 0
  let mut h = 0
  for x in xs {
    let (offset,view) = x
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
    children.push(({x : 0, y :0},x))
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
    (Vector::default(), Render(background)),
    (offset, self),
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
    (
      Vector::default(),
      Render(Renderable::border(color~, thickness~, size~)),
    ),
    (offset, self),
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
    (
      Vector::default(),
      Element::rectangle(color~,size~)
    ),
    (offset, self),
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



pub fn Element::control(self : Element,   on_click? : OnClick,
  on_double_click? : OnClick) -> Element {
    Control(self,{on_click,on_double_click})
}