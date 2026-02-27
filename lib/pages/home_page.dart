import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_5_habbits/theme/app_color.dart';
import '../routes.dart';
import '../providers/habit_provider.dart';
import '../widgets/habit_grid.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitState = ref.watch(habitProvider);

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              /// PROGRESS
              habitState.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => const SizedBox(),
                data: (habits) {
                  final total = habits.length;
                  final completed = habits.where((h) => h.isCompleted).length;
                  final progress = total == 0 ? 0.0 : completed / total;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "$completed of $total completed",
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 24),
              const Text(
                "What habit you want to do?",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                "Select One or More",
                style: TextStyle(color: Colors.black54),
              ),
              const SizedBox(height: 24),

              /// HABIT GRID
              Expanded(
                child: HabitGrid(onAddHabit: _showAddHabitDialog),
              ),

              const SizedBox(height: 16),

              /// BUTTONS
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/homeMain',
                              (route) => false,
                        );
                      },
                      child: const Text("Skip", style: TextStyle(color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.homePage2, // route ke HomePage2
                              (route) => false,
                        );
                      },
                      child: const Text("Proceed", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  /// SHOW ADD HABIT DIALOG
  Future<void> _showAddHabitDialog(BuildContext context, WidgetRef ref, String habitName) async {
    final TextEditingController controller = TextEditingController(text: habitName);
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    await showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Add Habit"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: controller, decoration: const InputDecoration(hintText: "Habit name")),
              const SizedBox(height: 12),
              ListTile(
                title: Text(selectedDate == null
                    ? "Select date"
                    : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) setState(() => selectedDate = date);
                },
              ),
              ListTile(
                title: Text(selectedTime == null
                    ? "Select time"
                    : selectedTime!.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (time != null) setState(() => selectedTime = time);
                },
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () async {
                if (controller.text.isEmpty || selectedDate == null || selectedTime == null) return;

                final success = await ref.read(habitProvider.notifier).addHabitWithDateTime(
                  title: controller.text.trim(),
                  date: selectedDate!,
                  hour: selectedTime!.hour,
                  minute: selectedTime!.minute,
                );

                if (success) {
                  Navigator.pop(context);

                  // Refresh habit provider agar langsung tampil di HomePageMain / grid
                  ref.invalidate(habitProvider);

                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("${controller.text} added!")));
                }
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}