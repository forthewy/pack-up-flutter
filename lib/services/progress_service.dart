import 'package:hive_flutter/hive_flutter.dart';

class ProgressService {
  static double calculateCategoryProgress(
      Box box,
      int categoryIndex,
      ) {
    final values = box.values;

    int total = 0;
    int checked = 0;

    for (final raw in values) {
      final map = Map<String, dynamic>.from(raw);

      if (map['category'] == categoryIndex) {
        total++;

        if (map['isChecked'] == true) {
          checked++;
        }
      }
    }

    if (total == 0) return 0.0;

    return checked / total;
  }
}