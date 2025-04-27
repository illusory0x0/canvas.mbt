///|
let hover : Ref[(Rect, Handler)?] = Ref::new(None)

///|
let mouse_down : Ref[(Rect, Handler)?] = Ref::new(None)

///|
typealias DomEventHandler = (@dom.Element) -> Unit

///|
priv struct App {
  counter : Cell[Int]
  target : Element
  layout_sequence : Thunk[LayoutSequence]
  render_action : Action
}

///|
fn App::on_mouse_move(self : App, e : @dom.Event) -> Unit {
  let e : @dom.MouseEvent = e.downcast()
  let current : Vector = {
    x: e.clientX().to_double(),
    y: e.clientY().to_double(),
  }
  let es = self.layout_sequence.get().rev_iter().filter_map(Element::to_handler)
  match hover.val {
    None =>
      for x in es {
        let (rect, handler) = x
        if current.inside(rect) {
          handler.on_mouse_enter.map(fn(f) { f() }) |> ignore
          hover.val = Some(x)
          break
        }
      }
    Some((rect, handler)) =>
      if not(current.inside(rect)) {
        handler.on_mouse_leave.map(fn(f) { f() }) |> ignore
        hover.val = None
      }
  }
  match mouse_down.val {
    None => ()
    Some((rect, handler)) =>
      handler.on_mouse_move.map(fn(f) { f(current - rect.offset) }) |> ignore
  }
}

///|
fn App::on_mouse_down(self : App, e : @dom.Event) -> Unit {
  let e : @dom.MouseEvent = e.downcast()
  let clicked : Vector = {
    x: e.clientX().to_double(),
    y: e.clientY().to_double(),
  }
  let es = self.layout_sequence.get().rev_iter().filter_map(Element::to_handler)
  match mouse_down.val {
    None =>
      for x in es {
        let (rect, handler) = x
        if clicked.inside(rect) {
          handler.on_mouse_down.map(fn(f) { f(clicked - rect.offset) })
          |> ignore
          mouse_down.val = Some(x)
          break
        }
      }
    Some(_) => ()
  }
}

///|
fn App::on_mouse_up(self : App, e : @dom.Event) -> Unit {
  let e : @dom.MouseEvent = e.downcast()
  let clicked = Vector::{
    x: e.clientX().to_double(),
    y: e.clientY().to_double(),
  }
  let es = self.layout_sequence.get().rev_iter().filter_map(Element::to_handler)
  match mouse_down.val {
    None => ()
    Some((rect, handler)) => {
      handler.on_mouse_up.map(fn(f) { f(clicked - rect.offset) }) |> ignore
      mouse_down.val = None
    }
  }
}

///|
fn App::on_click(self : App, e : @dom.Event) -> Unit {
  let e : @dom.MouseEvent = e.downcast()
  let p : Vector = { x: e.clientX().to_double(), y: e.clientY().to_double() }
  let es = self.layout_sequence.get().rev_iter().filter_map(Element::to_handler)
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
  let p : Vector = { x: e.clientX().to_double(), y: e.clientY().to_double() }
  let es = self.layout_sequence.get().rev_iter().filter_map(Element::to_handler)
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
  let counter = cell(0)
  let text = thunk(fn() { "counter: \{counter.get()}" })
  let font = thunk(fn() { font })
  let color = thunk(fn() { white })
  let i_20 = const_thunk(20.0)
  let padding_color = const_thunk(Color::hsl(0, 0, 20))
  let button = Element::Render(
      Text::new(text=thunk(fn() { "+" }), font~, color~),
    )
    .round_padding(thinkness=i_20, color=padding_color, radius=i_20)
    .add_handler(
      Handler::new(on_click=fn() { counter.modify(fn { x => x + 1 }) }, on_double_click=fn(

      ) {
        counter.modify(fn { x => x + 4 })
      }),
    )
  let label = Element::selected_text(
    text=thunk(fn() { [text.get()] }),
    font~,
    foregound=color,
    background=const_thunk(black),
  ).round_padding(thinkness=i_20, color=padding_color, radius=i_20)
  let target = Element::hstack(const_thunk([label, button]), spacing=20)
  let layout_sequence = thunk(fn() {
    window.size.get() |> ignore
    target.to_layout_sequence(origin)
  })
  let render_sequence = thunk(fn() {
    layout_sequence.get().filter_map(Element::to_render)
  })
  let mut rcnt = 0
  let render_action = action(fn() {
    window.dpr.get() |> ignore
    rcnt += 1
    println(rcnt)
    debug("App::render")
    ctx.clearRect(
      0,
      0,
      @dom.window.innerWidth().to_double(),
      @dom.window.innerHeight().to_double(),
    )
    &Renderable::render_iter(ctx, render_sequence.get().iter())
  })
  { counter, target, layout_sequence, render_action }
}

///|
fn main {
  // println("hello")
  let app = App::new()
  app.render_action.run()
  @dom.window.addEventListener("resize", fn(_) {
    window.sync()
    app.render_action.run()
  })
  @dom.window.addEventListener("click", fn(e) {
    app.on_click(e)
    app.render_action.run()
  })
  @dom.window.addEventListener("mousemove", fn(e) {
    app.on_mouse_move(e)
    app.render_action.run()
  })
  @dom.window.addEventListener("mousedown", fn(e) {
    app.on_mouse_down(e)
    app.render_action.run()
  })
  @dom.window.addEventListener("mouseup", fn(e) {
    app.on_mouse_up(e)
    app.render_action.run()
  })
  @dom.window.addEventListener("dblclick", fn(e) {
    app.on_double_click(e)
    app.render_action.run()
  })
}
