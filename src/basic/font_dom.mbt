///|
let context : @dom.Canvas2D = {
  let canvas : @dom.HTMLCanvasElement = @dom.document.createElement("canvas")
    |> @dom.coerce
  canvas.getContext("2d")
}

///|
let memo : Map[(Font, String), @dom.TextMetrics] = {}

///|
fn Font::measure_text(self : Font, text : String) -> @dom.TextMetrics {
  match memo[(self, text)] {
    None => {
      context.set_font(self.to_string())
      let x = context.measureText(text)
      memo[(self, text)] = x
      x
    }
    Some(x) => x
  }
}

///|
pub fn Font::width(self : Font, text : String) -> Double {
  self.measure_text(text).width()
}

///|
pub fn Font::height(self : Font, text : String) -> Double {
  let metrics = self.measure_text(text)
  let ascent = metrics.fontBoundingBoxAscent()
  let descent = metrics.fontBoundingBoxDescent()
  return ascent + descent
}
