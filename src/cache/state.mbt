///|
pub struct State[A] {
  mut value : A
  priv mut refresh : () -> Unit
}

///|
pub fn State::new[A](value : A) -> State[A] {
  { value, refresh: do_nothing }
}

///|
pub fn State::set[A](self : State[A], value : A) -> Unit {
  self.value = value
  (self.refresh)()
}

///|
pub fn State::get[A](self : State[A]) -> A {
  self.value
}

///|
pub fn State::modify[A](self : State[A], f : (A) -> A) -> Unit {
  self.set(f(self.value))
}

///|
pub fn State::cache[A, B](self : State[A], f : (A) -> B) -> Cache[B] {
  let cache = Cache::new(fn() { f(self.value) })
  self.refresh = cache.refresh
  cache
}
