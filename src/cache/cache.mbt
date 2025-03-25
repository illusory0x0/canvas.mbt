///|
pub struct Cache[A] {
  mut cache : A
  priv init : () -> A
  priv children : Array[() -> Unit]
  priv mut refresh : () -> Unit
}

///|
fn do_nothing() -> Unit {

}

///|
pub fn Cache::new[A](init : () -> A) -> Cache[A] {
  let self = { cache: init(), init, children: [], refresh: do_nothing }
  self.refresh = fn() { self.refresh() }
  self
}

///|
/// 
///      self <---- other
/// 
pub fn Cache::depend_on[A, B](self : Cache[A], other : Cache[B]) -> Unit {
  other.children.push(self.refresh)
}

///|
pub fn Cache::refresh[A](self : Cache[A]) -> Unit {
  self.cache = (self.init)()
  for refresh in self.children {
    refresh()
  }
}
