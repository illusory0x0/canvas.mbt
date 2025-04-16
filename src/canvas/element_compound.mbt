///|
fn Element::hover(
  self : Element,
  leave~ : Color,
  enter~ : Color,
  padding~ : (Element, Node[Color]) -> Element
) -> Element {
  let is_hoved = Node::from_val(false)
  let color = is_hoved.map(fn { b => if b { enter } else { leave } })
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
  text~ : Node[String],
  font~ : Node[Font],
  foregound~ : Node[Color],
  background~ : Node[Color]
) -> Element {
  let text_end = Node::from_fun(fn() {
    let res = []
    let mut e = 0.0
    for ch in text.get() {
      e += font.get().width(ch.to_string())
      res.push(e)
    }
    res
  })
  text_end.add_dependents([text, font])
  let selected = Node::from_val("")
  let prev_index = Node::from_val(None)
  fn on_mouse_down(v : Vector) {
    let index = text_end.get().search_by(fn(end) { end > v.x })
    prev_index.set(index)
  }

  let offset = Node::from_val(Vector::default())
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
      Node::from_val(Vector::default()),
      Element::Render(Text::new(text~, color=foregound, font~)),
    ),
    (
      offset,
      Element::Render(Text::new(text=selected, color=background, font~)).round_padding(
        thinkness=Node::from_val(0),
        color=foregound,
        radius=Node::from_val(0),
      ),
    ),
  ]).add_handler(handler)
}

///|
pub fn Element::layer_(xs : Array[(Node[Vector], Element)]) -> Element {
  let layout = Node::from_fun(fn() {
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
  for x in xs {
    layout.depend_on(x.1.layout_node())
  }
  Layout(layout)
}
