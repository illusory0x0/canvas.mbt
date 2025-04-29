///|
type App

///|
fn App::new() -> Unit {
  window.sync_from_device(@dom.window)
  let ls = layout_sequence()
  let rs = thunk(fn() { ls.get().filter_map(Element::to_render) })
  fn render() {
    window.dpr.get() |> ignore
    // canvas_context.clearRect(
    //   0,
    //   0,
    //   @dom.window.innerWidth().to_double(),
    //   @dom.window.innerHeight().to_double(),
    // )
    Renderable_::render_iter(canvas_context, rs.get().iter())
    @dom.requestAnimationFrame(render)
  }

  @dom.requestAnimationFrame(render)
  @dom.window.addEventListener("resize", fn(_) {
    window.sync_from_device(@dom.window)
  })
  fn get_xy(e : @dom.Event) {
    let e : @dom.MouseEvent = e.downcast()
    let x = e.clientX().to_double()
    let y = e.clientY().to_double()
    (x, y)
  }

  @dom.window.addEventListener("mousemove", fn(e) {
    let (x, y) = get_xy(e)
    App::on_mouse_move(ls, x, y)
  })
  @dom.window.addEventListener("mousedown", fn(e) {
    let (x, y) = get_xy(e)
    App::on_mouse_press(ls, x, y)
  })
  @dom.window.addEventListener("mouseup", fn(e) {
    let (x, y) = get_xy(e)
    App::on_mouse_release(ls, x, y)
  })
  @dom.window.addEventListener("dblclick", fn(e) {
    let (x, y) = get_xy(e)
    App::on_mouse_release(ls, x, y)
  })
}

