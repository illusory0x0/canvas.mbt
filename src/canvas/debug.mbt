let debug = true 


fn debug_print[A : Show](x : A) -> Unit {
  if (debug) {
    println(x)
  }
}