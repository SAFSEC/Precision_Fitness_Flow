import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class WeekProgressBar extends StatelessWidget {
  final int currentWeek;
  final List<String> completedIds;

  const WeekProgressBar({
    super.key,
    required this.currentWeek,
    required this.completedIds,
  });

  @override
  Widget build(BuildContext context) {
    const days = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
      decoration: BoxDecoration(
        color: kColorSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Woche $currentWeek Fortschritt',
            style: const TextStyle(
              color: kColorText,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final dayNum = index + 1;
              final dayId = 'w${currentWeek}d$dayNum';
              final isCompleted = completedIds.contains(dayId);

              // Mi (Tag 4) und So (Tag 7) sind Rest-Tage
              final isRestDay = dayNum == 4 || dayNum == 7;

              return Column(
                children: [
                  Text(
                    days[index],
                    style: TextStyle(
                      color: isCompleted ? kColorText : kColorTextMuted,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? kColorWork
                          : (isRestDay ? Colors.transparent : Colors.black26),
                      border: isRestDay && !isCompleted
                          ? Border.all(color: kColorTextMuted)
                          : null,
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(Icons.check, color: Colors.white, size: 16)
                          : (isRestDay
                              ? const Icon(Icons.self_improvement, color: kColorTextMuted, size: 16)
                              : Text(
                                  '$dayNum',
                                  style: const TextStyle(
                                    color: kColorTextMuted,
                                    fontSize: 12,
                                  ),
                                )),
                    ),
                  )
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}
