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
pub(open) trait DepsKind {
  render_node(Self) -> Node
  layout_node(Self) -> Node
}

///|
pub impl Show for &Renderable with output(self, logger) {

}

///|
pub fn Rectangle::new(color~ : Thunk[Color], size~ : Thunk[Size]) -> Rectangle {
  let rnode = action(fn() {
      color.get() |> ignore
      size.get() |> ignore
    })._
  { color, size, rnode }
}

///|
pub impl Renderable for Rectangle with size(self) {
  self.size.get()
}

///|
pub impl DepsKind for Rectangle with render_node(self) {
  self.rnode
}

///|
pub impl DepsKind for Rectangle with layout_node(self) {
  self.size
}

///|
pub fn &Renderable::render_iter(
  painter : Painter,
  xs : Iter[(Vector, &Renderable)]
) -> Unit {
  for x in xs {
    let (offset, renderable) = x
    guard offset.x >= 0 && offset.y >= 0
    if window.contains(offset) {
      renderable.render(offset, painter._)
    }
  }
}

///|
pub fn RoundedRectangle::new(
  color~ : Thunk[Color],
  size~ : Thunk[Size],
  radius~ : Thunk[Double]
) -> RoundedRectangle {
  let rnode = action(fn() {
      color.get() |> ignore
      size.get() |> ignore
      radius.get() |> ignore
    })._
  { color, size, radius, rnode }
}

///|
pub impl Renderable for RoundedRectangle with size(self) {
  self.size.get()
}

///|
pub impl DepsKind for RoundedRectangle with render_node(self) {
  self.rnode
}

///|
pub impl DepsKind for RoundedRectangle with layout_node(self) {
  self.size
}

///|
pub fn RoundedBorder::new(
  color~ : Thunk[Color],
  size~ : Thunk[Size],
  radius~ : Thunk[Double],
  thickness~ : Thunk[Double]
) -> RoundedBorder {
  let rnode = action(fn() {
      color.get() |> ignore
      size.get() |> ignore
      radius.get() |> ignore
    })._
  { color, size, radius, thickness, rnode }
}

///|
pub impl Renderable for RoundedBorder with size(self) {
  self.size.get()
}

///|
pub impl DepsKind for RoundedBorder with render_node(self) {
  self.rnode
}

///|
pub impl DepsKind for RoundedBorder with layout_node(self) {
  self.size
}

///|
pub fn Text::new(
  text~ : Thunk[String],
  font~ : Thunk[Font],
  color~ : Thunk[Color]
) -> Text {
  let size = thunk(fn() {
    let font = font.get()
    let text = text.get()
    debug("Text::measure font size")
    Size::new(font.width(text), font.height(text))
  })
  let rnode = action(fn() {
      size.get() |> ignore
      font.get() |> ignore
      color.get() |> ignore
    })._
  { text, font, color, size, rnode }
}

///|
pub impl Renderable for Text with size(self) {
  self.size.get()
}

///|
pub impl DepsKind for Text with render_node(self) {
  self.rnode
}

///|
pub impl DepsKind for Text with layout_node(self) {
  self.size
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

fn layout_sequence() -> Thunk[LayoutSequence]  {
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