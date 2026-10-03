abstract class CycleClock {
  String cycleIdFor(DateTime dateTime, String timezone);
  bool isResetDay(DateTime dateTime, String timezone);
  (DateTime startUtc, DateTime endUtc) windowFor(String cycleId, String timezone);
  bool isWithinWindow((DateTime startUtc, DateTime endUtc) window, DateTime instant);
}
