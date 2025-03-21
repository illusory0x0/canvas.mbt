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

pub extern "js" fn Canvas2D::fillRectF(
  self : Canvas2D,
  x : Double,
  y : Double,
  width : Double,
  height : Double
) = "importObject.CanvasRenderingContext2D.fillRect"


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

pub extern "js" fn Canvas2D::measureText(self : Canvas2D, text : String) -> TextMetrics = "importObject.CanvasRenderingContext2D.measureText"

pub extern "js" fn Canvas2D::set_textBaseline(self : Canvas2D, tag : String) = "importObject.CanvasRenderingContext2D.set_textBaseline"


pub extern "js" fn Canvas2D::scale(self : Canvas2D, x : Int, y : Int) =  "importObject.CanvasRenderingContext2D.scale"