///|
pub(open) trait Js {
  to_any(Self) -> Any = _
}

///|
impl Js with to_any(self) = "%identity"

///|
pub fn coerce[A, B](x : A) -> B = "%identity"

///|
pub(open) trait DOM_EventTarget {
  to_eventTarget(Self) -> EventTarget
  addEventListener(Self, String, (Event) -> Unit) -> Unit = _
}

///|
pub(open) trait DOM_Element {
  to_element(Self) -> Element
  querySelector(Self, String) -> Element? = _
}

///|
pub(open) trait DOM_HTMLElement {
  to_htmlElement(Self) -> HTMLElement
  style(Self) -> CSSStyleDeclaration = _
}

///|
pub(open) trait DOM_Event {
  to_event(Self) -> Event
}
