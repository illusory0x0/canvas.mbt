
///|
pub(open) trait RequiredBy {
  require_by(Self, () -> Unit) -> Unit
}

///|
pub impl[A] RequiredBy for Cache[A] with require_by(self, refresh) {
  self.children.push(refresh)
}

///|
pub impl[A] RequiredBy for State[A] with require_by(self, refresh) {
  self.children.push(refresh)
}


pub impl[A : Show ] Show for State[A] with output(self,logger) {
  self.value.output(logger)
}

pub impl[A : Show ] Show for Cache[A] with output(self,logger) {
  self.cache.output(logger)
}