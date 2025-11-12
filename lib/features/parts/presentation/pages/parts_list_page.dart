import 'package:flutter/material.dart';
import 'package:vehicle_part_app/shared/widgets/bottom_app_bar_v2_floating.dart';
import 'package:vehicle_part_app/l10n/app_localizations.dart';

class PartsListPage extends StatelessWidget {
  const PartsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.products),
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
      bottomNavigationBar: const AppBottomNavigationBarV2Floating(),
    );
  }
}

