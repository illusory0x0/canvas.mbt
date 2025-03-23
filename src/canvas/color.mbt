///|
type Color @color.Color derive(Default, Eq, Compare, Hash)

///|
pub impl Show for Color with output(self, logger) {
  logger.write_char('#')
  self._.output(logger)
}

///|
pub fn hsl(h : UInt, s : UInt, l : UInt) -> Color {
  @color.Color::hsl(h, s, l)
}

///|
test {
  inspect!(hsl(0, 100, 50), content="#FF0000FF")
  inspect!(hsl(157, 32, 67), content="#90C6B1FF")
}
