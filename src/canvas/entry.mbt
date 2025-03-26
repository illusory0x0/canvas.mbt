///|
let hover : Ref[(Rect, Handler)?] = Ref::new(None)

///|
fn Element::hover(
  self : Element,
  leave~ : Color,
  enter~ : Color,
  padding~ : (Element, Cache[Color]) -> Element
) -> Cache[Element] {
  let is_hoved = State::new(false)
  let color = is_hoved.cache(fn { b => if b { enter } else { leave } })
  fn on_mouse_enter() {
    is_hoved.set(true)
  }

  fn on_mouse_leave() {
    is_hoved.set(false)
  }

  let handler = Handler::new(on_mouse_enter~, on_mouse_leave~)
  let target = Cache::new(fn() { padding(self, color).handle(handler) })
  target.depend_on(color)
  target.depend_on(self)
  target
}

///|
typealias DomEventHandler = (@dom.Element) -> Unit

///|
priv struct App {
  counter : State[Int]
  target : Cache[Element]
  layout_sequence : Cache[LayoutSequence]
}

///|
fn element_refine_to_handler(x : (Vector, Element)) -> (Rect, Handler)? {
  let (offset, element) = x
  match element {
    Handle(element, handler) =>
      Some((Rect::new(offset, element.size()), handler))
    _ => None
  }
}

///|
fn element_refine_to_render(x : (Vector, Element)) -> (Vector, &Renderable)? {
  let (offset, x) = x
  match x {
    Render(rander) => Some((offset, rander))
    _ => None
  }
}

///|
fn App::on_mousemove(self : App, e : @dom.Event) -> Unit {
  let e : @dom.MouseEvent = e.downcast()
  let p : Vector = { x: e.clientX(), y: e.clientY() }
  let es = self.layout_sequence.cache
    .rev_iter()
    .filter_map(element_refine_to_handler)
  match hover.val {
    None =>
      for x in es {
        let (rect, handler) = x
        if p.inside(rect) {
          handler.on_mouse_enter.map(fn(f) { f() }) |> ignore
          hover.val = Some(x)
          // break
        }
      }
    Some((rect, handler)) =>
      if not(p.inside(rect)) {
        handler.on_mouse_leave.map(fn(f) { f() }) |> ignore
        hover.val = None
      }
  }
}

///|
fn App::on_click(self : App, e : @dom.Event) -> Unit {
  let e : @dom.MouseEvent = e.downcast()
  let p : Vector = { x: e.clientX(), y: e.clientY() }
  let es = self.layout_sequence.cache
    .rev_iter()
    .filter_map(element_refine_to_handler)
  for x in es {
    let (rect, handler) = x
    if p.inside(rect) {
      handler.on_click.map(fn(f) { f() }) |> ignore
      // break
    }
  }
}

///|
fn App::new() -> App {
  let counter = State::new(0)
  let text = counter.cache(fn { x => "counter: \{x}" })
  let font = Cache::new(fn() { font })
  let color = Cache::new(fn() { white })
  let i_20 = Cache::val(20)
  let padding_color = Cache::val(hsl(0, 0, 20))
  let button = Element::Render(
      Text::new(text=Cache::new(fn() { "+" }), font~, color~),
    )
    .round_padding(thickness=i_20, color=padding_color, radius=i_20)
    .handle(Handler::new(on_click=fn() { counter.modify(fn { x => x + 1 }) }))
  let label = Element::Render(Text::new(text~, font~, color~))
  fn padding(e : Element, c) {
    e.round_padding(thickness=i_20, color=c, radius=i_20)
  }

  let label = label.hover(
    leave=hsl(0, 0, 50),
    enter=padding_color.cache,
    padding~,
  )
  let target = label.cache(fn {
    label => Element::hstack([label, button], spacing=20)
  })
  let layout_sequence = target.cache(fn { x => x.to_layout_sequence(origin) })
  { counter, target, layout_sequence }
}

///|
pub fn entry() -> Unit {
  let app = App::new()
  let rs = app.layout_sequence.cache(fn {
    x => x.iter().filter_map(element_refine_to_render)
  })
  let render : Trigger = fn() {
    debug("App::render")
    ctx.clearRect(0, 0, window.innerWidth(), window.innerHeight())
    &Renderable::render_iter(ctx, rs.cache)
  }
  render.depend_on(rs)
  resize()
  render.run()
  window.addEventListener("resize", fn(_) {
    resize()
    app.counter.modify(@fun.id)
  })
  window.addEventListener("click", fn(e) { app.on_click(e) })
  window.addEventListener("mousemove", fn(e) { app.on_mousemove(e) })
}
