///|
pub typealias Canvas2D = CanvasRenderingContext2D

///|
pub extern "js" fn Canvas2D::set_font(self : Canvas2D, font : String) = "importObject.CanvasRenderingContext2D.set_font"

///|
pub extern "js" fn Canvas2D::set_fillStyle(self : Canvas2D, style : String) = "importObject.CanvasRenderingContext2D.set_fillStyle"

///|
pub extern "js" fn Canvas2D::set_strokeStyle(self : Canvas2D, style : String) = "importObject.CanvasRenderingContext2D.set_strokeStyle"

///|
pub extern "js" fn Canvas2D::set_lineWidth(self : Canvas2D, width : Double) = "importObject.CanvasRenderingContext2D.set_lineWidth"

///|
pub extern "js" fn Canvas2D::fillText(
  self : Canvas2D,
  text : String,
  x : Double,
  y : Double
) = "importObject.CanvasRenderingContext2D.fillText"

///|
pub extern "js" fn Canvas2D::strokeRect(
  self : Canvas2D,
  x : Double,
  y : Double,
  width : Double,
  height : Double
) = "importObject.CanvasRenderingContext2D.strokeRect"

///|
pub extern "js" fn Canvas2D::fillRect(
  self : Canvas2D,
  x : Double,
  y : Double,
  width : Double,
  height : Double
) = "importObject.CanvasRenderingContext2D.fillRect"

///|
pub extern "js" fn Canvas2D::clearRect(
  self : Canvas2D,
  x : Double,
  y : Double,
  width : Double,
  height : Double
) = "importObject.CanvasRenderingContext2D.clearRect"

///| This method is very slow, user might need memoization.
pub extern "js" fn Canvas2D::measureText(
  self : Canvas2D,
  text : String
) -> TextMetrics = "importObject.CanvasRenderingContext2D.measureText"

///|
pub extern "js" fn Canvas2D::set_textBaseline(self : Canvas2D, tag : String) = "importObject.CanvasRenderingContext2D.set_textBaseline"

///|
pub extern "js" fn Canvas2D::scale(self : Canvas2D, x : Double, y : Double) = "importObject.CanvasRenderingContext2D.scale"

///|
pub extern "js" fn Canvas2D::beginPath(self : Canvas2D) = "importObject.CanvasRenderingContext2D.beginPath"

///|
pub extern "js" fn Canvas2D::closePath(self : Canvas2D) = "importObject.CanvasRenderingContext2D.closePath"

///|
pub extern "js" fn Canvas2D::stroke(self : Canvas2D) = "importObject.CanvasRenderingContext2D.stroke"

///|
pub extern "js" fn Canvas2D::fill(self : Canvas2D) = "importObject.CanvasRenderingContext2D.fill"

///|
pub extern "js" fn Canvas2D::moveTo(self : Canvas2D, x : Double, y : Double) = "importObject.CanvasRenderingContext2D.moveTo"

///|
pub extern "js" fn Canvas2D::lineTo(self : Canvas2D, x : Double, y : Double) = "importObject.CanvasRenderingContext2D.lineTo"

///|
pub extern "js" fn Canvas2D::arc(
  self : Canvas2D,
  x : Double,
  y : Double,
  radius : Double,
  startAngle : Double,
  endAngle : Double,
  counterclockwise : Bool
) = "importObject.CanvasRenderingContext2D.arc"

///|
pub extern "js" fn Canvas2D::arcTo(
  self : Canvas2D,
  x1 : Double,
  y1 : Double,
  x2 : Double,
  y2 : Double,
  radius : Double
) = "importObject.CanvasRenderingContext2D.arcTo"

///|
pub extern "js" fn Canvas2D::ellipse(
  self : Canvas2D,
  x : Double,
  y : Double,
  radiusX : Double,
  radiusY : Double,
  rotation : Double,
  startAngle : Double,
  endAngle : Double,
  counterclockwise : Bool
) = "importObject.CanvasRenderingContext2D.ellipse"

///|
pub extern "js" fn Canvas2D::save(self : Canvas2D) = "importObject.CanvasRenderingContext2D.save"

///|
pub extern "js" fn Canvas2D::restore(self : Canvas2D) = "importObject.CanvasRenderingContext2D.restore"

///|
pub extern "js" fn Canvas2D::roundRect(
  self : Canvas2D,
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
