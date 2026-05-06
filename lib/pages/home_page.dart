import 'package:flutter/material.dart';
import '../widgets/made_in_india_badge.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('SwiftCut')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Welcome to SwiftCut!', style: TextStyle(fontSize: 24)),
            SizedBox(height: 20),
            MadeInIndiaBadge(),
          ],
        ),
      ),
    );
  }
}
