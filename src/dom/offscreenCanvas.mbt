///|
pub extern "js" fn OffscreenCanvas::getContext(
  self : OffscreenCanvas,
  contextType : String
) -> OffCanvas2D = "importObject.OffscreenCanvas.getContext"

///|
pub extern "js" fn OffscreenCanvas::set_width(
  self : OffscreenCanvas,
  value : Int
) = "importObject.OffscreenCanvas.set_width"

///|
pub extern "js" fn OffscreenCanvas::set_height(
  self : OffscreenCanvas,
  value : Int
) = "importObject.OffscreenCanvas.set_height"

///|
pub extern "js" fn OffscreenCanvas::new(
  w : Double,
  h : Double
) -> OffscreenCanvas = "(w,h) => new OffscreenCanvas(w,h)"
