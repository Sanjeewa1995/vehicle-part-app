import 'package:flutter/material.dart';
import 'package:vehicle_part_app/shared/widgets/bottom_app_bar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: const Center(
        child: Text(
          'Profile Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
      bottomNavigationBar: const AppBottomNavigationBar(),
    );
  }
}

