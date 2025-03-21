///|
test (t : @test.T) {
  // expr = a^2 + b^2
  let a = State::new(0)
  let b = State::new(0)
  let a_pow_2 = a.cache(fn(x) {
    t.writeln("eval: a_pow_2")
    x * x
  })
  let b_pow_2 = b.cache(fn(x) {
    t.writeln("eval: b_pow_2")
    x * x
  })
  let expr = Cache::new(fn() { a_pow_2.cache + b_pow_2.cache })
  expr.depend_on(a_pow_2)
  expr.depend_on(b_pow_2)
  inspect!(expr.cache, content="0")
  a.set(3)
  inspect!(expr.cache, content="9")
  b.set(4)
  inspect!(expr.cache, content="25")
  t.snapshot!(filename="expr1.txt")
}

///|
test (t : @test.T) {
  fn deg_to_rad(deg : Double) -> Double {
    deg * @math.PI / 180
  }

  fn rad_to_deg(rad : Double) -> Double {
    rad * 180 / @math.PI
  }

  let a = State::new(deg_to_rad(45))
  let b = State::new(deg_to_rad(15))
  let tan_a = a.cache(@math.tan)
  let tan_b = b.cache(@math.tan)
  let tan_a_M_tan_b = Cache::new(fn() {
    t.writeln("eval: tan(a) * tan(b)")
    tan_a.cache * tan_b.cache
  })
  tan_a_M_tan_b.depend_on(tan_a)
  tan_a_M_tan_b.depend_on(tan_b)
  let tan_a_P_b = Cache::new(fn() {
    t.writeln("eval: tan(a + b)")
    (tan_a.cache + tan_b.cache) / (1.0 - tan_a_M_tan_b.cache)
  })
  let tan_a_S_b = Cache::new(fn() {
    t.writeln("eval: tan(a - b)")
    (tan_a.cache - tan_b.cache) / (1.0 + tan_a_M_tan_b.cache)
  })
  inspect!(
    tan_a_P_b.cache |> @math.atan |> rad_to_deg,
    content="59.99999999999999",
  )
  inspect!(
    tan_a_S_b.cache |> @math.atan |> rad_to_deg,
    content="29.999999999999996",
  )
  t.snapshot!(filename="expr2.txt")
}
