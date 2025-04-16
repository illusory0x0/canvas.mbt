///|
pub fn Rect::new(offset : Vector, size : Size) -> Rect {
  { offset, size }
}

///|
pub fn Rect::left(self : Rect) -> Double {
  self.offset.x
}

///|
pub fn Rect::right(self : Rect) -> Double {
  self.offset.x + self.size.width
}

///|
pub fn Rect::top(self : Rect) -> Double {
  self.offset.y
}

///|
pub fn Rect::bottom(self : Rect) -> Double {
  self.offset.y + self.size.height
}
