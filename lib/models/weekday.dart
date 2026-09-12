/// Monday-first weekday, matching the day-of-week pill row (M T W T F S S)
/// in DESIGN_TOKENS.md and DateTime.weekday's own Monday=1..Sunday=7 order.
enum Weekday {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday;

  /// Matches `DateTime.weekday` (Monday = 1 .. Sunday = 7).
  int get dateTimeValue => index + 1;

  static Weekday fromDateTime(DateTime date) => values[date.weekday - 1];
}
