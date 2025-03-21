pub impl DOM_Element for HTMLCanvasElement with to_element(self) = "%identity"
pub impl DOM_Element for HTMLDivElement with to_element(self) = "%identity"
pub impl DOM_Element for Element with to_element(self) = "%identity"
pub impl DOM_Element for HTMLElement with to_element(self) = "%identity"


extern "js" fn Element::querySelector(self : Element, selectors : String) -> Element? = "importObject.Element.querySelector"
impl DOM_Element with querySelector(self, selectors)  {
  self.to_element().querySelector(selectors)
}
