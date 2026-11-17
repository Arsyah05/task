import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.task_alt,
                size: 72,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 16),
              Text('Task', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              const Text(
                'A simple app to manage your daily tasks.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              const Text('Created by Task Team'),
              const SizedBox(height: 4),
              const Text('Version 1.0.0'),
            ],
          ),
        ),
      ),
    );
  }
}
