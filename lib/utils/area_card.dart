import 'package:flutter/material.dart';
import 'dart:async';

class MyArea extends StatefulWidget {
  final String area;
  final List<int> powerOffTimes; // List of hours when power is off
  final String feeder;
  final int stage;
  final Gradient gradient; // Updated to accept Gradient instead of Color

  const MyArea({
    Key? key,
    required this.area,
    required this.powerOffTimes,
    required this.feeder,
    required this.stage,
    required this.gradient, // Updated to accept Gradient
  }) : super(key: key);

  @override
  _MyAreaState createState() => _MyAreaState();
}

class _MyAreaState extends State<MyArea> {
  late List<bool> _powerStatus; // Power status for each hour in a day
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _initializePowerStatus();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _initializePowerStatus() {
    _powerStatus = List.filled(24, true); // Initialize all hours with power on
    _updatePowerStatus(); // Initial update based on current time
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _updatePowerStatus();
    });
  }

  void _updatePowerStatus() {
    final now = DateTime.now();
    setState(() {
      // Update power status based on current time and power off times
      for (int i = 0; i < 24; i++) {
        _powerStatus[i] = !widget.powerOffTimes.contains(i);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SizedBox(
        width: 300, // Fixed width for the box
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: widget.gradient, // Use gradient instead of color
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.area,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset(
                    'lib/icons/byo.png',
                    height: 50,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 30,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(12, (index) {
                      return Container(
                        width: 13,
                        height: 8,
                        decoration: BoxDecoration(
                          color:
                              _powerStatus[index] ? Colors.green : Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'lib/icons/transformers.png',
                        height: 30,
                      ),
                      Text(
                        widget.feeder,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _getStageColor(widget.stage),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Stage ${widget.stage}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStageColor(int stage) {
    switch (stage) {
      case 1:
        return Colors.green;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
