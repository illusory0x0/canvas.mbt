///|
let hover : Ref[(Rect, Handler)?] = Ref::new(None)

// ///|
// pub struct Hover[T] {
//   content : Dependency[T]
//   leave : (T) -> Element
//   enter : (T) -> Element
//   element : Dependency[Element]
// }

// ///|
// pub fn Hover::new[T : Widget](
//   make_content : () -> T,
//   leave~ : (T) -> Element,
//   enter~ : (T) -> Element
// ) -> Hover[T] {
//   let content = Dependency::new(make_content)
//   let element = Dependency::new(fn() { leave(content.value) })
//   fn add_handler(x : Element) {
//     x.handle(on_mouse_enter~, on_mouse_leave~)
//   }

//   fn on_mouse_enter() {
//     element.update(fn() { enter(content.value) |> add_handler })
//   }

//   fn on_mouse_leave() {
//     element.update(fn() { leave(content.value) |> add_handler })
//   }

//   element.modify(fn(e) { e.handle(on_mouse_enter~, on_mouse_leave~) })
//   element.depend_on(content)
//   { content, leave, enter, element }
// }

// ///|
// pub impl[T] Widget for Hover[T] with dependency(self) {
//   Some(self.element)
// }
