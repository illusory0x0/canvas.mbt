pub impl Show for Handler with output(self, logger) {
  self.id.output(logger)
}

pub impl Eq for Handler with op_equal(self, other) {
  self.id == other.id 
}

pub impl Compare for Handler with compare(self,other) {
  self.id.compare(other.id)
}

pub impl Hash for Handler with hash_combine(self, state) {
  self.id.hash_combine(state)
}