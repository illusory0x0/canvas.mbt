///|
fn Element::hover(
  self : Element,
  leave~ : Color,
  enter~ : Color,
  padding~ : (Element, Thunk[Color]) -> Element
) -> Element {
  let is_hoved = cell(false)
  let color = thunk(fn() { if is_hoved.get() { enter } else { leave } })
  fn on_mouse_enter() {
    is_hoved.set(true)
  }

  fn on_mouse_leave() {
    is_hoved.set(false)
  }

  let handler = Handler::new(on_mouse_enter~, on_mouse_leave~)
  padding(self, color).add_handler(handler)
}

///|
test {
  let xs = [2, 4, 6]
  let s = xs.search_by(fn(end) { end > 1 })
  let e = xs.search_by(fn(end) { end > 5 })
  println((s, e))
  println("abc".view(start_offset=0, end_offset=2))
}

///|
fn Element::selected_text(
  text~ : Thunk[String],
  font~ : Thunk[Font],
  foregound~ : Thunk[Color],
  background~ : Thunk[Color]
) -> Element {
  let text_end = thunk(fn() {
    let res = []
    let mut e = 0.0
    for ch in text.get() {
      e += font.get().width(ch.to_string())
      res.push(e)
    }
    res
  })
  let selected = cell("")
  let prev_index = cell(None)
  fn on_mouse_down(v : Vector) {
    let index = text_end.get().search_by(fn(end) { end > v.x })
    prev_index.set(index)
  }

  let offset = cell(Vector::default())
  fn on_mouse_up(v : Vector) {
    on_mouse_move(v)
  }

  fn on_mouse_move(v : Vector) {
    let current_index = text_end
      .get()
      .search_by(fn(end) { end > v.x })
      .or(text.get().char_length() - 1)
    match prev_index.get() {
      Some(prev) => {
        let (start_offset, end_offset) = if prev < current_index {
          (prev, current_index + 1)
        } else {
          (current_index, prev + 1)
        }
        let x = if start_offset == 0 {
          0.0
        } else {
          text_end.get()[start_offset - 1]
        }
        offset.modify(fn { { y, .. } => Vector::new(x, y) })
        selected.set(text.get().view(start_offset~, end_offset~).to_string())
      }
      None => ()
    }
  }

  let handler = Handler::new(on_mouse_down~, on_mouse_up~, on_mouse_move~)
  Element::layer_([
    (
      thunk(fn() { Vector::default() }),
      Element::Render(Text::new(text~, color=foregound, font~)),
    ),
    (
      thunk(fn() { offset.get() }),
      Element::Render(
        Text::new(text=cell_to_thunk(selected), color=background, font~),
      ).round_padding(
        thinkness=const_thunk(0),
        color=foregound,
        radius=const_thunk(0),
      ),
    ),
  ]).add_handler(handler)
}

///|
pub fn Element::layer_(xs : Array[(Thunk[Vector], Element)]) -> Element {
  let layout = thunk(fn() {
    let window = window.size.get()
    let mut w = 0.0
    let mut h = 0.0
    for x in xs {
      let (offset, view) = x
      let offset = offset.get()
      guard offset.x < window.width && offset.y < window.height else { break } // doesn't layout beyond window
      let sz = view.size()
      w = @math.maximum(w, offset.x + sz.width)
      h = @math.maximum(h, offset.y + sz.height)
    }
    let size = Size::new(w, h)
    (size, xs.map(fn { (vec, ele) => (vec.get(), ele) }))
  })
  Layout(layout)
}
