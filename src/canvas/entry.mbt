///|
pub fn entry() -> Unit {
  let app : App = App::new()
  fn run(action) {
    match action {
      None => ()
      Some(f) => f()
    }
  }

  let render = Dependency::new(fn() { app.render() })
  render.depend_on(app.cache)
  window.addEventListener("resize", fn(_) { resize() })
  window.addEventListener("click", fn(e) {
    let e : @dom.MouseEvent = e.downcast()
    for x in app.event_sequence() {
      let (rect, handler) = x
      let p = { x: e.clientX(), y: e.clientY() }
      if p.inside(rect) {
        handler.on_click |> run
        break
      }
    }
  })
  window.addEventListener("mousemove", fn(e) {
    let e : @dom.MouseEvent = e.downcast()
    let p = { x: e.clientX(), y: e.clientY() }
    match hover.val {
      None =>
        for x in app.event_sequence() {
          let (rect, handler) = x
          if p.inside(rect) {
            handler.on_mouse_enter |> run
            hover.val = Some(x)
            break
          }
        }
      Some((rect, handler)) =>
        if not(p.inside(rect)) {
          handler.on_mouse_leave |> run
          hover.val = None
        }
    }
  })
  resize()
  app.render()
}