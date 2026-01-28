import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mission_5_habbits/pages/home_page.dart';
import 'package:mission_5_habbits/pages/home_page2.dart';
import 'package:mission_5_habbits/pages/login_page.dart';
import 'package:mission_5_habbits/pages/user_page.dart';
import 'add_habit.dart'; // pastikan file ini ada

class HomePageMain extends StatefulWidget {
  const HomePageMain({super.key});

  @override
  State<HomePageMain> createState() => _HomePageMainState();
}

class _HomePageMainState extends State<HomePageMain> {
  int _selectedIndex = 0;

  // List untuk menyimpan habit
  List<Map<String, dynamic>> habits = [];

  // Navigasi bottom bar
  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      // Navigasi ke halaman LoginPage
      final newHabit = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }

    if (index == 2) {
      // Navigasi ke halaman LoginPage
      final newHabit = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const UserPage()),
      );
    }


      if (index == 1) {
        // Navigasi ke halaman AddHabitPage
        final newHabit = await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddHabitPage()),
        );

        if (newHabit != null && newHabit is Map<String, dynamic>) {
          setState(() {
            habits.add(newHabit);
          });
        }
      }
    }


  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    // Daftar nama hari (Senin = M)
    List<String> weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

    // Mulai minggu dari Senin
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));

    // List tanggal minggu ini
    List<int> weekDates =
    List.generate(7, (index) => startOfWeek.add(Duration(days: index)).day);

    // List bulan tiap tanggal (untuk menampilkan bulan saat tanggal berubah bulan)
    List<String> weekMonths =
    List.generate(7, (index) => DateFormat.MMM().format(startOfWeek.add(Duration(days: index))));

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // ===== HEADER =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Today',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${DateFormat.MMMM().format(now)} ${now.day}',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ===== HARI & TANGGAL =====
              Container(
                height: 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(7, (index) {
                    DateTime dayDate = startOfWeek.add(Duration(days: index));
                    bool isToday =
                        dayDate.day == now.day && dayDate.month == now.month;

                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 0),
                        decoration: BoxDecoration(
                          color: isToday ? Colors.blue : Colors.grey[200],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              weekDays[index],
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isToday ? Colors.white : Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${dayDate.day}',
                              style: TextStyle(
                                color: isToday ? Colors.white : Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 24),

              // ===== MY HABIT =====
              const Text(
                'My Habit',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // List My Habit
              Expanded(
                child: habits.isEmpty
                    ? const Center(child: Text('No habits yet'))
                    : ListView.builder(
                  itemCount: habits.length,
                  itemBuilder: (context, index) {
                    final habit = habits[index];

                    String dateStr = '';
                    if (habit['date'] is DateTime) {
                      dateStr = DateFormat.yMMMd().format(habit['date']);
                    }

                    String timeStr = '';
                    if (habit['time'] is TimeOfDay) {
                      timeStr = habit['time'].format(context);
                    }

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(habit['name'] ?? ''),
                        subtitle: Text('$dateStr, $timeStr'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      // ===== BOTTOM NAVIGATION =====
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