pub fn Vector::new(x : Int, y : Int) -> Vector {
  { x, y }
}

pub impl Add for Vector with op_add(self,other) {
  Vector::new(self.x + other.x,self.y + other.y)
}

pub fn Vector::inside_window(self :  Vector) -> Bool {
  self.x < window.innerWidth() && self.y < window.innerHeight()
}