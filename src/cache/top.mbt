///|
struct Node[A] {
  mut _value : A
  mut _state : State
  mut _id : Int
  _init : () -> A
  _incomings : Array[&VNode]
} derive(Show)

///|
priv enum State {
  Dirty
  Clean
} derive(Eq, Compare, Show, Hash)

///|
trait VNode {
  update(Self) -> Unit
  set_state(Self, State) -> Unit
  state(Self) -> State
  incomings(Self) -> Array[&VNode]
  id(Self) -> Int
  output_vnode(Self, &Logger) -> Unit
}

///|
pub impl Show for &VNode with output(self, logger) {
  self.output_vnode(logger)
}

///|
pub impl[A : Show] VNode for Node[A] with output_vnode(self, logger) {
  self.output(logger)
}

///|
pub impl[A : Show] VNode for Node[A] with update(self) {
  self._value = (self._init)()
  self._state = Clean
}

///|
pub impl[A : Show] VNode for Node[A] with set_state(self, state) {
  self._state = state
}

///|
pub impl[A : Show] VNode for Node[A] with state(self) {
  self._state
}

///|
pub impl[A : Show] VNode for Node[A] with incomings(self) {
  self._incomings
}

///|
pub impl[A : Show] VNode for Node[A] with id(self) {
  self._id
}

///|
pub impl[A] Eq for Node[A] with op_equal(self, other) {
  self._id == other._id
}

///|
pub impl Eq for &VNode with op_equal(self, other) {
  self.id() == other.id()
}

///|
pub impl[A] Compare for Node[A] with compare(self, other) {
  self._id.compare(other._id)
}

///|
pub impl Compare for &VNode with compare(self, other) {
  self.id().compare(other.id())
}

///|
let id_counter : Ref[Int] = Ref::new(0)

///|
pub fn Node::from_fun[A](init : () -> A) -> Node[A] {
  id_counter.update(fn { x => x + 1 })
  {
    _value: init(),
    _init: init,
    _id: id_counter.val,
    _incomings: [],
    _state: Clean,
  }
}

///|
pub fn Node::from_val[A](value : A) -> Node[A] {
  Node::from_fun(fn() { value })
}

///|
pub fn Node::depend_on[A : Show](self : Node[A], other : &VNode) -> Unit {
  other.incomings().push(self)
}

///|
pub fn Node::map[A : Show, B : Show](self : Node[A], f : (A) -> B) -> Node[B] {
  let res = Node::from_fun(fn() { f(self.get()) })
  res.depend_on(self)
  res
}

///|
pub fn &VNode::dirty(self : &VNode) -> Unit {
  match self.state() {
    Dirty => ()
    Clean => {
      self.set_state(Dirty)
      for out_edge in self.incomings() {
        &VNode::dirty(out_edge)
      }
    }
  }
}

///|
pub fn Node::sync[A : Show](self : Node[A]) -> Unit {
  match self._state {
    Dirty => self.update()
    Clean => ()
  }
}

///|
pub fn Node::get[A : Show](self : Node[A]) -> A {
  self.sync()
  self._value
}

///|
pub fn Node::set[A : Show + Eq](self : Node[A], value : A) -> Unit {
  match self.state() {
    Dirty => self._value = value
    Clean if self._value != value => {
      self._value = value
      for out_edge in self.incomings() {
        &VNode::dirty(out_edge)
      }
    }
    _ => ()
  }
}

///|
pub fn Node::modify[A : Show + Eq](self : Node[A], f : (A) -> A) -> Unit {
  self.set(f(self.get()))
}

///|
pub fn map_log[A : Show, B : Show](
  self : Node[A],
  t : @test.T,
  f : (A) -> B
) -> Node[B] {
  self.map(fn(x) {
    let v = f(x)
    t.writeln(v)
    v
  })
}

///|
test (t : @test.T) {
  let a = Node::from_val(1)
  t.writeln("EVAL BEGIN")
  let b0 = a.map_log(t, fn { x => x * 2 })
  let b1 = a.map_log(t, fn { x => x * 3 })
  let c = Node::from_fun(fn() {
    let v = b0.get() + b1.get()
    t.writeln(v)
    v
  })
  t.writeln("EVAL END\n")
  c.depend_on(b0)
  c.depend_on(b1)
  inspect!(c.get(), content="5")
  a.modify(fn { x => x + 5 })
  inspect!(a.get(), content="6")
  inspect!(c.state(), content="Dirty")
  t.writeln("EVAL BEGIN")
  inspect!(c.get(), content="30")
  t.writeln("EVAL END\n")
  inspect!(c.state(), content="Clean")
  t.writeln("EVAL BEGIN")
  inspect!(c.get(), content="30")
  t.writeln("EVAL END\n")
  t.snapshot!(filename="test1.txt")
}

///|
test (t : @test.T) {
  let s = Node::from_val(1)
  let len = 1 << 2
  t.writeln("EVAL BEGIN")
  let arr = Array::makei(len, fn(i) { s.map_log(t, fn { x => x + i }) })
  let sum = Node::from_fun(fn() {
    let v = arr.fold(init=0, fn(acc, x) { acc + x.get() })
    t.writeln(v)
    v
  })
  inspect!(sum.get(), content="10")
  t.writeln("EVAL END\n")
  for x in arr {
    sum.depend_on(x)
  }
  s.modify(fn { x => x + 1 })
  t.writeln("EVAL BEGIN")
  inspect!(sum.get(), content="14")
  t.writeln("EVAL END\n")
  t.snapshot!(filename="stress_test.txt")
}

///|
test "stress test" {
  let s = Node::from_val(1)
  let len = 1 << 20
  let arr = Array::makei(len, fn(i) { s.map(fn { x => x + i }) })
  let sum = Node::from_fun(fn() {
    arr.fold(init=0, fn(acc, x) { acc + x.get() })
  })
  inspect!(sum.get(), content="524288")
  for x in arr {
    sum.depend_on(x)
  }
  s.modify(fn { x => x + 1 })
  inspect!(sum.get(), content="1572864")
}

///|
test {
  let x = Node::from_val(0)
  let buf = StringBuilder::new()
  let f = Node::from_fun(fn() {
    x.get() |> ignore
    buf.write_char('0')
  })
  f.depend_on(x)
  for i in 0..<10 {
    x.set(i)
    f.get()
  }
  inspect!(buf, content="0000000000")
}
