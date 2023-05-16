abstract class CounterEvents {
  CounterEvents._();
  static const _event = 'counter';
  static const updated = '$_event/updated';
  static const reset = '$_event/reset';
}
