import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/habit_provider.dart';
import 'package:mission_5_habbits/pages/user_page.dart';

class HomePageMain extends ConsumerStatefulWidget {
  const HomePageMain({super.key});

  @override
  ConsumerState<HomePageMain> createState() => _HomePageMainState();
}

class _HomePageMainState extends ConsumerState<HomePageMain> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {
      _showAddDialog();
      return;
    }

    //{Inline Review: Untuk konsistensi arsitektur, index navigasi bisa disimpan di provider sederhana.}
    setState(() {
      _selectedIndex = index;
    });
  }

  void _showAddDialog() {
    final controller = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Tambah Habit"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Masukkan nama habit",
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text(selectedDate == null
                    ? "Select Date"
                    : DateFormat.yMMMMd().format(selectedDate!)),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final now = DateTime.now();
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate ?? now,
                    firstDate: now,
                    lastDate: DateTime(now.year + 5),
                  );
                  if (date != null) setState(() => selectedDate = date);
                },
              ),
              ListTile(
                title: Text(selectedTime == null
                    ? "Select Time"
                    : selectedTime!.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime ?? TimeOfDay.now(),
                  );
                  if (time != null) setState(() => selectedTime = time);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final text = controller.text.trim();
                if (text.isEmpty || selectedDate == null || selectedTime == null) {
                  return;
                }

                final success = await ref.read(habitProvider.notifier).addHabitWithDateTime(
                  title: text,
                  date: selectedDate!,
                  hour: selectedTime!.hour,
                  minute: selectedTime!.minute,
                );

                if (success) {
                  Navigator.pop(context);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("$text added!")),
                    );
                  }
                } else {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Habit already exists")),
                    );
                  }
                }
              },
              child: const Text("Tambah"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const _HomeContent(),
      const SizedBox(),
      const UserPage(),
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Add',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'User',
          ),
        ],
      ),
    );
  }
}

/// HOME CONTENT
class _HomeContent extends ConsumerWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitProvider);
    DateTime now = DateTime.now();
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black),
                    children: [
                      const TextSpan(
                        text: 'Today,\n',
                        style: TextStyle(fontSize: 16),
                      ),
                      TextSpan(
                        text: DateFormat('MMMM d').format(now),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.person_outline, size: 28),
              ],
            ),

            const SizedBox(height: 24),

            /// WEEK CALENDAR
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(7, (index) {
                final day = startOfWeek.add(Duration(days: index));
                final isToday = day.day == now.day && day.month == now.month;

                return Column(
                  children: [
                    Text(
                      DateFormat('E').format(day)[0],
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 34,
                      height: 34,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isToday ? Colors.black : Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '${day.day}',
                        style: TextStyle(
                          color: isToday ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),

            const SizedBox(height: 32),

            const Text(
              'My Habit',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            /// HABIT LIST
            Expanded(
              child: habitsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("Error: $e")),
                data: (habits) {
                  if (habits.isEmpty) {
                    return const Center(
                      child: Text(
                        'No habits yet ✨',
                        style: TextStyle(color: Colors.black54),
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: habits.length,
                    separatorBuilder: (_, __) => Divider(color: Colors.grey.shade500),
                    itemBuilder: (context, index) {
                      final habit = habits[index];

                      return ListTile(
                        title: Text(habit.title),
                        leading: Checkbox(
                          value: habit.isCompleted,
                          onChanged: (_) {
                            ref.read(habitProvider.notifier).toggleHabit(habit.id);
                          },
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            /// EDIT BUTTON
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () {
                                _showEditDialog(context, ref, habit);
                              },
                            ),

                            /// DELETE BUTTON
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () {
                                ref.read(habitProvider.notifier).deleteHabit(habit.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showEditDialog(
      BuildContext context,
      WidgetRef ref,
      dynamic habit,
      ) {
    final controller = TextEditingController(text: habit.title);
    DateTime selectedDate = habit.date;
    TimeOfDay selectedTime =
    TimeOfDay(hour: habit.hour, minute: habit.minute);

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text("Edit Habit"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Edit nama habit",
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                title: Text(
                  DateFormat.yMMMMd().format(selectedDate),
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final now = DateTime.now();
                  final date = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: now.subtract(const Duration(days: 365)),
                    lastDate: DateTime(now.year + 5),
                  );
                  if (date != null) {
                    setState(() => selectedDate = date);
                  }
                },
              ),
              ListTile(
                title: Text(selectedTime.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: selectedTime,
                  );
                  if (time != null) {
                    setState(() => selectedTime = time);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final newTitle = controller.text.trim();
                if (newTitle.isEmpty) return;

                await ref.read(habitProvider.notifier).editHabit(
                  id: habit.id,
                  newTitle: newTitle,
                  newDate: selectedDate,
                  newHour: selectedTime.hour,
                  newMinute: selectedTime.minute,
                );

                if (context.mounted) Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
