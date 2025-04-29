///|
let window : Window = { size: cell(Size::new(1280, 720)), dpr: cell(1) }

///|
fn Window::width(self : Window) -> Double {
  self.size.get().width
}

///|
fn Window::height(self : Window) -> Double {
  self.size.get().height
}

///|
fn Window::contains(self : Window, v : Vector) -> Bool {
  v.x < self.width() && v.y < self.height()
}

///|
let font : Font = { ..Font::default(), weight: 320 }

///|
let origin : Vector = { x: 20, y: 20 }

///|
fn const_thunk[A : Eq](value : A) -> Thunk[A] {
  thunk(fn() { value })
}

///|
fn cell_to_thunk[A : Eq](cell : Cell[A]) -> Thunk[A] {
  thunk(fn() { cell.get() })
}

///|
pub fn Renderable_::render_iter(
  painter : Painter,
  xs : Iter[(Vector, Renderable_)]
) -> Unit {
  for x in xs {
    let (offset, renderable) = x
    guard offset.x >= 0 && offset.y >= 0
    if window.contains(offset) {
      renderable.render(offset, painter._)
    }
  }
}

// ///|
///|
pub fn mk_text(
  text~ : Thunk[String],
  font~ : Thunk[Font],
  color~ : Thunk[Color]
) -> Renderable_ {
  let size = thunk(fn() {
    let font = font.get()
    let text = text.get()
    Size::new(font.width(text), font.height(text))
  })
  Text(text~, font~, color~, size~)
}

///|
fn layout_sequence() -> Thunk[LayoutSequence] {
  let counter = cell(0)
  let t = thunk(fn() { "counter: \{counter.get()}" })
  let font = thunk(fn() { font })
  let color = thunk(fn() { white })
  let num_20 = const_thunk(20.0)
  let padding_color = const_thunk(Color::hsl(0, 0, 20))
  let button = Element::Render(mk_text(text=thunk(fn() { "+" }), font~, color~))
    .round_padding(thinkness=num_20, color=padding_color,radius=num_20)
    .add_handler(
      Handler::new(on_click=fn() { counter.modify(fn { x => x + 1 }) }, on_double_click=fn(

      ) {
        counter.modify(fn { x => x + 4 })
      }),
    )
  let label = Element::selected_text(
    text=thunk(fn() { xs }),
    font~,
    foregound=color,
    background=const_thunk(black),
  ).round_padding(thinkness=num_20, color=padding_color,radius=num_20)
  let target = Element::hstack(const_thunk([label, button]), spacing=20)
  let res = thunk(fn() {
    window.size.get() |> ignore
    target.to_layout_sequence(origin)
  })
  res
}

///|
let hover : Ref[(Rect, Handler)?] = Ref::new(None)

///|
let mouse_down : Ref[(Rect, Handler)?] = Ref::new(None)

///|
fn App::on_mouse_move(
  ls : Thunk[LayoutSequence],
  x : Double,
  y : Double
) -> Unit {
  let current : Vector = { x, y }
  let es = ls.get().rev_iter().filter_map(Element::to_handler)
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
fn App::on_mouse_press(
  ls : Thunk[LayoutSequence],
  x : Double,
  y : Double
) -> Unit {
  let clicked : Vector = { x, y }
  let es = ls.get().rev_iter().filter_map(Element::to_handler)
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
fn App::on_mouse_release(
  ls : Thunk[LayoutSequence],
  x : Double,
  y : Double
) -> Unit {
  let clicked = Vector::{ x, y }
  let es = ls.get().rev_iter().filter_map(Element::to_handler)
  match mouse_down.val {
    None => ()
    Some((rect, handler)) => {
      handler.on_mouse_up.map(fn(f) { f(clicked - rect.offset) }) |> ignore
      mouse_down.val = None
    }
  }
  let p : Vector = { x, y }
  let es = ls.get().rev_iter().filter_map(Element::to_handler)
  for x in es {
    let (rect, handler) = x
    if p.inside(rect) {
      handler.on_click.map(fn(f) { f() }) |> ignore
      break
    }
  }
}

///|
fn App::on_double_click(
  ls : Thunk[LayoutSequence],
  x : Double,
  y : Double
) -> Unit {
  let p : Vector = { x, y }
  let es = ls.get().rev_iter().filter_map(Element::to_handler)
  for x in es {
    let (rect, handler) = x
    if p.inside(rect) {
      handler.on_double_click.map(fn(f) { f() }) |> ignore
      break
    }
  }
}
