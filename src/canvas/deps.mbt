pub struct Dependency[A] {
  mut value : A 
  priv mut f : () -> A
}


pub fn Dependency::new[A](thunk : () -> A) -> Dependency[A] {
  {
    value : thunk(), 
    f : thunk
  }
}

pub fn Dependency::update[A](self : Dependency[A],value : A) -> Unit {
  self.value = value 
  (self.f)() |> ignore
}

fn Dependency::modify[A](self : Dependency[A], f : (A) -> A) -> Unit {
  self.value = self.value |> f
  (self.f)() |> ignore
}

fn Dependency::depend_on[A,B](self : Dependency[A],other: Dependency[B]) -> Unit {
  let f = other.f 
  other.f = fn () {
    let value = f() 
    self.value = (self.f)() 
    value
  }
}