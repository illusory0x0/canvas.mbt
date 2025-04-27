///|
let hover : Ref[(Rect, Handler)?] = Ref::new(None)

///|
let mouse_down : Ref[(Rect, Handler)?] = Ref::new(None)

///|
fn main {
  let argc : Ref[Int] = Ref::new(1)
  let argv : FixedArray[Bytes] = [b"painter\x00"]
  let app = @qpainter.QApplication::new(argc, argv)
  let counter = cell(0)
  let text = thunk(fn() { "counter: \{counter.get()}" })
  let font = thunk(fn() { font })
  let color = thunk(fn() { white })
  let i_20 = const_thunk(20.0)
  let padding_color = const_thunk(Color::hsl(0, 0, 20))
  let button = Element::Render(
      Text::new(text=thunk(fn() { "+" }), font~, color~),
    )
    .round_padding(thinkness=i_20, color=padding_color, radius=i_20)
    .add_handler(
      Handler::new(on_click=fn() { counter.modify(fn { x => x + 1 }) }, on_double_click=fn(

      ) {
        counter.modify(fn { x => x + 4 })
      }),
    )
  let label = Element::selected_text(
    text=thunk(fn() { [text.get()] }),
    font~,
    foregound=color,
    background=const_thunk(black),
  ).round_padding(thinkness=i_20, color=padding_color, radius=i_20)
  let target = Element::hstack(const_thunk([label, button]), spacing=20)

  // let target = Element::Render(Text::new(
  //   text=const_thunk("helll"),
  //   font~,
  //   color=const_thunk(yellow)
  // ))
  let layout_sequence = thunk(fn() {
    window.size.get() |> ignore
    target.to_layout_sequence(origin)
  })
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
    let current : Vector = { x, y }
    let es = layout_sequence.get().rev_iter().filter_map(Element::to_handler)
    match hover.val {
      None =>
        for x in es {
          let (rect, handler) = x
          if current.inside(rect) {
            handler.on_mouse_enter.map(fn(f) { f() }) |> ignore
            hover.val = Some(x)
            break
          }
        }
      Some((rect, handler)) =>
        if not(current.inside(rect)) {
          handler.on_mouse_leave.map(fn(f) { f() }) |> ignore
          hover.val = None
        }
    }
    match mouse_down.val {
      None => ()
      Some((rect, handler)) =>
        handler.on_mouse_move.map(fn(f) { f(current - rect.offset) }) |> ignore
    }
    w.update()
  }

  fn mouse_release(
    w : @qpainter.Window,
    x : Double,
    y : Double,
    m : @qpainter.KeyModifier,
    b : @qpainter.MouseButton
  ) -> Unit {
    let clicked = Vector::{ x, y }
    let es = layout_sequence.get().rev_iter().filter_map(Element::to_handler)
    match mouse_down.val {
      None => ()
      Some((rect, handler)) => {
        handler.on_mouse_up.map(fn(f) { f(clicked - rect.offset) }) |> ignore
        mouse_down.val = None
      }
    }
    let p : Vector = { x, y }
    let es = layout_sequence.get().rev_iter().filter_map(Element::to_handler)
    for x in es {
      let (rect, handler) = x
      if p.inside(rect) {
        handler.on_click.map(fn(f) { f() }) |> ignore
        break
      }
    }
    w.update()
  }

  fn mouse_press(
    w : @qpainter.Window,
    x : Double,
    y : Double,
    m : @qpainter.KeyModifier,
    b : @qpainter.MouseButton
  ) -> Unit {
    let clicked : Vector = { x, y }
    let es = layout_sequence.get().rev_iter().filter_map(Element::to_handler)
    match mouse_down.val {
      None =>
        for x in es {
          let (rect, handler) = x
          if clicked.inside(rect) {
            handler.on_mouse_down.map(fn(f) { f(clicked - rect.offset) })
            |> ignore
            mouse_down.val = Some(x)
            break
          }
        }
      Some(_) => ()
    }
    w.update()
  }

  fn mouse_double_click(
    w : @qpainter.Window,
    x : Double,
    y : Double,
    m : @qpainter.KeyModifier,
    b : @qpainter.MouseButton
  ) -> Unit {
    let p : Vector = { x, y }
    let es = layout_sequence.get().rev_iter().filter_map(Element::to_handler)
    for x in es {
      let (rect, handler) = x
      if p.inside(rect) {
        handler.on_double_click.map(fn(f) { f() }) |> ignore
        break
      }
    }
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
  window.sync_from_native(w)
  println(window.size.get())
  w.show()
  let exit_code = @qpainter.QApplication::exec()
  @qpainter.drop([w, app, exit_code])
}
