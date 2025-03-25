///|
pub fn entry() -> Unit {
  let text = State::new("xx")
  let font = State::new(font)
  let color = State::new(white)
  let element : Element = Element::hstack(
    [
      Render(
        Text::new(
          text=text.cache(@fun.id),
          font=font.cache(@fun.id),
          color=color.cache(@fun.id),
        ),
      ),
      Render(
        Text::new(
          text=Cache::new(fn() { "AA" }),
          font=font.cache(@fun.id),
          color=color.cache(@fun.id),
        ),
      ),
    ],
    spacing=0,
  )
  let rs : Cache[Iter[(@basic.Vector, &Renderable)]] = Cache::new(fn() {
    element.to_render_sequence(origin)
  })
  rs.depend_on(element)
  let render : Trigger = fn() {
    debug("render action")
    ctx.clearRect(0, 0, window.innerWidth(), window.innerHeight())
    &Renderable::render_iter(ctx, rs.cache)
  }
  render.depend_on(rs)
  fn run_app() {
    resize()
    &Renderable::render_iter(ctx, rs.cache)
  }

  run_app()
  window.addEventListener("resize", fn(_) { run_app() })
  window.addEventListener("click", fn(_) { text.modify(fn(x) { x + "x" }) })
}

// let app : App = App::new()
// fn run(action) {
//   match action {
//     None => ()
//     Some(f) => f()
//   }
// }

// let render = Dependency::new(fn() { app.render() })
// render.depend_on(app.cache)
// window.addEventListener("click", fn(e) {
//   let e : @dom.MouseEvent = e.downcast()
//   for x in app.event_sequence() {
//     let (rect, handler) = x
//     let p : Vector = { x: e.clientX(), y: e.clientY() }
//     if p.inside(rect) {
//       handler.on_click |> run
//       // break
//     }
//   }
// })
// window.addEventListener("mousemove", fn(e) {
//   let e : @dom.MouseEvent = e.downcast()
//   let p : Vector = { x: e.clientX(), y: e.clientY() }
//   match hover.val {
//     None =>
//       for x in app.event_sequence() {
//         let (rect, handler) = x
//         if p.inside(rect) {
//           handler.on_mouse_enter |> run
//           hover.val = Some(x)
//           // break
//         }
//       }
//     Some((rect, handler)) =>
//       if not(p.inside(rect)) {
//         handler.on_mouse_leave |> run
//         hover.val = None
//       }
//   }
// })
// resize()
// app.render()
