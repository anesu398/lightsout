import 'package:flutter/material.dart';
import 'package:lightsout/pages/details.dart';
import 'package:lightsout/utils/stage_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void _navigateToDetails(BuildContext context, String location, int stage,
      String time, Color backgroundColor) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailPage(
          area: location,
          feeder: time,
          stage: stage,
          gradient: LinearGradient(
            colors: [backgroundColor, backgroundColor.withOpacity(0.5)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.5, 1.0],
          ),
          powerOffTimes: [1, 2, 3], // Replace with actual times as needed
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loadshedding Schedule'),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          LoadsheddingBox(
            stage: 'Stage 1',
            location: 'Khumalo',
            time: '08:00 - 10:30',
            backgroundColor: Colors.yellow[100]!,
            onTap: () => _navigateToDetails(
              context,
              'Khumalo',
              1,
              '08:00 - 10:30',
              Colors.yellow[100]!,
            ),
          ),
          LoadsheddingBox(
            stage: 'Stage 2',
            location: 'Ascot',
            time: '08:00 - 10:30',
            backgroundColor: Colors.orange[100]!,
            onTap: () => _navigateToDetails(
              context,
              'Ascot',
              2,
              '08:00 - 10:30',
              Colors.orange[100]!,
            ),
          ),
          // Add more boxes here as needed...
        ],
      ),
    );
  }
}
