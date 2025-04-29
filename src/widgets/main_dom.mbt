///|
typealias DomEventHandler = (@dom.Element) -> Unit

///|
priv struct App {
  layout_sequence : Thunk[LayoutSequence]
  render_action : Action
}

///|
fn App::on_mouse_move(self : App, e : @dom.Event) -> Unit {
  let e : @dom.MouseEvent = e.downcast()
  let x = e.clientX().to_double()
  let y = e.clientY().to_double()
  global_handle_mouse_move(self.layout_sequence, x, y)
}

///|
fn App::on_mouse_down(self : App, e : @dom.Event) -> Unit {
  let e : @dom.MouseEvent = e.downcast()
  let x = e.clientX().to_double()
  let y = e.clientY().to_double()
  global_handle_mouse_press(self.layout_sequence, x, y)
}

///|
fn App::on_mouse_up(self : App, e : @dom.Event) -> Unit {
  let e : @dom.MouseEvent = e.downcast()
  let x = e.clientX().to_double()
  let y = e.clientY().to_double()
  global_handle_mouse_release(self.layout_sequence, x, y)
}

///|
fn App::on_click(self : App, e : @dom.Event) -> Unit {
  // do nothing
}

///|
fn App::on_double_click(self : App, e : @dom.Event) -> Unit {
  let e : @dom.MouseEvent = e.downcast()
  let x = e.clientX().to_double()
  let y = e.clientY().to_double()
  global_handle_double_click(self.layout_sequence, x, y)
}

///|
fn App::new() -> App {
  window.sync_from_device(@dom.window)
  let layout_sequence = layout_sequence()
  let render_sequence = thunk(fn() {
    layout_sequence.get().filter_map(Element::to_render)
  })
  let render_action = action(fn() {
    window.dpr.get() |> ignore
    canvas_context.clearRect(
      0,
      0,
      @dom.window.innerWidth().to_double(),
      @dom.window.innerHeight().to_double(),
    )
    Renderable_::render_iter(canvas_context, render_sequence.get().iter())
  })
  { layout_sequence, render_action }
}

///|
fn main {
  let app = App::new()
  fn render() {
    app.render_action.run()
    @dom.requestAnimationFrame(render)
  }

  @dom.requestAnimationFrame(render)
  @dom.window.addEventListener("resize", fn(_) {
    window.sync_from_device(@dom.window)
  })
  @dom.window.addEventListener("click", fn(e) { app.on_click(e) })
  @dom.window.addEventListener("mousemove", fn(e) { app.on_mouse_move(e) })
  @dom.window.addEventListener("mousedown", fn(e) { app.on_mouse_down(e) })
  @dom.window.addEventListener("mouseup", fn(e) { app.on_mouse_up(e) })
  @dom.window.addEventListener("dblclick", fn(e) { app.on_double_click(e) })
}
