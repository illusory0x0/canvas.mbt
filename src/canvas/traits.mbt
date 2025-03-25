pub(open) trait Renderable {
  size(Self) -> Size 
  render(Self, Vector,@dom.Canvas2D) -> Unit
}