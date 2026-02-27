import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 0)
class Habit {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final bool isCompleted;

  @HiveField(3)
  final DateTime date;

  @HiveField(4)
  final int hour;

  @HiveField(5)
  final int minute;

  Habit({
    required this.id,
    required this.title,
    this.isCompleted = false,
    DateTime? date,
    int? hour,
    int? minute,
  })  : date = date ?? DateTime.now(),
        hour = hour ?? 0,
        minute = minute ?? 0;

  DateTime get fullDateTime {
    return DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );
  }

  Habit copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? date,
    int? hour,
    int? minute,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      date: date ?? this.date,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
    );
  }
}