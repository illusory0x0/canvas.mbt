///|
type App

///|
fn App::run(ls : Thunk[LayoutSequence]) -> Unit {
  let argc : Ref[Int] = Ref::new(1)
  let argv : FixedArray[Bytes] = [b"painter\x00"]
  let app = @qt.QApplication::new(argc, argv)
  let rs = thunk(fn() { ls.get().filter_map(Element::to_render) })
  let w = @qt.Window::new(
    paint=fn(w, p) { Renderable_::render_iter(p, rs.get().iter()) },
    key_press=fn(w, k, m) {  },
    key_release=fn(w, k, m) {  },
    mouse_double_click=fn(w, x, y, k, b) {
      App::on_double_click(ls, x, y)
      w.update()
    },
    mouse_release=fn(w, x, y, k, b) {
      App::on_mouse_release(ls, x, y)
      w.update()
    },
    mouse_press=fn(w, x, y, k, b) {
      App::on_mouse_press(ls, x, y)
      w.update()
    },
    mouse_move=fn(w, x, y, m, b) {
      App::on_mouse_move(ls, x, y)
      w.update()
    },
    resize=fn(win, w, h) {
      window.sync_from_device(win)
      win.update()
    },
  )
  window.sync_from_device(w)
  w.show()
  let exit_code = @qt.QApplication::exec()
  @qt.drop([w, app, exit_code])
}
