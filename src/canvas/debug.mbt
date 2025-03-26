///|
const DEBUG = true

///|
let ignore_message_list = ["Text", "App"]

///|
fn debug[A : Show](x : A) -> Unit {
  if DEBUG {
    let str = x.to_string()
    let x = ignore_message_list.iter().all(fn { s => not(str.starts_with(s)) })
    if x {
      println(str)
    }
  }
}
