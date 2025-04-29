///|
fn main {
  let argc : Ref[Int] = Ref::new(1)
  let argv : FixedArray[Bytes] = [b"painter\x00"]
  let app = @qt.QApplication::new(argc, argv)
  let layout_sequence = layout_sequence()
  let render_sequence = thunk(fn() {
    layout_sequence.get().filter_map(Element::to_render)
  })
  fn mouse_move(
    w : @qt.Window,
    x : Double,
    y : Double,
    m : @qt.KeyModifier,
    b : @qt.MouseButton
  ) -> Unit {
    global_handle_mouse_move(layout_sequence, x, y)
    w.update()
  }

  fn mouse_release(
    w : @qt.Window,
    x : Double,
    y : Double,
    m : @qt.KeyModifier,
    b : @qt.MouseButton
  ) -> Unit {
    global_handle_mouse_release(layout_sequence, x, y)
    w.update()
  }

  fn mouse_press(
    w : @qt.Window,
    x : Double,
    y : Double,
    m : @qt.KeyModifier,
    b : @qt.MouseButton
  ) -> Unit {
    global_handle_mouse_press(layout_sequence, x, y)
    w.update()
  }

  fn mouse_double_click(
    w : @qt.Window,
    x : Double,
    y : Double,
    m : @qt.KeyModifier,
    b : @qt.MouseButton
  ) -> Unit {
    global_handle_double_click(layout_sequence, x, y)
    w.update()
  }

  fn paint(w : @qt.Window, painter : @qt.QPainter) -> Unit {
    &Renderable::render_iter(painter, render_sequence.get().iter())
  }

  fn key_press(w : @qt.Window, key : Int, modifier : @qt.KeyModifier) -> Unit {

  }

  fn key_release(
    w : @qt.Window,
    key : Int,
    modifier : @qt.KeyModifier
  ) -> Unit {

  }

  fn resize(w : @qt.Window, width : Int, height : Int) -> Unit {
    window.sync_from_device(w)
    w.update()
  }

  let w = @qt.Window::new(
    paint~,
    key_press~,
    key_release~,
    mouse_double_click~,
    mouse_release~,
    mouse_press~,
    mouse_move~,
    resize~,
  )
  window.sync_from_device(w)
  println(window.size.get())
  w.show()
  let exit_code = @qt.QApplication::exec()
  @qt.drop([w, app, exit_code])
}
