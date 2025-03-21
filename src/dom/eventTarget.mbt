///|
pub impl DOM_EventTarget for Window with to_eventTarget(self) = "%identity"

///|
pub impl DOM_EventTarget for HTMLCanvasElement with to_eventTarget(self) = "%identity"

///|
pub impl DOM_EventTarget for HTMLDivElement with to_eventTarget(self) = "%identity"

///|
pub impl DOM_EventTarget for HTMLAnchorElement with to_eventTarget(self) = "%identity"

///|
pub impl DOM_EventTarget for HTMLImageElement with to_eventTarget(self) = "%identity"

///|
pub impl DOM_EventTarget for Document with to_eventTarget(self) = "%identity"

///|
pub impl DOM_EventTarget for EventTarget with to_eventTarget(self) = "%identity"

///|
pub impl DOM_EventTarget for Node with to_eventTarget(self) = "%identity"

///|
pub impl DOM_EventTarget for Element with to_eventTarget(self) = "%identity"

///|
pub impl DOM_EventTarget for HTMLElement with to_eventTarget(self) = "%identity"

///|
extern "js" fn EventTarget::addEventListener(
  self : EventTarget,
  type_ : String,
  listener : (Event) -> Unit
) = "importObject.EventTarget.addEventListener"

///|
impl DOM_EventTarget with addEventListener(self, type_, listener) {
  self.to_eventTarget().addEventListener(type_, listener)
}
