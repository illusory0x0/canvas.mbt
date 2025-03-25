///| Warning: when nest `Dependency[A]` in `struct`, `tuple`, `enum`, those `Aggregation type`
/// dependency relation won't derive.
/// ```moonbit
/// test {
///   let y = Dependency::new(fn () { 0 })
///   let a = Dependency::new(fn () { y.value })
///   let b = Dependency::new(fn () { a.value + 10 })
///
///   let x : Dependency[(Dependency[Int],Dependency[Int])] = Dependency::new(fn () { 
///      a.depend_on(b)
///     (a,b)
///   })
///
///   let old_value = x.value
///   x.depend_on(y)
///   y.modify(fn { x => x + 1})    // modify y will update x, but update x just call thunk to create new x
///                                // but (a,b) of the new x is the same as old one
///   let new_value = x.value 
///
///   assert_false!(physical_equal(old_value,new_value))
///   assert_true!(physical_equal(old_value.0,new_value.0))
///   assert_true!(physical_equal(old_value.1,new_value.1))
///   inspect!(x, content="(0, 10)")
/// }
/// ```
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

// ///| Warning: this method doesn't change thunk
// pub fn Dependency::set[A](self : Dependency[A], value : A) -> Unit {
//   self.value = value
//   self.dispatch()
// }

// ///| Warning: this method doesn't change thunk
// pub fn Dependency::modify[A](self : Dependency[A], f : (A) -> A) -> Unit {
//   self.set(f(self.value))
// }


pub fn Dependency::update[A](self : Dependency[A]) -> Unit {
  self.value = (self.thunk)()
  self.dispatch()
}


///|
fn Dependency::dispatch[A](self : Dependency[A]) -> Unit {
  for message in self.children {
    message()
  }
}

///|
/// 
///      self ⇐------------------ other
/// 
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
