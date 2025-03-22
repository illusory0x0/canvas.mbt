///|
pub fn Renderable::color(self : Renderable) -> Color {
  match self {
    Rectangle(color~, ..) => color
    Text(color~, ..) => color
    Border(color~, ..) => color
  }
}

///|
pub fn Renderable::size(self : Renderable) -> Size {
  match self {
    Rectangle(size~, ..) => size
    Text(size~,..) => size
    Border(size~, ..) => size
  }
}

///|
pub fn Renderable::render(
  self : Renderable,
  offset : Vector,
  ctx : Canvas2D
) -> Unit {
  ctx.set_fillStyle(self.color().to_string())  
  let { x, y } = offset
  match self {
    Rectangle(size={ width, height }, ..) => ctx.fillRect(x, y, width, height)
    Text(text~, font~,..) => {
      ctx.set_font(font.to_string())
      ctx.set_textBaseline("top")
      ctx.fillText(text, x, y)
    }
    Border(size={ width, height }, thickness={ left, top, right, bottom }, ..) => {
      ctx.fillRect(x, y, width, height)
      let times = 10.
      let cx = x.to_double() + left.to_double() / times
      let cy = y.to_double() + top.to_double() / times
      let cw = width.to_double() -
        (left.to_double() + right.to_double()) / times
      let ch = height.to_double() -
        (top.to_double() + bottom.to_double()) / times
      ctx.clearRectF(cx, cy, cw, ch)
    }
  }
}

///|
pub fn Renderable::rectangle(size~ : Size, color~ : Color) -> Renderable {
  Rectangle(size~, color~)
}

///|
pub fn Renderable::border(
  size~ : Size,
  color~ : Color,
  thickness~ : Thinkness
) -> Renderable {
  Border(size~, color~, thickness~)
}

///|
pub fn Renderable::text(
  text~ : String,
  font~ : Font,
  color~ : Color
) -> Renderable {
  Text(
    text~,
    color~,
    font~,
    size=Size::new(font.width(text),font.height(text)))
}

pub fn Renderable::render_sequence(ctx : Canvas2D, xs : Array[Positioned[Renderable]]) -> Unit {
  for x in xs {
    let { offset,view: box} = x 
    guard (offset.x >= 0 && offset.y >= 0)
    if offset.inside_window() {
      box.render(offset,ctx)
    }
  }
}