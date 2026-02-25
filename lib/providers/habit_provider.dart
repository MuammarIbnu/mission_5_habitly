import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/habit.dart';
import 'package:uuid/uuid.dart';

final habitProvider =
NotifierProvider<HabitNotifier, AsyncValue<List<Habit>>>(
  HabitNotifier.new,
);

class HabitNotifier extends Notifier<AsyncValue<List<Habit>>> {
  late Box<Habit> _box;

  @override
  AsyncValue<List<Habit>> build() {
    //{Inline Review: Pertimbangkan lifecycle loading/error eksplisit (mis. AsyncNotifier) untuk bootstrap state yang lebih robust.}
    _box = Hive.box<Habit>('habitsBox');
    return AsyncData(_box.values.toList());
  }

  /// ADD HABIT DENGAN DATE & TIME (hour & minute)
  Future<bool> addHabitWithDateTime({
    required String title,
    required DateTime date,
    required int hour,
    required int minute,
  }) async {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) return false;

    final isExist = _box.values.any(
          (habit) => habit.title.toLowerCase() == trimmedTitle.toLowerCase(),
    );
    if (isExist) return false;

    final habit = Habit(
      id: const Uuid().v4(),
      title: trimmedTitle,
      date: date,
      hour: hour,
      minute: minute,
    );

    await _box.put(habit.id, habit);
    state = AsyncData(_box.values.toList());
    return true;
  }

  Future<void> deleteHabit(String id) async {
    await _box.delete(id);
    state = AsyncData(_box.values.toList());
  }

  Future<void> toggleHabit(String id) async {
    final habit = _box.get(id);
    if (habit == null) return;

    final updated = habit.copyWith(
      isCompleted: !habit.isCompleted,
    );

    await _box.put(id, updated);
    state = AsyncData(_box.values.toList());
  }

  Future<void> editHabit({
  required String id,
  required String newTitle,
  required DateTime newDate,
  required int newHour,
  required int newMinute,
}) async {
  final habit = _box.get(id);
  if (habit == null) return;

  final trimmedTitle = newTitle.trim();
  if (trimmedTitle.isEmpty) return;

  final updatedHabit = habit.copyWith(
    title: trimmedTitle,
    date: newDate,
    hour: newHour,
    minute: newMinute,
  );

  await _box.put(id, updatedHabit);

  // refresh state
  state = AsyncData(_box.values.toList());
}
}
