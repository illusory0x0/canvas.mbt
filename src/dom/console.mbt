///|
extern "js" fn _console() -> Console = "importObject.global.console"
///|
extern "js" fn _log(self : Console, data : Any) -> Unit = "importObject.Console.log"


pub fn Console::log[T : Js](self : Console, data : T) -> Unit { self._log(data.to_any())}
///|
pub let console : Console = _console()