///|
let canvas : @dom.HTMLCanvasElement = @dom.document.querySelector("#canvas")

///|
let ctx : @dom.Canvas2D = canvas.getContext("2d")

///|
let white : Color = hsl(0, 0, 100)

///|
let black : Color = hsl(0, 0, 0)

///|
let yellow : Color = hsl(60, 100, 50)

///|
let red : Color = hsl(0, 100, 50)

///|
let green : Color = hsl(120, 100, 50)

///|
let blue : Color = hsl(240, 100, 50)

///|
let font : Font = { ..Font::default(), weight: 320 }

///|
let origin : Vector = { x: 20, y: 20 }
