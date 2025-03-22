
///|
pub fn View::size(self : View) -> Size {
  match self {
    Layout(size~, ..) => size
    Render(x) => x.size()
  }
}

///|
pub fn View::spacer(size : Size) -> View {
  Layout(size~, sort="spacer", children=[])
}

///|
pub fn View::hstack(xs : Array[View], spacing~ : Int) -> View {
  let mut w = 0
  let mut h = 0
  let len = xs.length()
  let children = Array::new(capacity=len)
  for x in xs {
    let { width, height } = x.size()
    w += width
    h = @math.maximum(h, height)
    children.push(Positioned::new(Vector::new(w, 0), x))
  }
  let size = Size::new(w + (len - 1) * spacing, h)
  View::Layout(sort="hstack", size~, children~)
}

///|
pub fn View::vstack(xs : Array[View], spacing~ : Int) -> View {
  let mut w = 0
  let mut h = 0
  let len = xs.length()
  let children = Array::new(capacity=len)
  for x in xs {
    let { width, height } = x.size()
    w = @math.maximum(w, width)
    h += height
    children.push(Positioned::new(Vector::new(0, h), x))
  }
  let size = Size::new(w, h + (len - 1) * spacing)
  View::Layout(sort="vstack", size~, children~)
}

///|
test "vstack" {
  let xs = [
    View::spacer(Size::new(10, 10)),
    View::spacer(Size::new(20, 20)),
    View::spacer(Size::new(30, 30)),
  ]
  let view = View::vstack(xs, spacing=2)
  inspect!(view.size(), content="{width: 30, height: 64}")
}

///|
test "hstack" {
  let xs = [
    View::spacer(Size::new(10, 10)),
    View::spacer(Size::new(20, 20)),
    View::spacer(Size::new(30, 30)),
  ]
  let view = View::hstack(xs, spacing=2)
  inspect!(view.size(), content="{width: 64, height: 30}")
}

///|
pub fn View::to_render_sequence(
  self : View,
  origin : Vector
) -> Array[Positioned[Renderable]] {
  guard origin.x >= 0 && origin.y >= 0
  let buf = []
  fn dfs(root : View, origin : Vector) {
    if origin.inside_window() {
      match root {
        Layout(children~, ..) =>
          for x in children {
            let { offset, view } = x
            dfs(view, origin + offset)
          }
        Render(x) => buf.push(Positioned::new(origin, x))
      }
    }
  }

  dfs(self, origin)
  buf
}

pub fn View::layer(xs : Array[Positioned[View]]) -> View {
  let mut w = 0
  let mut h = 0
  for x in xs {
    let { view, offset } = x
    let sz = view.size()
    w = @math.maximum(w,offset.x + sz.width)
    h = @math.maximum(h, offset.y + sz.height)
  }
  let size = Size::new(w, h)
  View::Layout(sort="layer", size~, children=xs)
}

fn View::margin_offset(thickness : Thinkness) -> Vector {
  Vector::new(thickness.left, thickness.top)
}

fn View::margin_size(self : View,thickness : Thinkness) -> Size {
  let {width,height} = self.size()
  Size::new(
    width + thickness.left + thickness.right,
     height + thickness.top + thickness.bottom)
}

fn View::margin(
  self : View,
  thickness~ : Thinkness,
  color~ : Color,
  sort~ : String,
  background~ : Renderable
) -> View {
  let size = self.margin_size(thickness)
  let offset = View::margin_offset(thickness)
  let children = [
    Positioned::new(Vector::default(), Render(background)),
    Positioned::new(offset, self)
  ]
  Layout(
    sort~, 
    size~,
    children~
  )
}

pub fn View::border(self : View, thickness~ : Thinkness, color~ : Color) -> View { 
    let size = self.margin_size(thickness)
  let offset = View::margin_offset(thickness)
  let children = [
    Positioned::new(Vector::default(), Render(Renderable::border(color~, thickness~, size~))),
    Positioned::new(offset, self)
  ]
  Layout(
    sort="border", 
    size~,
    children~
  )
}

pub fn View::padding(self : View, thickness~ : Thinkness, color~ : Color) -> View { 
    let size = self.margin_size(thickness)
  let offset = View::margin_offset(thickness)
  let children = [
    Positioned::new(Vector::default(), Render(Renderable::rectangle(color~, size~))),
    Positioned::new(offset, self)
  ]
  Layout(
    sort="padding", 
    size~,
    children~
  )
}