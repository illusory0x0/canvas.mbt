///|
pub impl DOM_Event for Event with to_event(self) = "%identity"

///|
pub impl DOM_Event for MouseEvent with to_event(self) = "%identity"

///|
pub impl DOM_Event for KeyboardEvent with to_event(self) = "%identity"

// impl DOM_Event with downcast(self) = "%identity"

///|
pub fn Event::downcast[T : DOM_Event](self : Event) -> T = "%identity"
