import 'package:shared_preferences/shared_preferences.dart';

class FocusSessionStore {
  static const String _key = 'focus_session_dates';

  Future<List<String>> _loadDates() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> _saveDates(List<String> dates) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, dates);
  }

  String _todayKey(DateTime now) {
    final local = now.toLocal();
    final month = local.month.toString().padLeft(2, '0');
    final day = local.day.toString().padLeft(2, '0');
    return '${local.year}-$month-$day';
  }

  Future<int> todaySessionCount({DateTime? now}) async {
    final dates = await _loadDates();
    final today = _todayKey(now ?? DateTime.now());
    return dates.where((d) => d == today).length;
  }

  Future<int> recordSession({DateTime? now}) async {
    final today = _todayKey(now ?? DateTime.now());
    final dates = await _loadDates();

    dates.add(today);

    final pruned = dates.where((d) => d == today).toList();
    await _saveDates(pruned);
    return pruned.length;
  }
}