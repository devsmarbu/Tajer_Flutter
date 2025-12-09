extension DynamicToIntExtension on dynamic {
  /// Converts String, int, double, or null safely to int.
  /// Handles decimal strings like "5.00" → 5
  int toIntSafe() {
    if (this == null) return 0;

    if (this is int) return this as int;

    if (this is double) return (this as double).round();

    if (this is String) {
      final str = this as String;

      // Try parsing as int first
      final intVal = int.tryParse(str);
      if (intVal != null) return intVal;

      // If that fails, parse as double then convert to int
      final doubleVal = double.tryParse(str);
      if (doubleVal != null) return doubleVal.round();
    }

    return 0;
  }
}