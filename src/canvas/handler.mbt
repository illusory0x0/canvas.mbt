///|
pub impl Show for Handler with output(self, logger) {
  logger.write_string("handler_id: ")
  self.id.output(logger)
}

///|
pub impl Eq for Handler with op_equal(self, other) {
  self.id == other.id
}

///|
pub impl Compare for Handler with compare(self, other) {
  self.id.compare(other.id)
}

///|
pub impl Hash for Handler with hash_combine(self, state) {
  self.id.hash_combine(state)
}

///|
pub fn Handler::new(
  on_click? : OnClick,
  on_double_click? : OnClick,
  on_mouse_enter? : OnMouseEnter,
  on_mouse_leave? : OnMouseLeave
) -> Handler {
  handler_counter.update(fn { x => x + 1 })
  {
    on_click,
    on_double_click,
    on_mouse_enter,
    on_mouse_leave,
    id: handler_counter.val,
  }
}
