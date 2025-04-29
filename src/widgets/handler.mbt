///|
let default_handler : Handler = {
  id: 0,
  on_click: None,
  on_double_click: None,
  on_mouse_enter: None,
  on_mouse_leave: None,
  on_mouse_down: None,
  on_mouse_up: None,
  on_mouse_move: None,
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
  on_mouse_leave? : OnMouseLeave,
  on_mouse_move? : OnMouseMove,
  on_mouse_down? : OnMouseDown,
  on_mouse_up? : OnMouseUp
) -> Handler {
  handler_counter.update(fn { x => x + 1 })
  {
    on_click,
    on_double_click,
    on_mouse_enter,
    on_mouse_leave,
    on_mouse_move,
    on_mouse_up,
    on_mouse_down,
    id: handler_counter.val,
  }
}
