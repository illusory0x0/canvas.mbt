///|
type Example

///|
fn Example::text_selected() -> Element {
  let font = thunk(fn() { font })
  let color = thunk(fn() { white })
  let num_20 = const_thunk(20.0)
  let padding_color = const_thunk(Color::hsl(0, 0, 20))
  Element::selected_text(
    text=thunk(fn() { xs }),
    font~,
    foregound=color,
    background=const_thunk(black),
  ).round_padding(thinkness=num_20, color=padding_color, radius=num_20)
}

///|
fn Example::counter() -> Element {
  let counter = cell(0)
  let t = thunk(fn() { "counter: \{counter.get()}" })
  let font = thunk(fn() { font })
  let color = thunk(fn() { white })
  let num_20 = const_thunk(20.0)
  let padding_color = const_thunk(Color::hsl(0, 0, 20))
  let button = Element::Render(mk_text(text=thunk(fn() { "+" }), font~, color~))
    .round_padding(thinkness=num_20, color=padding_color, radius=num_20)
    .add_handler(
      Handler::new(on_click=fn() { counter.modify(fn { x => x + 1 }) }, on_double_click=fn(

      ) {
        counter.modify(fn { x => x + 10 })
      }),
    )
  let label = Element::Render(mk_text(text=t, font~, color~)).round_padding(
    thinkness=num_20,
    color=padding_color,
    radius=num_20,
  )
  Element::hstack(const_thunk([label, button]), spacing=20)
}
