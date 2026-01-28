import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePageMain(),
    );
  }
}

class HomePageMain extends StatefulWidget {
  const HomePageMain({super.key});

  @override
  State<HomePageMain> createState() => _HomePageMainState();
}

class _HomePageMainState extends State<HomePageMain> {
  int _selectedIndex = 0;

  // Navigasi bottom bar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        // Navigasi ke halaman tambah habit
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddHabitPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String month = DateFormat.MMMM().format(now); // Nama bulan
    int day = now.day;

    // Buat daftar hari dan tanggal minggu ini
    List<String> weekDays = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    DateTime startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    List<int> weekDates = List.generate(7, (index) => startOfWeek.add(Duration(days: index)).day);

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
                    '$month $day',
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ===== HARI & TANGGAL =====
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 7,
                  itemBuilder: (context, index) {
                    bool isToday = weekDates[index] == now.day;
                    return Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
                            '${weekDates[index]}',
                            style: TextStyle(
                              color: isToday ? Colors.white : Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              // ===== MY HABBIT =====
              const Text(
                'My Habit',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Contoh list habit
              Expanded(
                child: ListView(
                  children: const [
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.check_circle_outline),
                        title: Text('Meditation'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.check_circle_outline),
                        title: Text('Reading'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.check_circle_outline),
                        title: Text('Exercise'),
                      ),
                    ),
                  ],
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

// ===== HALAMAN ADD HABBIT =====
class AddHabitPage extends StatelessWidget {
  const AddHabitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add New Habit')),
      body: const Center(
        child: Text('Halaman untuk menambahkan habit baru'),
      ),
    );
  }
}