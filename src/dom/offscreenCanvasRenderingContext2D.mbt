///|
pub typealias OffCanvas2D = OffscreenCanvasRenderingContext2D

///|
pub extern "js" fn OffCanvas2D::set_font(self : OffCanvas2D, font : String) = "importObject.OffscreenCanvasRenderingContext2D.set_font"

///|
pub extern "js" fn OffCanvas2D::set_fillStyle(self : OffCanvas2D, style : String) = "importObject.OffscreenCanvasRenderingContext2D.set_fillStyle"

///|
pub extern "js" fn OffCanvas2D::set_strokeStyle(self : OffCanvas2D, style : String) = "importObject.OffscreenCanvasRenderingContext2D.set_strokeStyle"

///|
pub extern "js" fn OffCanvas2D::set_lineWidth(self : OffCanvas2D, width : Double) = "importObject.OffscreenCanvasRenderingContext2D.set_lineWidth"

///|
pub extern "js" fn OffCanvas2D::fillText(
  self : OffCanvas2D,
  text : String,
  x : Double,
  y : Double
) = "importObject.OffscreenCanvasRenderingContext2D.fillText"

///|
pub extern "js" fn OffCanvas2D::strokeRect(
  self : OffCanvas2D,
  x : Double,
  y : Double,
  width : Double,
  height : Double
) = "importObject.OffscreenCanvasRenderingContext2D.strokeRect"

///|
pub extern "js" fn OffCanvas2D::fillRect(
  self : OffCanvas2D,
  x : Double,
  y : Double,
  width : Double,
  height : Double
) = "importObject.OffscreenCanvasRenderingContext2D.fillRect"

///|
pub extern "js" fn OffCanvas2D::clearRect(
  self : OffCanvas2D,
  x : Double,
  y : Double,
  width : Double,
  height : Double
) = "importObject.OffscreenCanvasRenderingContext2D.clearRect"

///| This method is very slow, user might need memoization.
pub extern "js" fn OffCanvas2D::measureText(
  self : OffCanvas2D,
  text : String
) -> TextMetrics = "importObject.OffscreenCanvasRenderingContext2D.measureText"

///|
pub extern "js" fn OffCanvas2D::set_textBaseline(self : OffCanvas2D, tag : String) = "importObject.OffscreenCanvasRenderingContext2D.set_textBaseline"

///|
pub extern "js" fn OffCanvas2D::scale(self : OffCanvas2D, x : Double, y : Double) = "importObject.OffscreenCanvasRenderingContext2D.scale"

///|
pub extern "js" fn OffCanvas2D::beginPath(self : OffCanvas2D) = "importObject.OffscreenCanvasRenderingContext2D.beginPath"

///|
pub extern "js" fn OffCanvas2D::closePath(self : OffCanvas2D) = "importObject.OffscreenCanvasRenderingContext2D.closePath"

///|
pub extern "js" fn OffCanvas2D::stroke(self : OffCanvas2D) = "importObject.OffscreenCanvasRenderingContext2D.stroke"

///|
pub extern "js" fn OffCanvas2D::fill(self : OffCanvas2D) = "importObject.OffscreenCanvasRenderingContext2D.fill"

///|
pub extern "js" fn OffCanvas2D::moveTo(self : OffCanvas2D, x : Double, y : Double) = "importObject.OffscreenCanvasRenderingContext2D.moveTo"

///|
pub extern "js" fn OffCanvas2D::lineTo(self : OffCanvas2D, x : Double, y : Double) = "importObject.OffscreenCanvasRenderingContext2D.lineTo"

///|
pub extern "js" fn OffCanvas2D::arc(
  self : OffCanvas2D,
  x : Double,
  y : Double,
  radius : Double,
  startAngle : Double,
  endAngle : Double,
  counterclockwise : Bool
) = "importObject.OffscreenCanvasRenderingContext2D.arc"

///|
pub extern "js" fn OffCanvas2D::arcTo(
  self : OffCanvas2D,
  x1 : Double,
  y1 : Double,
  x2 : Double,
  y2 : Double,
  radius : Double
) = "importObject.OffscreenCanvasRenderingContext2D.arcTo"

///|
pub extern "js" fn OffCanvas2D::ellipse(
  self : OffCanvas2D,
  x : Double,
  y : Double,
  radiusX : Double,
  radiusY : Double,
  rotation : Double,
  startAngle : Double,
  endAngle : Double,
  counterclockwise : Bool
) = "importObject.OffscreenCanvasRenderingContext2D.ellipse"

///|
pub extern "js" fn OffCanvas2D::save(self : OffCanvas2D) = "importObject.OffscreenCanvasRenderingContext2D.save"

///|
pub extern "js" fn OffCanvas2D::restore(self : OffCanvas2D) = "importObject.OffscreenCanvasRenderingContext2D.restore"

///|
pub extern "js" fn OffCanvas2D::roundRect(
  self : OffCanvas2D,
  x : Double,
  y : Double,
  width : Double,
  height : Double,
  top_left_radius : Double,
  top_right_radius : Double,
  bottom_left_radius : Double,
  bottom_right_radius : Double
) =
  #| (self, x, y, width, height, top_left_radius, top_right_radius, bottom_left_radius, bottom_right_radius) => 
  #|    self.roundRect(x, y, width,height,[top_left_radius, top_right_radius, bottom_left_radius, bottom_right_radius])
