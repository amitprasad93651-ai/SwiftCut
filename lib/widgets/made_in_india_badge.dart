import 'package:flutter/material.dart';

class MadeInIndiaBadge extends StatelessWidget {
  final double size;
  const MadeInIndiaBadge({this.size = 48, super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.flag, color: Colors.deepOrange, size: size * 0.8),
        const SizedBox(width: 8),
        Text('Made in 🇮🇳 India', style: TextStyle(fontSize: size / 2.5, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
