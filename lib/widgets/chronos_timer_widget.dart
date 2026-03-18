import 'package:flutter/material.dart';
import '../../data/models/timer_state.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/duration_formatter.dart';
import 'dart:math';

class ChronosTimerWidget extends StatelessWidget {
  final TimerState timerState;
  final int maxSeconds;

  const ChronosTimerWidget({
    super.key,
    required this.timerState,
    required this.maxSeconds,
  });

  @override
  Widget build(BuildContext context) {
    // Determine color based on phase
    Color progressColor;
    switch (timerState.phase) {
      case TimerPhase.work:
        progressColor = kColorWork;
        break;
      case TimerPhase.rest:
        progressColor = kColorRest;
        break;
      case TimerPhase.transition:
        progressColor = kColorTransition;
        break;
      case TimerPhase.completed:
      case TimerPhase.idle:
      default:
        progressColor = kColorTextMuted;
    }

    final double progress = maxSeconds > 0 
        ? timerState.remainingSeconds / maxSeconds 
        : 0.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Use 65% of screen width as per CLAUDE.md
        final double size = MediaQuery.of(context).size.width * 0.65;
        // Cap the size for larger screens (web/tablet)
        final double finalSize = min(size, 350.0);

        return SizedBox(
          width: finalSize,
          height: finalSize,
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              // Background Ring
              CircularProgressIndicator(
                value: 1.0,
                strokeWidth: 12,
                color: kColorSurface,
              ),
              // Foreground Progress Ring
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 12,
                color: progressColor,
                backgroundColor: Colors.transparent,
              ),
              // Centered Text
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatDuration(timerState.remainingSeconds),
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: kColorText,
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
