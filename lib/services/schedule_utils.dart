class ScheduleUtils {
  ScheduleUtils._();

  static bool runsOnDay(Map<String, String> schedule, DateTime date) {
    final days = schedule['days'] ?? '';
    if (days.length != 7) return false;
    return days[date.weekday - 1] == '1';
  }

  static int? hourOf(Map<String, String> schedule) {
    final parts = (schedule['departure_time'] ?? '').split(':');
    if (parts.length != 3) return null;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);
    final second = int.tryParse(parts[2]);

    if (hour == null ||
        minute == null ||
        second == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59 ||
        second < 0 ||
        second > 59) {
      return null;
    }

    return hour;
  }

  static List<Map<String, String>> filterSchedules(
    List<Map<String, String>> schedules,
    DateTime date,
    int filterIndex,
  ) {
    return schedules.where((schedule) {
      if (!runsOnDay(schedule, date)) return false;

      final hour = hourOf(schedule);
      if (hour == null) return false;

      if (filterIndex == 1 && hour >= 12) return false;
      if (filterIndex == 2 && (hour < 12 || hour >= 17)) {
        return false;
      }
      if (filterIndex == 3 && hour < 17) return false;

      return true;
    }).toList();
  }

  static String formatTime(String raw) {
    final parts = raw.split(':');
    if (parts.length != 3) return raw;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null ||
        minute == null ||
        hour < 0 ||
        hour > 23 ||
        minute < 0 ||
        minute > 59) {
      return raw;
    }

    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }
}
