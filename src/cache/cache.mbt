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
pub fn Cache::val[A](value : A) -> Cache[A] {
  { cache: value, init: fn() { value }, children: [], refresh: do_nothing }
}

///|
pub fn Cache::depend_on[A, B : RequiredBy](self : Cache[A], other : B) -> Unit {
  other.require_by(self.refresh)
}

///|
pub fn Cache::refresh[A](self : Cache[A]) -> Unit {
  self.cache = (self.init)()
  for refresh in self.children {
    refresh()
  }
}

///|
pub fn Cache::cache[A, B](self : Cache[A], f : (A) -> B) -> Cache[B] {
  let source = self
  let target = Cache::new(fn() { f(source.cache) })
  target.depend_on(source)
  target
}
