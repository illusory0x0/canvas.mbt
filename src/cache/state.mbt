///|
pub fn State::new[A](value : A) -> State[A] {
  { value, children: [] }
}

///|
pub fn State::set[A](self : State[A], value : A) -> Unit {
  self.value = value
  for refresh in self.children {
    refresh()
  }
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
  let source = self
  let target = Cache::new(fn() { f(source.value) })
  self.children.push(target.refresh)
  target
}
