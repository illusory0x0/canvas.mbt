///|
pub impl Add for Vector with op_add(self, other) {
  { x: self.x + other.x, y: self.y + other.y }
}

///|
pub fn Vector::inside_window(self : Vector) -> Bool {
  self.x < window.innerWidth() && self.y < window.innerHeight()
}

///|
pub fn Vector::new(x : Int, y : Int) -> Vector {
  { x, y }
}
