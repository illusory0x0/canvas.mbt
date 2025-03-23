///|
pub fn Renderable::size(self : Renderable) -> Size {
  match self {
    Rectangle(size~, ..) => size
    Text(size~, ..) => size
    Border(size~, ..) => size
    Line(size~, ..) => size
    Ellipse(size~, ..) => size
  }
}

///|
pub fn Renderable::render(
  self : Renderable,
  offset : Vector,
  ctx : Canvas2D
) -> Unit {
  match self {
    Rectangle(size={ width, height }, ..) =>
      ctx.fillRect(offset.x, offset.y, width, height)
    Text(text~, font~, color~, ..) => {
      ctx.set_fillStyle(color.to_string())
      ctx.set_font(font.to_string())
      ctx.set_textBaseline("top")
      ctx.fillText(text, offset.x, offset.y)
    }
    Border(
      size={ width, height },
      thickness={ left, top, right, bottom },
      color~
    ) => {
      ctx.set_fillStyle(color.to_string())
      ctx.fillRect(offset.x, offset.y, width, height)
      let cx = offset.x.to_double() + left.to_double()
      let cy = offset.y.to_double() + top.to_double()
      let cw = width.to_double() - (left.to_double() + right.to_double())
      let ch = height.to_double() - (top.to_double() + bottom.to_double())
      ctx.clearRectF(cx, cy, cw, ch)
    }
    Line(p1~, p2~, lineWidth~, color~, ..) => {
      ctx.set_strokeStyle(color.to_string())
      ctx.set_lineWidth(lineWidth)
      ctx.beginPath()
      ctx.moveTo(p1.x + offset.x, p1.y + offset.y)
      ctx.lineTo(p2.x + offset.x, p2.y + offset.y)
      ctx.stroke()
    }
    Ellipse(
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
      ..
    ) => {
      ctx.set_strokeStyle(strokeColor.to_string())
      ctx.set_fillStyle(fillColor.to_string())
      ctx.set_lineWidth(lineWidth)
      ctx.beginPath()
      ctx.ellipse(
        center.x + offset.x,
        center.y + offset.y,
        radiusX,
        radiusY,
        rotation,
        startAngle,
        endAngle,
        counterclockwise,
      )
      ctx.stroke()
      ctx.fill()
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
    size=Size::new(font.width(text), font.height(text)),
  )
}

///|
pub fn Renderable::render_sequence(
  ctx : Canvas2D,
  xs : Array[Positioned[Renderable]]
) -> Unit {
  for x in xs {
    let { offset, view: box } = x
    guard offset.x >= 0 && offset.y >= 0
    if offset.inside_window() {
      box.render(offset, ctx)
    }
  }
}

///|
pub fn Renderable::line(
  p1~ : Vector,
  p2~ : Vector,
  lineWidth~ : Int,
  color~ : Color
) -> Renderable {
  let width = p1.x - p2.x
  let height = p1.y - p2.y
  let width = if width == 0 { lineWidth } else { width.abs() }
  let height = if height == 0 { lineWidth } else { height.abs() }
  let size = { width, height }
  Line(p1~, p2~, lineWidth~, color~, size~)
}

///|
pub fn Renderable::ellipse(
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
) -> Renderable {
  let a = 2 * (radiusX + lineWidth)
  let b = 2 * (radiusY + lineWidth)
  let size = if rotation % @math.PI == 0 { // 180 degree
    let width = a
    let height = b
    { width, height }
  } else if rotation % (@math.PI / 2) == 0 { // 90 degree
    let width = b
    let height = a
    { width, height }
  } else {
    let width = (a.to_double() * @math.sin(rotation)).to_int()
    let height = (b.to_double() * @math.cos(rotation)).to_int()
    { width, height }
  }
  Ellipse(
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
    size~,
  )
}
