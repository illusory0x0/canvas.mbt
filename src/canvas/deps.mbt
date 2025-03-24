///|
pub struct Dependency[A] {
  mut value : A
  priv thunk : () -> A
  priv children : Array[() -> Unit]
  priv mut closure : () -> Unit
}

///|
fn do_nothing() -> Unit {

}

///|
pub fn Dependency::new[A](thunk : () -> A) -> Dependency[A] {
  let self = { value: thunk(), thunk, children: [], closure: do_nothing }
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
pub fn Dependency::modify[A](self : Dependency[A], f : (A) -> A) -> Unit {
  self.value = self.value |> f
  self.dispatch()
}

///|
fn Dependency::dispatch[A](self : Dependency[A]) -> Unit {
  for message in self.children {
    message()
  }
}

///|
pub fn Dependency::depend_on[A, B](
  self : Dependency[A],
  other : Dependency[B]
) -> Unit {
  other.children.push(self.closure)
}

///|
pub impl[A : Show] Show for Dependency[A] with output(self, logger) {
  self.value.output(logger)
}

///|
pub impl[A : Eq] Eq for Dependency[A] with op_equal(self, other) {
  self.value == other.value
}

///|
pub impl[A : Compare] Compare for Dependency[A] with compare(self, other) {
  self.value.compare(other.value)
}

///|
pub impl[A : ToJson] ToJson for Dependency[A] with to_json(self) {
  self.value.to_json()
}

///|
pub impl[A : Hash] Hash for Dependency[A] with hash_combine(self, hasher) {
  self.value.hash_combine(hasher)
}

///|
traitalias @quickcheck.Arbitrary

///|
pub impl[A : Arbitrary] Arbitrary for Dependency[A] with arbitrary(seed, state) {
  let value = A::arbitrary(seed, state)
  Dependency::new(fn() { value })
}

///|
pub impl[A : Default] Default for Dependency[A] with default() {
  let value = A::default()
  Dependency::new(fn() { value })
}
