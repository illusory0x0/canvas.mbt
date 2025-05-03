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
fn text_render_end(text : String, font : Font) -> Array[Double] {
  let res = []
  let mut e = 0.0
  for ch in text {
    e += font.width(ch.to_string())
    res.push(e)
  }
  res
}

///| inclusive cursor
priv struct TextCursor {
  row : Int
  col : Int
} derive(Eq, Show, Compare)

///| inclusive selection
priv struct TextSelection {
  start : TextCursor
  end : TextCursor
} derive(Eq, Show, Compare)

///|
fn array_view_to_array[T](xs : ArrayView[T]) -> Array[T] {
  match xs {
    [] => []
    [x, ..] => {
      let res = Array::make(xs.length(), x)
      for i in 1..<xs.length() {
        res[i] = xs[i]
      }
      res
    }
  }
}

///|
typealias UnSelected = String

///|
typealias Selected = String

///|
priv enum MixedSelectText {
  OneLine(prefix~ : UnSelected, middle~ : Selected, suffix~ : UnSelected)
  MultiLine(
    first_prefix~ : UnSelected,
    first_suffix~ : Selected,
    middle~ : Array[UnSelected],
    last_prefix~ : Selected,
    last_suffix~ : UnSelected
  )
} derive(Show)

///|
fn split(
  xs : Array[String],
  sel : TextSelection
) -> (Array[String], MixedSelectText, Array[String]) {
  let { start, end } = sel
  guard start.row <= end.row
  let top = xs[0:start.row] |> array_view_to_array
  let bot = xs[end.row + 1:] |> array_view_to_array
  let mid = if start.row == end.row {
    guard start.col <= end.col
    let prefix = xs[start.row].view(end_offset=start.col).to_string()
    let suffix = xs[start.row].view(start_offset=end.col + 1).to_string()
    let selected = xs[start.row]
      .view(start_offset=start.col, end_offset=end.col + 1)
      .to_string()
    MixedSelectText::OneLine(prefix~, middle=selected, suffix~)
  } else {
    let first_prefix = xs[start.row].view(end_offset=start.col).to_string()
    let first_suffix = xs[start.row].view(start_offset=start.col).to_string()
    let last_prefix = xs[end.row].view(end_offset=end.col + 1).to_string()
    let last_sufix = xs[end.row].view(start_offset=end.col + 1).to_string()
    let middle = if end.row - start.row + 1 > 2 {
      xs[start.row + 1:end.row] |> array_view_to_array
    } else {
      []
    }
    MixedSelectText::MultiLine(
      first_prefix~,
      first_suffix~,
      middle~,
      last_prefix~,
      last_suffix=last_sufix,
    )
  }
  (top, mid, bot)
}

///|
test {
  let xs = ["123", "456", "789"]
  inspect!(
    split(xs, TextSelection::{
      start: { row: 1, col: 1 },
      end: { row: 1, col: 1 },
    }),
    content=
      #|(["123"], OneLine(prefix="4", middle="5", suffix="6"), ["789"])
    ,
  )
  inspect!(
    split(xs, TextSelection::{
      start: { row: 1, col: 1 },
      end: { row: 2, col: 2 },
    }),
    content=
      #|(["123"], MultiLine(first_prefix="4", first_suffix="56", middle=[], last_prefix="789", last_suffix=""), [])
    ,
  )
  inspect!(
    split(xs, TextSelection::{
      start: { row: 0, col: 0 },
      end: { row: 2, col: 2 },
    }),
    content=
      #|([], MultiLine(first_prefix="", first_suffix="123", middle=["456"], last_prefix="789", last_suffix=""), [])
    ,
  )
  inspect!(
    split(xs, TextSelection::{
      start: { row: 0, col: 1 },
      end: { row: 2, col: 0 },
    }),
    content=
      #|([], MultiLine(first_prefix="1", first_suffix="23", middle=["456"], last_prefix="7", last_suffix="89"), [])
    ,
  )
}

///|
fn selected_text(
  content~ : Thunk[Array[String]],
  font~ : Thunk[Font],
  foregound~ : Thunk[Color],
  background~ : Thunk[Color],
  on_selected_changed~ : (String) -> Unit = fn(_) {  }
) -> Element {
  let sel : Cell[TextSelection?] = cell(None)
  let text_end = thunk(fn() {
    content.get().map(fn { x => text_render_end(x, font.get()) })
  })
  fn unselected(t) {
    text(content=const_thunk(t), color=foregound, font~)
  }

  fn selected(t) {
    text(content=thunk(fn() { t }), color=background, font~).padding(
      thinkness=const_thunk(0),
      color=foregound,
    )
  }

  let height = thunk(fn() { font.get().height(" ") })
  let clicked : Cell[TextCursor] = cell({ row: 0, col: 0 })
  fn on_mouse_down(v : Vector) {
    let text_end = text_end.get()
    let row = (v.y / height.get()).to_int()
    if row < text_end.length() {
      let col = text_end[row].search_by(fn(end) { end > v.x })
      match col {
        None => ()
        Some(col) => clicked.set({ row, col })
      }
    }
    sel.set(Some(TextSelection::{ start: clicked.get(), end: clicked.get() }))
  }

  fn on_mouse_move(v : Vector) {
    let text_end = text_end.get()
    let row = {
      let row = (v.y / height.get()).to_int()
      if row < 0 {
        0
      } else if row < text_end.length() {
        row
      } else {
        text_end.length() - 1
      }
    }
    let col = text_end[row]
      .search_by(fn(end) { end > v.x })
      .or(text_end[row].length() - 1)
    let pointer = TextCursor::{ col, row }
    let (start, end) = if pointer < clicked.get() {
      (pointer, clicked.get())
    } else {
      (clicked.get(), pointer)
    }
    sel.set(Some(TextSelection::{ start, end }))
  }

  let handler = Handler::new(on_mouse_down~, on_mouse_move~)
  vstack(
    thunk(fn() {
      match sel.get() {
        None => content.get().map(unselected)
        Some(sel) => {
          let (top, mid, bot) = split(content.get(), sel)
          let mid = match mid {
            OneLine(prefix~, middle~, suffix~) => {
              on_selected_changed(middle)
              [
                hstack(
                  thunk(fn() {
                    [unselected(prefix), selected(middle), unselected(suffix)]
                  }),
                  spacing=0,
                ),
              ]
            }
            MultiLine(
              first_prefix~,
              first_suffix~,
              middle~,
              last_prefix~,
              last_suffix~
            ) => {
              let st = [first_suffix, ..middle, last_prefix].join("\n")
              on_selected_changed(st)
              [
                hstack(
                  thunk(fn() {
                    [unselected(first_prefix), selected(first_suffix)]
                  }),
                  spacing=0,
                ),
                ..middle.map(selected),
                hstack(
                  thunk(fn() {
                    [selected(last_prefix), unselected(last_suffix)]
                  }),
                  spacing=0,
                ),
              ]
            }
          }
          [..top.map(unselected), ..mid, ..bot.map(unselected)]
        }
      }
    }),
    spacing=0,
  ).add_handler(handler)
}
