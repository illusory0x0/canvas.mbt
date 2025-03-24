///|
pub fn Renderable::size(self : Renderable) -> Size {
  match self {
    Rectangle(size~, ..) => size
    Text(size~, ..) => size
    Border(size~, ..) => size
    Line(size~, ..) => size
    Ellipse(size~, ..) => size
    RoundedBorder(size~, ..) => size
    RoundedRectangle(size~, ..) => size
  }
}

///|
pub fn Renderable::render(
  self : Renderable,
  offset : Vector,
  ctx : Canvas2D
) -> Unit {
  match self {
    Rectangle(size={ width, height }, color~) => {
      ctx.set_fillStyle(color.to_string())
      ctx.fillRect(offset.x, offset.y, width, height)
    }
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
    RoundedBorder(size~, radius~, color~, thickness~) => {
      ctx.set_strokeStyle(color.to_string())
      ctx.set_lineWidth(thickness)
      ctx.beginPath()
      ctx.roundRect(
        offset.x,
        offset.y,
        size.width,
        size.height,
        radius,
        radius,
        radius,
        radius,
      )
      ctx.stroke()
    }
    RoundedRectangle(size~, radius~, color~) => {
      ctx.set_fillStyle(color.to_string())
      ctx.beginPath()
      ctx.roundRect(
        offset.x,
        offset.y,
        size.width,
        size.height,
        radius,
        radius,
        radius,
        radius,
      )
      ctx.fill()
    }
  }
}

///|
pub fn Renderable::render_sequence(
  ctx : Canvas2D,
  xs : Iter[(Vector, Renderable)]
) -> Unit {
  for x in xs {
    let (offset, renderable) = x
    guard offset.x >= 0 && offset.y >= 0
    if offset.inside_window() {
      renderable.render(offset, ctx)
    }
  }
}
