///|
pub struct State[A] {
  mut value : A
  priv children : Array[() -> Unit]
}

///|
pub struct Cache[A] {
  mut cache : A
  priv init : () -> A
  priv children : Array[() -> Unit]
  mut refresh : () -> Unit
}

///|
pub(all) type Trigger () -> Unit
