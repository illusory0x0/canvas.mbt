///|
pub(open) trait Renderable: DepsKind {
  size(Self) -> Size
  render(Self, Vector, @dom.Canvas2D) -> Unit
}

///|
pub(open) trait DepsKind {
  render_node(Self) -> &VNode
  layout_node(Self) -> &VNode
}

///|
pub impl Show for &Renderable with output(self, logger) {

}
