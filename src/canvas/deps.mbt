///|
pub struct Dependency[A] {
  mut value : A
  priv mut thunk : () -> A
}

///|
pub fn Dependency::new[A](thunk : () -> A) -> Dependency[A] {
  { value: thunk(), thunk }
}

///|
pub fn Dependency::update[A](self : Dependency[A], value : A) -> Unit {
  self.value = value
  (self.thunk)() |> ignore
}

///|
fn Dependency::modify[A](self : Dependency[A], f : (A) -> A) -> Unit {
  self.value = self.value |> f
  (self.thunk)() |> ignore
}

///|
fn Dependency::depend_on[A, B](
  self : Dependency[A],
  other : Dependency[B]
) -> Unit {
  let f = other.thunk
  other.thunk = fn() {
    let value = f()
    self.value = (self.thunk)()
    value
  }
}
