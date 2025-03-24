struct Source[A] {
  mut value : A 
  mut f : () -> Unit
}

let do_nothing : () -> Unit = fn () { }

struct Target[A,B] {
  mut value : B 
  mut f : (A) -> B
}


fn Source::new[A](value : A) -> Source[A] {
  { value , f : do_nothing }
}

fn Target::new[A,B](z : A, f : (A) -> B) -> Target[A,B] {
  { value : f(z), f}
}
pub impl[A : Show] Show for Source[A] with output(self , logger) {
  self.value.output(logger)
}


pub impl[A,B : Show] Show for Target[A,B] with output(self , logger) {
  self.value.output(logger)
}

fn Source::link[A, B](self : Source[A], target : Target[A, B]) -> Unit {
  let f = self.f
  self.f = fn() {
    f()
    target.update(self.value)
  }
}
///|
fn Target::link[A, B, C](self : Target[A, B], other : Target[B, C]) -> Unit {
  let f = self.f
  self.f = fn(a) {
    let b = f(a)
    other.update(b)
    b
  }
}


///|
fn Target::update[A, B](self : Target[A, B], value : A) -> Unit {
  self.value = (self.f)(value)
}

///|
fn Source::modify[A](self : Source[A], f : (A) -> A) -> Unit {
  self.value = self.value |> f
  (self.f)()
}


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
