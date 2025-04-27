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
fn color_to_qbrush(color : Color) -> @qpainter.QBrush {
  let qcolor = @qpainter.QColor::new(
    color.red().to_int(),
    color.green().to_int(),
    color.blue().to_int(),
    color.alpha().to_int(),
  )
  let qbrush = @qpainter.QBrush::new(qcolor)
  qbrush
}
