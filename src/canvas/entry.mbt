///|
let hover : Ref[(Rect, Handler)?] = Ref::new(None)

///|
fn Element::hover(
  self : Element,
  leave~ : (Element) -> Element,
  enter~ : (Element) -> Element
) -> Cache[Element] {
  let is_hoved = State::new(false)
  let modifier = is_hoved.cache(fn {
    is_hoved => if is_hoved { enter } else { leave }
  })
  fn on_mouse_enter() {
    // println("enter")
    // is_hoved.set(true)
  }

  fn on_mouse_leave() {
    // is_hoved.set(false)
  }

  let handler = Handler::new(on_mouse_enter~, on_mouse_leave~)
  let target = Cache::new(fn() { (modifier.cache)(self) })
  target.depend_on(self)
  target
  // modifier.cache(fn { f => f(self) })
}

///|
pub fn entry() -> Unit {
  debug("setup")
  let text = State::new("xx")
  let font = State::new(font)
  let color = State::new(white)
  // let e1 : Element = Element::hstack(
  //   [
  //     Render(
  //       Text::new(
  //         text=text.cache(@fun.id),
  //         font=font.cache(@fun.id),
  //         color=color.cache(@fun.id),
  //       ),
  //     ),
  //     Render(
  //       Text::new(
  //         text=Cache::new(fn() { "AA" }),
  //         font=font.cache(@fun.id),
  //         color=color.cache(@fun.id),
  //       ),
  //     ),
  //   ],
  //   spacing=20,
  // )
  // let e2 : Cache[Element] = e1.hover(
  //   leave=fn(e) {
  //     e.round_padding(
  //       thickness=Cache::new(fn() { 20 }),
  //       color=Cache::new(fn() { hsl(0, 0, 60) }),
  //       radius=Cache::new(fn() { 20 }),
  //     )
  //   },
  //   enter=fn(e) {
  //     e.round_padding(
  //       thickness=Cache::new(fn() { 20 }),
  //       color=Cache::new(fn() { hsl(0, 0, 20) }),
  //       radius=Cache::new(fn() { 20 }),
  //     )
  //   },
  // )

  let e1 = Element::spacer(Size::new(100,100))
  let e2 = Cache::new(fn () {e1.handle(Handler::new()) })

  // let rs : Cache[Iter[(@basic.Vector, &Renderable)]] = e2.cache(fn(e) {
  //   e.to_render_sequence(origin)
  // })
  // let render : Trigger = fn() {
  //   debug("App::render")
  //   ctx.clearRect(0, 0, window.innerWidth(), window.innerHeight())
  //   &Renderable::render_iter(ctx, rs.cache)
  // }
  // render.depend_on(rs)
  // resize()
  // (render._)()
  // window.addEventListener("resize", fn(_) {
  //   resize()
  //   (render._)()
  // })
  // window.addEventListener("click", fn(_) {
  //   debug("Window::click")
  //   text.modify(fn(x) { x + "x" })
  // })
  let event = fn {
    (o, e) =>
      match e {
        Handle(e, h) => Some((Rect::new(o, e.size()), h))
        _ => None
      }
  }


  // window.addEventListener("mousemove", fn(e) {
  //   let e : @dom.MouseEvent = e.downcast()
  //   let p : Vector = { x: e.clientX(), y: e.clientY() }
  //   let es = e2.cache.to_layout_sequence(origin).rev_iter().filter_map(event)
  //   debug(es)
  //   match hover.val {
  //     None =>
  //       for x in es {
  //         let (rect, handler) = x
  //         if p.inside(rect) {
  //           println("xx")
  //           handler.on_mouse_enter.map(fn(f) { f() }) |> ignore
  //           hover.val = Some(x)
  //           // break
  //         }
  //       }
  //     Some((rect, handler)) =>
  //       if not(p.inside(rect)) {
  //         handler.on_mouse_enter.map(fn(f) { f() }) |> ignore
  //         hover.val = None
  //       }
  //   }
  // })
}
