///|
pub struct Dependency[A] {
  mut value : A
  priv thunk : () -> A
  priv children : Array[() -> Unit]
  priv mut closure : () -> Unit
}

fn do_nothing() -> Unit { }


///|
pub fn Dependency::new[A](thunk : () -> A) -> Dependency[A] {
  let self = { value: thunk(), thunk , children: [], closure: do_nothing}

  self.closure = fn() {
    self.value = (self.thunk)()
    self.dispatch()
  }
  self 
}

///|
pub fn Dependency::update[A](self : Dependency[A], value : A) -> Unit {
  self.value = value
  self.dispatch()
}

///|
fn Dependency::modify[A](self : Dependency[A], f : (A) -> A) -> Unit {
  self.value = self.value |> f
  self.dispatch()
}


fn Dependency::dispatch[A](self : Dependency[A]) -> Unit {
  for message in self.children {
    message()
  }
}


///|
fn Dependency::depend_on[A, B](
  self : Dependency[A],
  other : Dependency[B]
) -> Unit {
  other.children.push(self.closure)
}
