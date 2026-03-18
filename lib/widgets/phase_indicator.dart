import 'package:flutter/material.dart';
import '../data/models/timer_state.dart';
import '../core/constants/app_colors.dart';

class PhaseIndicator extends StatelessWidget {
  final TimerPhase phase;

  const PhaseIndicator({super.key, required this.phase});

  @override
  Widget build(BuildContext context) {
    String text;
    Color color;

    switch (phase) {
      case TimerPhase.work:
        text = 'WORK';
        color = kColorWork;
        break;
      case TimerPhase.rest:
        text = 'REST';
        color = kColorRest;
        break;
      case TimerPhase.transition:
        text = 'PREPARE';
        color = kColorTransition;
        break;
      case TimerPhase.completed:
        text = 'DONE';
        color = kColorAccent;
        break;
      case TimerPhase.idle:
      default:
        text = 'READY';
        color = kColorTextMuted;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 2),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
