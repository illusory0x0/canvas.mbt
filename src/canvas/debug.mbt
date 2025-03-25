///|
const DEBUG = true

///|
fn debug[A : Show](x : A) -> Unit {
  if DEBUG {
    println(x)
  }
}
