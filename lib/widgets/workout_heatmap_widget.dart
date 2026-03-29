import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class WorkoutHeatmapWidget extends StatelessWidget {
  final Map<DateTime, bool> activeDays;
  final int weekCount;

  const WorkoutHeatmapWidget({
    super.key,
    required this.activeDays,
    this.weekCount = 16,
  });

  @override
  Widget build(BuildContext context) {
    // Current date to start the grid
    final today = DateTime.now();
    // Monday of the current week
    final mondayThisWeek = today.subtract(Duration(days: today.weekday - 1));
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: Text(
            'Aktivitätsverlauf',
            style: TextStyle(
              color: kColorText,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 130, // 7 days * (size + spacing) + labels
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            reverse: true, // Newest on the right
            itemCount: weekCount,
            itemBuilder: (context, weekIndex) {
              // Calculate the start of this specific week (mondayIndex weeks ago)
              final weekStart = mondayThisWeek.subtract(Duration(days: weekIndex * 7));
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Column(
                  children: List.generate(7, (dayIndex) {
                    final dayDate = weekStart.add(Duration(days: dayIndex));
                    final dateOnly = DateTime(dayDate.year, dayDate.month, dayDate.day);
                    final isActive = activeDays.containsKey(dateOnly);
                    final isFuture = dayDate.isAfter(today);

                    return Container(
                      width: 14,
                      height: 14,
                      margin: const EdgeInsets.symmetric(vertical: 2.0),
                      decoration: BoxDecoration(
                        color: isFuture 
                            ? Colors.transparent 
                            : (isActive ? kColorWork : kColorSurface),
                        borderRadius: BorderRadius.circular(3),
                        border: isFuture ? null : Border.all(
                          color: isActive ? kColorWork.withOpacity(0.5) : kColorTextMuted.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text('Weniger', style: TextStyle(color: kColorTextMuted, fontSize: 10)),
              SizedBox(width: 4),
              _LegendSquare(color: kColorSurface),
              SizedBox(width: 2),
              _LegendSquare(color: kColorWork),
              SizedBox(width: 4),
              Text('Mehr', style: TextStyle(color: kColorTextMuted, fontSize: 10)),
            ],
          ),
        ),
      ],
    );
  }
}

class _LegendSquare extends StatelessWidget {
  final Color color;
  const _LegendSquare({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
