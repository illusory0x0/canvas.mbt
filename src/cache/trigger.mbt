pub fn Trigger::depend_on[A : RequiredBy](self : Trigger, other : A) -> Unit{
  other.require_by(self._)
}