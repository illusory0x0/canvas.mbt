///|
let hover : Ref[(Rect, Handler)?] = Ref::new(None)

///|
let mouse_down : Ref[(Rect, Handler)?] = Ref::new(None)

///|
fn App::on_mouse_move(ls : LayoutSequence, x : Double, y : Double) -> Unit {
  let current : Vector = { x, y }
  let es = ls.rev_iter().filter_map(Element::to_handler)
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
}

///|
fn App::on_mouse_press(ls : LayoutSequence, x : Double, y : Double) -> Unit {
  let clicked : Vector = { x, y }
  let es = ls.rev_iter().filter_map(Element::to_handler)
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
}

///|
fn App::on_mouse_release(ls : LayoutSequence, x : Double, y : Double) -> Unit {
  let clicked = Vector::{ x, y }
  let es = ls.rev_iter().filter_map(Element::to_handler)
  match mouse_down.val {
    None => ()
    Some((rect, handler)) => {
      handler.on_mouse_up.map(fn(f) { f(clicked - rect.offset) }) |> ignore
      mouse_down.val = None
    }
  }
  let p : Vector = { x, y }
  let es = ls.rev_iter().filter_map(Element::to_handler)
  for x in es {
    let (rect, handler) = x
    if p.inside(rect) {
      handler.on_click.map(fn(f) { f() }) |> ignore
      break
    }
  }
}

///|
fn App::on_double_click(ls : LayoutSequence, x : Double, y : Double) -> Unit {
  let p : Vector = { x, y }
  let es = ls.rev_iter().filter_map(Element::to_handler)
  for x in es {
    let (rect, handler) = x
    if p.inside(rect) {
      handler.on_double_click.map(fn(f) { f() }) |> ignore
      break
    }
  }
}
