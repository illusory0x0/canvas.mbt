///|
const DEBUG = true

///|
fn debug[A : Show](x : A) -> Unit {
  if DEBUG {
    let str = x.to_string()
    match str {
      [.."Text",..] => ()
      _ => println(str)
    }
  }
}
