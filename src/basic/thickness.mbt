///|
pub fn Thinkness::new(
  left : Double,
  top : Double,
  right : Double,
  bottom : Double
) -> Thinkness {
  { left, top, right, bottom }
}

///|
pub fn Thinkness::same(x : Double) -> Thinkness {
  Thinkness::new(x, x, x, x)
}
