///|
fn main {
  let argc : Ref[Int] = Ref::new(1)
  let argv : FixedArray[Bytes] = [b"painter\x00"]
  let app = @qpainter.QApplication::new(argc, argv)
  let layout_sequence = layout_sequence()
  let render_sequence = thunk(fn() {
    layout_sequence.get().filter_map(Element::to_render)
  })
  fn mouse_move(
    w : @qpainter.Window,
    x : Double,
    y : Double,
    m : @qpainter.KeyModifier,
    b : @qpainter.MouseButton
  ) -> Unit {
    global_handle_mouse_move(layout_sequence, x, y)
    w.update()
  }

  fn mouse_release(
    w : @qpainter.Window,
    x : Double,
    y : Double,
    m : @qpainter.KeyModifier,
    b : @qpainter.MouseButton
  ) -> Unit {
    global_handle_mouse_release(layout_sequence, x, y)
    w.update()
  }

  fn mouse_press(
    w : @qpainter.Window,
    x : Double,
    y : Double,
    m : @qpainter.KeyModifier,
    b : @qpainter.MouseButton
  ) -> Unit {
    global_handle_mouse_press(layout_sequence, x, y)
    w.update()
  }

  fn mouse_double_click(
    w : @qpainter.Window,
    x : Double,
    y : Double,
    m : @qpainter.KeyModifier,
    b : @qpainter.MouseButton
  ) -> Unit {
    global_handle_double_click(layout_sequence, x, y)
    w.update()
  }

  fn paint(w : @qpainter.Window, painter : @qpainter.QPainter) -> Unit {
    &Renderable::render_iter(painter, render_sequence.get().iter())
  }

  fn key_press(
    w : @qpainter.Window,
    key : Int,
    modifier : @qpainter.KeyModifier
  ) -> Unit {

  }

  fn key_release(
    w : @qpainter.Window,
    key : Int,
    modifier : @qpainter.KeyModifier
  ) -> Unit {

  }

  let w = @qpainter.Window::new(
    paint~,
    key_press~,
    key_release~,
    mouse_double_click~,
    mouse_release~,
    mouse_press~,
    mouse_move~,
  )
  window.sync_from_device(w)
  println(window.size.get())
  w.show()
  let exit_code = @qpainter.QApplication::exec()
  @qpainter.drop([w, app, exit_code])
}
