pub fn Thinkness::new(
  left : Int,
  top : Int,
  right : Int,
  bottom : Int,
) -> Thinkness {
  {
    left,
    top,
    right,
    bottom,
  }
}

pub fn Thinkness::same(x : Int) -> Thinkness {
  Thinkness::new(x, x, x, x)
}