


// ///|
// priv struct App {
//   widget : Widget[Int]
//   cache : Dependency[Array[(Vector, Element)]]
// }

// ///|
// fn App::new() -> App {
//   let mut counter = 0
//   let source = Dependency::new(fn() { counter })
//   let button = Element::text(text="+", font~, color=white)
//     .round_padding(thickness=16, color=black, radius=50)
//     .handle(
//       Handler::new(on_click=fn() {
//         counter += 1
//         source.update()
//       }),
//     )
//   let text = Dependency::new(fn() {
//     Element::text(text="counter: \{source.cache}", font~, color=white)
//   })
//   let label = Widget::hover(
//     text,
//     leave=fn(e) {
//       e.round_padding(thickness=20, color=hsl(0, 0, 60), radius=20)
//     },
//     enter=fn(e) {
//       e.round_padding(thickness=20, color=hsl(0, 0, 20), radius=20)
//     },
//   )

//   // println(label.target.value)

//   let target = Dependency::new(fn() {
//     Element::hstack([label.target.cache, button], spacing=40)
//   })
//   let cache = Dependency::new(fn() { target.cache.to_layout_sequence(origin) })
//   let widget = { source, target }
//   widget.depend_on(label)
//   cache.depend_on(target)
//   { widget, cache }
// }

// ///|
// fn App::render_sequence(self : App) -> Iter[(Vector, Renderable)] {
//   self.cache.cache
//   .iter()
//   .filter_map(fn {
//     (o, e) =>
//       match e {
//         Render(x) => Some((o, x))
//         _ => None
//       }
//   })
// }

// ///|
// fn App::event_sequence(self : App) -> Iter[(Rect, Handler)] {
//   self.cache.cache
//   .rev_iter()
//   .filter_map(fn {
//     (offset, e) =>
//       match e {
//         Control(e, h) => Some(({ offset, size: e.size() }, h))
//         _ => None
//       }
//   })
// }

// ///|
// fn App::render(self : App) -> Unit {
//   let rs = self.render_sequence()
//   ctx.clearRect(0, 0, window.innerWidth(), window.innerHeight())
//   Renderable::render_sequence(ctx, rs)
// }
