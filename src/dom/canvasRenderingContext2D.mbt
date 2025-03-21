///|
pub typealias Canvas2D = CanvasRenderingContext2D

///|
pub extern "js" fn Canvas2D::set_font(self : Canvas2D, font : String) = "importObject.CanvasRenderingContext2D.set_font"

///|
pub extern "js" fn Canvas2D::set_fillStyle(self : Canvas2D, style : String) = "importObject.CanvasRenderingContext2D.set_fillStyle"

///|
pub extern "js" fn Canvas2D::set_strokeStyle(self : Canvas2D, style : String) = "importObject.CanvasRenderingContext2D.set_strokeStyle"

///|
pub extern "js" fn Canvas2D::set_lineWidth(self : Canvas2D, width : Int) = "importObject.CanvasRenderingContext2D.set_lineWidth"

///|
pub extern "js" fn Canvas2D::fillText(
  self : Canvas2D,
  text : String,
  x : Int,
  y : Int
) = "importObject.CanvasRenderingContext2D.fillText"

///|
pub extern "js" fn Canvas2D::fillRect(
  self : Canvas2D,
  x : Int,
  y : Int,
  width : Int,
  height : Int
) = "importObject.CanvasRenderingContext2D.fillRect"

///|
pub extern "js" fn Canvas2D::strokeRect(
  self : Canvas2D,
  x : Int,
  y : Int,
  width : Int,
  height : Int
) = "importObject.CanvasRenderingContext2D.strokeRect"

///|
pub extern "js" fn Canvas2D::fillRectF(
  self : Canvas2D,
  x : Double,
  y : Double,
  width : Double,
  height : Double
) = "importObject.CanvasRenderingContext2D.fillRect"

///|
pub extern "js" fn Canvas2D::clearRect(
  self : Canvas2D,
  x : Int,
  y : Int,
  width : Int,
  height : Int
) = "importObject.CanvasRenderingContext2D.clearRect"

///|
pub extern "js" fn Canvas2D::clearRectF(
  self : Canvas2D,
  x : Double,
  y : Double,
  width : Double,
  height : Double
) = "importObject.CanvasRenderingContext2D.clearRect"

///|
pub extern "js" fn Canvas2D::measureText(
  self : Canvas2D,
  text : String
) -> TextMetrics = "importObject.CanvasRenderingContext2D.measureText"

///|
pub extern "js" fn Canvas2D::set_textBaseline(self : Canvas2D, tag : String) = "importObject.CanvasRenderingContext2D.set_textBaseline"

///|
pub extern "js" fn Canvas2D::scale(self : Canvas2D, x : Int, y : Int) = "importObject.CanvasRenderingContext2D.scale"

///|
pub extern "js" fn Canvas2D::beginPath(self : Canvas2D) = "importObject.CanvasRenderingContext2D.beginPath"

///|
pub extern "js" fn Canvas2D::closePath(self : Canvas2D) = "importObject.CanvasRenderingContext2D.closePath"

///|
pub extern "js" fn Canvas2D::stroke(self : Canvas2D) = "importObject.CanvasRenderingContext2D.stroke"

///|
pub extern "js" fn Canvas2D::fill(self : Canvas2D) = "importObject.CanvasRenderingContext2D.fill"

///|
pub extern "js" fn Canvas2D::moveTo(self : Canvas2D, x : Int, y : Int) = "importObject.CanvasRenderingContext2D.moveTo"

///|
pub extern "js" fn Canvas2D::lineTo(self : Canvas2D, x : Int, y : Int) = "importObject.CanvasRenderingContext2D.lineTo"

///|
pub extern "js" fn Canvas2D::arc(
  self : Canvas2D,
  x : Int,
  y : Int,
  radius : Int,
  startAngle : Double,
  endAngle : Double,
  counterclockwise : Bool
) = "importObject.CanvasRenderingContext2D.arc"

///|
pub extern "js" fn Canvas2D::arcTo(
  self : Canvas2D,
  x1 : Int,
  y1 : Int,
  x2 : Int,
  y2 : Int,
  radius : Int
) = "importObject.CanvasRenderingContext2D.arcTo"

///|
pub extern "js" fn Canvas2D::ellipse(
  self : Canvas2D,
  x : Int,
  y : Int,
  radiusX : Int,
  radiusY : Int,
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
  x : Int,
  y : Int,
  width : Int,
  height : Int,
  top_left_radius : Int,
  top_right_radius : Int,
  bottom_left_radius : Int,
  bottom_right_radius : Int
) =
  #| (self, x, y, width, height, top_left_radius, top_right_radius, bottom_left_radius, bottom_right_radius) => 
  #|    self.roundRect(x, y, width,height,[top_left_radius, top_right_radius, bottom_left_radius, bottom_right_radius])
