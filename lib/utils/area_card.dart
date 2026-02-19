import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lightsout/pages/theme.dart';

class MyArea extends StatefulWidget {
  final String area;
  final List<int> powerOffTimes;
  final String feeder;
  final int stage;
  final Gradient gradient;
  final bool isFavorite;
  final VoidCallback? onFavoriteToggle;

  const MyArea({
    Key? key,
    required this.area,
    required this.powerOffTimes,
    required this.feeder,
    required this.stage,
    required this.gradient,
    this.isFavorite = false,
    this.onFavoriteToggle,
  }) : super(key: key);

  @override
  State<MyArea> createState() => _MyAreaState();
}

class _MyAreaState extends State<MyArea> {
  late List<bool> _powerStatus;
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
    _powerStatus = List.filled(24, true);
    _updatePowerStatus();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      _updatePowerStatus();
    });
  }

  void _updatePowerStatus() {
    setState(() {
      for (int i = 0; i < 24; i++) {
        _powerStatus[i] = !widget.powerOffTimes.contains(i);
      }
    });
  }

  String _nextOutageLabel() {
    final nowHour = DateTime.now().hour;
    int? next;

    for (final hour in widget.powerOffTimes) {
      if (hour >= nowHour) {
        next = hour;
        break;
      }
    }

    next ??= widget.powerOffTimes.isNotEmpty ? widget.powerOffTimes.first + 24 : null;

    if (next == null) {
      return 'No outage slots';
    }

    final diff = next - nowHour;
    if (diff <= 0) {
      return 'Outage in progress';
    }
    return 'Next outage in ${diff}h';
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '${widget.area}, feeder ${widget.feeder}, stage ${widget.stage}',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SizedBox(
          width: 300,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: widget.gradient,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 24,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0x4DFFFFFF)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.area,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap: widget.onFavoriteToggle,
                            borderRadius: BorderRadius.circular(999),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.18),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                widget.isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.18),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Image.asset(
                              'lib/icons/byo.png',
                              height: 28,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                    children: [
                      Expanded(
                        child: Text(
                          widget.area,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Image.asset(
                          'lib/icons/byo.png',
                          height: 28,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.16),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'Live',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 11,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _nextOutageLabel(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.16),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(12, (index) {
                        return Container(
                          width: 14,
                          height: 8,
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          decoration: BoxDecoration(
                            color: _powerStatus[index]
                                ? const Color(0xFFD3FFEC)
                                : const Color(0xFFFFD8DE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.16),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                'lib/icons/transformers.png',
                                height: 18,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.feeder,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getStageColor(widget.stage),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'Stage ${widget.stage}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SizedBox(
        width: 300,
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: widget.gradient,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x26000000),
                blurRadius: 24,
                offset: Offset(0, 12),
              ),
            ],
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0x4DFFFFFF)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.area,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.4,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.asset(
                        'lib/icons/byo.png',
                        height: 28,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(12, (index) {
                      return Container(
                        width: 14,
                        height: 8,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: _powerStatus[index]
                              ? const Color(0xFFD3FFEC)
                              : const Color(0xFFFFD8DE),
                          borderRadius: BorderRadius.circular(20),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.16),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              'lib/icons/transformers.png',
                              height: 18,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.feeder,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStageColor(widget.stage),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        'Stage ${widget.stage}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getStageColor(int stage) {
    switch (stage) {
      case 1:
        return RiveAppTheme.success;
      case 2:
        return RiveAppTheme.warning;
      case 3:
        return RiveAppTheme.danger;
      default:
        return RiveAppTheme.textSecondary;
      case 2:
        return RiveAppTheme.warning;
      case 3:
        return RiveAppTheme.danger;
      default:
        return RiveAppTheme.textSecondary;
      case 2:
        return RiveAppTheme.warning;
      case 3:
        return RiveAppTheme.danger;
      default:
        return RiveAppTheme.textSecondary;
        return const Color(0xFF34C759);
      case 2:
        return const Color(0xFFFF9F0A);
      case 3:
        return const Color(0xFFFF453A);
      default:
        return const Color(0xFF8E8E93);
    }
  }
}
