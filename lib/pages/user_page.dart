import 'package:flutter/material.dart';
import '../main.dart'; // untuk akses themeNotifier

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  bool get isDarkMode => themeNotifier.value == ThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (val) {
                  themeNotifier.value =
                  val ? ThemeMode.dark : ThemeMode.light;
                  setState(() {}); // agar toggle langsung update
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}