///|
extern "js" fn _window() -> Window = "() => window"

///|
pub let window : Window = _window() 

// importObject.Window
pub extern "js" fn Window::devicePixelRatio(self : Window) -> Double = "importObject.Window.get_devicePixelRatio" 
pub extern "js" fn Window::innerHeight(self : Window) -> Int = "importObject.Window.get_innerHeight" 
pub extern "js" fn Window::innerWidth(self : Window) -> Int = "importObject.Window.get_innerWidth" 