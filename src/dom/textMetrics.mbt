///|
pub extern "js" fn TextMetrics::widthF(self : TextMetrics) -> Double = "importObject.TextMetrics.get_width"

///|
pub extern "js" fn TextMetrics::fontBoundingBoxAscentF(
  self : TextMetrics
) -> Double = "importObject.TextMetrics.get_fontBoundingBoxAscent"

///|
pub extern "js" fn TextMetrics::fontBoundingBoxDescentF(
  self : TextMetrics
) -> Double = "importObject.TextMetrics.get_fontBoundingBoxDescent"

///|
pub fn TextMetrics::width(self : TextMetrics) -> Int {
  self.widthF().round().to_int()
}

///|
pub fn TextMetrics::fontBoundingBoxAscent(self : TextMetrics) -> Int {
  self.fontBoundingBoxAscentF().round().to_int()
}

///|
pub fn TextMetrics::fontBoundingBoxDescent(self : TextMetrics) -> Int {
  self.fontBoundingBoxDescentF().round().to_int()
}
