import 'package:flutter/material.dart';

class PartsListPage extends StatelessWidget {
  const PartsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Parts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Parts List Page',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

