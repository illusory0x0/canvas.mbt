///|
pub(open) trait Renderable: DepsKind {
  size(Self) -> Size
  render(Self, Vector, @qpainter.QPainter) -> Unit
}

///|
pub(open) trait DepsKind {
  render_node(Self) -> Node
  layout_node(Self) -> Node
}

///|
pub impl Show for &Renderable with output(self, logger) {

}
