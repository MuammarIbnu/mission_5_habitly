import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mission_5_habbits/theme/app_color.dart';
import '../providers/habit_provider.dart';

class HomePage2 extends ConsumerWidget {
  const HomePage2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitState = ref.watch(habitProvider);

    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: habitState.when(
            loading: () =>
                const Center(child: CircularProgressIndicator()),
            error: (e, _) =>
                Center(child: Text(e.toString())),
            data: (habits) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  ProgressSection(habits: habits),
                  const SizedBox(height: 24),
                  const Text(
                    "Your Habits",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: HabitList(habits: habits),
                  ),
                  const SizedBox(height: 16),
                  const FinishButton(),
                  const SizedBox(height: 20),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class ProgressSection extends StatelessWidget {
  final List habits;

  const ProgressSection({super.key, required this.habits});

  @override
  Widget build(BuildContext context) {
    final total = habits.length;
    final completed =
        habits.where((h) => h.isCompleted).length;
    final progress =
        total == 0 ? 0.0 : completed / total;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey.shade300,
        ),
        const SizedBox(height: 8),
        Text(
          "$completed of $total completed",
          style:
              const TextStyle(fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class HabitList extends ConsumerWidget {
  final List habits;

  const HabitList({super.key, required this.habits});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (habits.isEmpty) {
      return const Center(
        child: Text("No habits yet"),
      );
    }

    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (context, index) {
        return HabitItem(habit: habits[index]);
      },
    );
  }
}

class HabitItem extends ConsumerWidget {
  final dynamic habit;

  const HabitItem({super.key, required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Checkbox(
          value: habit.isCompleted,
          onChanged: (_) {
            ref.read(habitProvider.notifier)
                .toggleHabit(habit.id);
          },
        ),
        title: Text(
          habit.title,
          style: TextStyle(
            decoration: habit.isCompleted
                ? TextDecoration.lineThrough
                : null,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            ref.read(habitProvider.notifier)
                .deleteHabit(habit.id);
          },
        ),
      ),
    );
  }
}

class FinishButton extends StatelessWidget {
  const FinishButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          padding:
              const EdgeInsets.symmetric(vertical: 14),
        ),
        onPressed: () {
          Navigator.pushReplacementNamed(
            context,
            '/homeMain',
          );
        },
        child: const Text(
          "Finish",
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}