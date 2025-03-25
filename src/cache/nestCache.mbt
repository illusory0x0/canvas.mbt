///|
pub struct NestCache[S, T] {
  source : Cache[S]
  target : Cache[T]
}

///|
/// 
///     self.target <---- self.source <---- other.target <--- other.source
///    
pub fn NestCache::depend_on[S1, T1, S2, T2](
  self : NestCache[S1, T1],
  other : NestCache[S2, T2]
) -> Unit {
  self.source.depend_on(other.target)
}

///|
pub fn NestCache::new[S, T](
  source~ : Cache[S],
  target~ : Cache[T]
) -> NestCache[S, T] {
  source.depend_on(target)
  { source, target }
}

///|
pub fn NestCache::refresh[S, T](self : NestCache[S, T]) -> Unit {
  self.source.refresh()
}
