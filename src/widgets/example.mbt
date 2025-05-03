///|
type Example

///|
fn Example::text_selected() -> Element {
  let font = const_thunk(font)
  let color = const_thunk(white)
  let num_20 = const_thunk(20.0)
  let padding_color = const_thunk(Color::hsl(0, 0, 20))
  selected_text(
    content=thunk(fn() { xs }),
    font~,
    foregound=color,
    background=const_thunk(black),
    on_selected_changed=fn(str) { println(str) },
  ).round_padding(thinkness=num_20, color=padding_color, radius=num_20)
}

///|
fn Example::counter() -> Element {
  let counter = cell(0)
  let t = thunk(fn() { "counter: \{counter.get()}" })
  let font = const_thunk(font)
  let color = const_thunk(white)
  let num_20 = const_thunk(20.0)
  let padding_color = const_thunk(Color::hsl(0, 0, 20))
  let button = text(content=thunk(fn() { "+" }), font~, color~)
    .round_padding(thinkness=num_20, color=padding_color, radius=num_20)
    .add_handler(
      Handler::new(on_click=fn() { counter.modify(fn { x => x + 1 }) }, on_double_click=fn(

      ) {
        counter.modify(fn { x => x + 10 })
      }),
    )
  let label = text(content=t, font~, color~).round_padding(
    thinkness=num_20,
    color=padding_color,
    radius=num_20,
  )
  hstack(const_thunk([label, button]), spacing=20)
}
