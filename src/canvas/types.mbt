

pub struct Size {
  width : Int 
  height : Int
} derive(Default,Show,Compare,Eq,Hash)

pub struct Rect {
  offset : Vector 
  size : Size
}derive(Default,Show,Compare,Eq,Hash)

pub struct Vector {
  x : Int
  y : Int 
}derive(Default,Show,Compare,Eq,Hash)

pub struct Thinkness {
  left : Int 
  top : Int 
  right : Int
  bottom : Int
}derive(Default,Show,Compare,Eq,Hash)

enum FontStyle {
  Normal
  Italic
} derive(Compare,Eq,Hash)

enum GenericFontFamily {
    Serif
    SansSerif
    Monospace
    Cursive
    Fantasy
    SystemUI
    UISerif
    UISansSerif
    UIMonospace
    UIRounded
    Math
    Emoji
    FangSong
} derive(Compare,Eq,Hash)

pub struct Font {
  family : Array[String]
  genericFamily : Array[GenericFontFamily]
  size : Int 
  style : FontStyle
  weight : Int
} derive(Compare,Eq)


typealias @lazy.Lazy[T]  
typealias @lazy.LazyRec[T]

pub enum Renderable {
  Text(color~ : Color, LazyRec[(String,Font,Lazy[Size])]) 
  Rectangle(color~ : Color,size~ : Size)
  Border(color~ : Color,size~: Size,thickness~ : Thinkness)
} derive(Show)

typealias @dom.Canvas2D

// pub struct PositionedRenderable {
//   offset : Vector
//   render : Renderable
// }

pub struct Positioned[T] {
  offset : Vector
  box : T
}

pub fn Positioned::new[T](offset : Vector,box : T) -> Positioned[T] {
  { offset, box }
}