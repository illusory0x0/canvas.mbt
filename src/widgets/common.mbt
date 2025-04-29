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
let white : Color = Color::hsl(0, 0, 100)

///|
let black : Color = Color::hsl(0, 0, 0)

///|
let yellow : Color = Color::hsl(60, 100, 50)

///|
let red : Color = Color::hsl(0, 100, 50)

///|
let green : Color = Color::hsl(120, 100, 50)

///|
let blue : Color = Color::hsl(240, 100, 50)

///|
let font : Font = { ..Font::default(), weight: 320 }

///|
let origin : Vector = { x: 20, y: 20 }

///|
priv type Action Thunk[Int]

///|
fn Action::run(self : Action) -> Unit {
  self._.get() |> ignore
}

///|
fn Action::new(f : () -> Unit) -> Action {
  let mut state = 0
  thunk(fn() {
    f()
    state += 1
    state
  })
}

///|
fn Action::to_node(self : Action) -> Node {
  self._
}

///|
fn action(f : () -> Unit) -> Action {
  Action::new(f)
}

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
fn global_handle_mouse_move(
  layout_sequence : Thunk[LayoutSequence],
  x : Double,
  y : Double
) -> Unit {
  let current : Vector = { x, y }
  let es = layout_sequence.get().rev_iter().filter_map(Element::to_handler)
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
fn global_handle_mouse_release(
  layout_sequence : Thunk[LayoutSequence],
  x : Double,
  y : Double
) -> Unit {
  let clicked = Vector::{ x, y }
  let es = layout_sequence.get().rev_iter().filter_map(Element::to_handler)
  match mouse_down.val {
    None => ()
    Some((rect, handler)) => {
      handler.on_mouse_up.map(fn(f) { f(clicked - rect.offset) }) |> ignore
      mouse_down.val = None
    }
  }
  let p : Vector = { x, y }
  let es = layout_sequence.get().rev_iter().filter_map(Element::to_handler)
  for x in es {
    let (rect, handler) = x
    if p.inside(rect) {
      handler.on_click.map(fn(f) { f() }) |> ignore
      break
    }
  }
}

///|
fn global_handle_mouse_press(
  layout_sequence : Thunk[LayoutSequence],
  x : Double,
  y : Double
) -> Unit {
  let clicked : Vector = { x, y }
  let es = layout_sequence.get().rev_iter().filter_map(Element::to_handler)
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
fn global_handle_double_click(
  layout_sequence : Thunk[LayoutSequence],
  x : Double,
  y : Double
) -> Unit {
  let p : Vector = { x, y }
  let es = layout_sequence.get().rev_iter().filter_map(Element::to_handler)
  for x in es {
    let (rect, handler) = x
    if p.inside(rect) {
      handler.on_double_click.map(fn(f) { f() }) |> ignore
      break
    }
  }
}

///|
const Lorem =
  #| Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce nec sagittis urna. Proin accumsan dapibus convallis. Duis quis ultrices ligula. Duis gravida tincidunt turpis, nec placerat quam lacinia vitae. Sed a porta sem, nec mattis elit. Nunc pharetra varius tellus, nec condimentum justo suscipit a. Proin molestie, ligula nec ultrices viverra, ante erat congue quam, eget vulputate leo purus quis elit. Nullam luctus urna at pretium tincidunt. Pellentesque at dictum libero, ac cursus sem.
  #| Nullam tortor ipsum, consectetur vel efficitur eu, faucibus vitae ligula. Aliquam egestas arcu sit amet leo gravida, in tincidunt ipsum viverra. Nunc at mauris eros. Nam sit amet venenatis elit. Nullam sed nulla eget magna bibendum consectetur ut eu ipsum. Nulla ullamcorper, urna eget laoreet luctus, elit diam luctus magna, sed lacinia dolor nisi sit amet diam. Nam lectus leo, rhoncus nec risus vitae, euismod commodo lacus. Duis et purus cursus, sodales velit ac, auctor elit. Maecenas cursus efficitur urna non mattis. Donec vitae justo nec nisi pharetra sagittis a a nisi. Etiam lacinia erat nec posuere feugiat. Nulla gravida fermentum neque sit amet varius.
  #| Phasellus varius mauris a aliquet ultricies. Nam erat eros, hendrerit ac est at, scelerisque pellentesque risus. Proin malesuada nibh id vehicula tincidunt. Proin ac nulla id est facilisis semper. Proin egestas id augue sit amet pretium. Curabitur efficitur risus sit amet mauris blandit blandit. Nam tempor sollicitudin ligula, non venenatis eros interdum in. Curabitur luctus malesuada odio, sed sollicitudin erat ullamcorper vitae. Vestibulum et porttitor tellus.
  #| Aliquam ac laoreet neque. Sed mauris urna, venenatis vitae purus in, cursus aliquet nunc. Maecenas sit amet lacinia ante, nec placerat eros. Cras consectetur, risus tincidunt sollicitudin malesuada, leo purus lacinia risus, sit amet rhoncus dui tellus id tortor. Proin et nulla diam. Suspendisse dignissim at leo at ultricies. Mauris tellus enim, cursus ut vestibulum a, laoreet vel libero. Cras elementum hendrerit neque egestas gravida.
  #| Nam a mi at nisl tincidunt ultrices sit amet non tellus. Quisque elit dui, blandit id justo non, cursus cursus justo. Curabitur vel orci velit. Donec accumsan ante libero, id blandit arcu vehicula et. Maecenas nibh magna, laoreet eget posuere scelerisque, fermentum ut risus. Ut tincidunt lacinia nisl a convallis. Sed a euismod neque. In magna ante, posuere non orci in, cursus placerat lorem. Maecenas consequat condimentum neque, vel tempor nisi finibus non. Donec facilisis, nunc nec porttitor feugiat, odio lorem posuere est, id mollis nibh quam et eros. Mauris non arcu sit amet turpis semper auctor. Curabitur aliquam urna turpis, eget sagittis quam iaculis ultricies.

///|
let xs : Array[String] = {
  let buf = StringBuilder::new(size_hint=Lorem.length() * 2)
  let res = []
  let mut i = 0
  for x in Lorem {
    buf.write_char(x)
    if i > 80 {
      res.push(buf.to_string())
      buf.reset()
      i = 0
    }
    i += 1
  }
  res
}

///|
fn layout_sequence() -> Thunk[LayoutSequence] {
  let counter = cell(0)
  let t = thunk(fn() { "counter: \{counter.get()}" })
  let font = thunk(fn() { font })
  let color = thunk(fn() { white })
  let i_20 = const_thunk(20.0)
  let padding_color = const_thunk(Color::hsl(0, 0, 20))
  let button = Element::Render(mk_text(text=thunk(fn() { "+" }), font~, color~))
    .round_padding(thinkness=i_20, color=padding_color, radius=i_20)
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
  ).round_padding(thinkness=i_20, color=padding_color, radius=i_20)
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
