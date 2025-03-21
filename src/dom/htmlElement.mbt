///|
pub impl DOM_HTMLElement for HTMLCanvasElement with to_htmlElement(self) = "%identity"

///|
pub impl DOM_HTMLElement for HTMLDivElement with to_htmlElement(self) = "%identity"

///|
pub impl DOM_HTMLElement for Element with to_htmlElement(self) = "%identity"

///|
pub impl DOM_HTMLElement for HTMLElement with to_htmlElement(self) = "%identity"

///|
pub impl DOM_HTMLElement for HTMLImageElement with to_htmlElement(self) = "%identity"

///|
extern "js" fn HTMLElement::style(self : HTMLElement) -> CSSStyleDeclaration = "importObject.HTMLElement.get_style"

///|
impl DOM_HTMLElement with style(self) {
  self.to_htmlElement().style()
}
