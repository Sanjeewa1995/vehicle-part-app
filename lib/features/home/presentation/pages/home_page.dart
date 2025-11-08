import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Parts'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Vehicle Parts App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => context.go('/parts'),
              child: const Text('Browse Parts'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/cart'),
              child: const Text('View Cart'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/orders'),
              child: const Text('My Orders'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/profile'),
              child: const Text('Profile'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/payment'),
              child: const Text('Payment'),
            ),
          ],
        ),
      ),
    );
  }
}

