///|
let hover : Ref[(Rect, Handler)?] = Ref::new(None)

///|
typealias DomEventHandler = (@dom.Element) -> Unit

///|
priv struct App {
  counter : Node[Int]
  target : Element
  layout_sequence : Node[LayoutSequence]
  render_action : Node[Unit]
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
  let es = self.layout_sequence
    .get()
    .rev_iter()
    .filter_map(element_refine_to_handler)
  match hover.val {
    None =>
      for x in es {
        let (rect, handler) = x
        if p.inside(rect) {
          handler.on_mouse_enter.map(fn(f) { f() }) |> ignore
          hover.val = Some(x)
          break
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
  let es = self.layout_sequence
    .get()
    .rev_iter()
    .filter_map(element_refine_to_handler)
  for x in es {
    let (rect, handler) = x
    if p.inside(rect) {
      handler.on_click.map(fn(f) { f() }) |> ignore
      break
    }
  }
}

///|
fn App::on_double_click(self : App, e : @dom.Event) -> Unit {
  let e : @dom.MouseEvent = e.downcast()
  let p : Vector = { x: e.clientX(), y: e.clientY() }
  let es = self.layout_sequence
    .get()
    .rev_iter()
    .filter_map(element_refine_to_handler)
  for x in es {
    let (rect, handler) = x
    if p.inside(rect) {
      handler.on_double_click.map(fn(f) { f() }) |> ignore
      break
    }
  }
}

///|
fn App::new() -> App {
  window.sync()
  let counter = Node::from_val(0)
  let text = counter.map(fn { x => "counter: \{x}" })
  let font = Node::from_fun(fn() { font })
  let color = Node::from_fun(fn() { white })
  let i_20 = Node::from_val(20)
  let padding_color = Node::from_val(hsl(0, 0, 20))
  let button = Element::Render(
      Text::new(text=Node::from_fun(fn() { "+" }), font~, color~),
    )
    .round_padding(thickness=i_20, color=padding_color, radius=i_20)
    .add_handler(
      Handler::new(on_click=fn() { counter.modify(fn { x => x + 1 }) }, on_double_click=fn(

      ) {
        counter.modify(fn { x => x + 100 })
      }),
    )
  let label = Element::Render(Text::new(text~, font~, color~)).hover(
    leave=hsl(0, 0, 50),
    enter=hsl(0, 0, 20),
    padding=fn { e, c => e.round_padding(thickness=i_20, color=c, radius=i_20) },
  )
  let target = Element::hstack([label, button], spacing=20)
  let layout_sequence = Node::from_fun(fn() {
    window.size.sync()
    target.to_layout_sequence(origin)
  })
  layout_sequence.depend_on(window.size)
  layout_sequence.depend_on(target.layout_node())
  let render_sequence = layout_sequence.map(fn {
    x => x.iter().filter_map(element_refine_to_render)
  })
  let render_action = render_sequence.map(fn(rs) {
    window.dpr.sync()
    debug("App::render")
    ctx.clearRect(0, 0, @dom.window.innerWidth(), @dom.window.innerHeight())
    &Renderable::render_iter(ctx, rs)
  })
  render_action.depend_on(window.dpr)
  { counter, target, layout_sequence, render_action }
}

///|
pub fn entry() -> Unit {
  let app = App::new()
  @dom.window.addEventListener("resize", fn(_) {
    window.sync()
    app.render_action.sync()
  })
  @dom.window.addEventListener("click", fn(e) {
    app.on_click(e)
    app.render_action.sync()
  })
  @dom.window.addEventListener("mousemove", fn(e) {
    app.on_mousemove(e)
    app.render_action.sync()
  })
  @dom.window.addEventListener("dblclick", fn(e) {
    app.on_double_click(e)
    app.render_action.sync()
  })
}
