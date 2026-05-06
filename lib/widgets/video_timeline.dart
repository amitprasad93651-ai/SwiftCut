import 'package:flutter/material.dart';

class VideoTimeline extends StatelessWidget {
  const VideoTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      color: Colors.black12,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 10,
        itemBuilder: (context, idx) {
          return Container(
            width: 40,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            color: Colors.deepOrange.withOpacity(0.1 * (idx % 5 + 1)),
          );
        },
      ),
    );
  }
}
