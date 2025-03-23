///|
extern "js" fn _document() -> Document = "() => document"

///|
pub let document : Document = _document()

///|
pub extern "js" fn Document::createElement(
  self : Document,
  tagName : String
) -> Element = "importObject.Document.createElement"

///|
pub extern "js" fn Document::getElementById(
  self : Document,
  id : String
) -> Element = "importObject.Document.getElementById"

///|
extern "js" fn Document::_querySelector(
  self : Document,
  selector : String
) -> Element = "importObject.Document.querySelector"

///|
pub fn Document::querySelector[T : DOM_Element](
  self : Document,
  selector : String
) -> T {
  self._querySelector(selector) |> coerce
}
