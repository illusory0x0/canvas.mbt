///|
let window_property : WindowProperty = {
  size: cell(Size::new(1280, 720)),
  dpr: cell(1),
}

///|
fn WindowProperty::width(self : WindowProperty) -> Double {
  self.size.get().width
}

///|
fn WindowProperty::height(self : WindowProperty) -> Double {
  self.size.get().height
}

///|
fn WindowProperty::contains(self : WindowProperty, v : Vector) -> Bool {
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
type Action Thunk[Int]

///|
fn action(f : () -> Unit) -> Action {
  let mut i = 0
  thunk(fn() {
    f()
    i += 1
    i
  })
}

///|
fn Action::run(self : Action) -> Unit {
  self._.get() |> ignore
}
