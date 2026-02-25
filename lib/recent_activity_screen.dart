import 'package:flutter/material.dart';

class RecentActivityScreen extends StatelessWidget {
  const RecentActivityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recent Activity")),
      body: const Center(child: Text("No recent activity")),
    );
  }
}
