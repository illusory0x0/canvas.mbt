///|
let default_handler : Handler = {
  id: 0,
  on_click: None,
  on_double_click: None,
  on_mouse_enter: None,
  on_mouse_leave: None,
}

///|
pub impl Show for Handler with output(self, logger) {
  logger.write_string("handler_id: ")
  self.id.output(logger)
}

///|
let handler_counter : Ref[Int] = Ref::new(0)

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
