// 添加粒度更小的依赖管理，现在是把全部更新状态往父节点，上传递

///|
pub(open) trait Renderable: RequiredBy {
  size(Self) -> Size
  render(Self, Vector, @dom.Canvas2D) -> Unit
}

///|
pub impl Show for &Renderable with output(self, logger) {

}
