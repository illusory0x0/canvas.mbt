pub fn Rect::new(offset : Vector, size : Size) -> Rect {
   { offset, size } 
}

pub fn Rect::left(self : Rect) -> Int {
   self.offset.x
}

pub fn Rect::right(self : Rect) -> Int {
   self.offset.x + self.size.width
}

pub fn Rect::top(self : Rect) -> Int {
   self.offset.y
}

pub fn Rect::bottom(self : Rect) -> Int {
   self.offset.y + self.size.height
}