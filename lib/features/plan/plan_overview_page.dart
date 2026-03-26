import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../core/providers/active_program_provider.dart';
import '../home/home_controller.dart';
import '../../data/models/training_day.dart';

class PlanOverviewPage extends ConsumerWidget {
  const PlanOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);
    final activeProgram = ref.watch(activeProgramProvider);
    final maxWeek = activeProgram.days.fold(0, (int max, day) => day.week > max ? day.week : max);

    return Scaffold(
      appBar: AppBar(
        title: Text(activeProgram.title, style: const TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: maxWeek == 0 ? 1 : maxWeek, 
        itemBuilder: (context, weekIndex) {
          final weekNum = weekIndex + 1;
          final weekDays = activeProgram.days.where((d) => d.week == weekNum).toList();
          
          // Group by dayOfWeek
          final groupedDays = <int?, List<TrainingDay>>{};
          for (final d in weekDays) {
            groupedDays.putIfAbsent(d.dayOfWeek, () => []).add(d);
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 16),
                child: Text(
                  'Woche $weekNum',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: kColorText,
                  ),
                ),
              ),
              ...groupedDays.entries.map((entry) {
                 final dayNum = entry.key;
                 final options = entry.value;

                 return Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     if (dayNum != null)
                       Padding(
                         padding: const EdgeInsets.only(top: 8, bottom: 4, left: 4),
                         child: Text(
                           'Tag $dayNum',
                           style: const TextStyle(
                             color: kColorTextMuted,
                             fontWeight: FontWeight.bold,
                             fontSize: 14,
                             letterSpacing: 1.2,
                           ),
                         ),
                       ),
                     ...options.map((day) {
                        final isCompleted = state.completedIds.contains(day.id);
                        final isActive = day.id == state.activeDay.id;
                        
                        // Icon mapping
                        IconData leadingIcon = Icons.fitness_center;
                        Color iconColor = kColorWork;
                        
                        if (day.type == 'strength') {
                          leadingIcon = Icons.fitness_center;
                          iconColor = kColorWork;
                        } else if (day.type == 'hiit') {
                          leadingIcon = Icons.timer;
                          iconColor = kColorAccent;
                        } else if (day.type == 'rest') {
                          leadingIcon = Icons.self_improvement;
                          iconColor = kColorRest;
                        }

                        if (isCompleted) {
                          iconColor = kColorTextMuted;
                        }

                        return Card(
                          color: isCompleted ? Colors.black26 : kColorSurface,
                          margin: const EdgeInsets.only(bottom: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: isActive ? kColorAccent : Colors.transparent,
                              width: 1,
                            ),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            onTap: () {
                              context.push('/plan/day/${day.id}');
                            },
                            leading: CircleAvatar(
                              backgroundColor: iconColor.withOpacity(0.2),
                              child: Icon(leadingIcon, color: iconColor, size: 20),
                            ),
                            title: Text(
                              day.optionLabel ?? day.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isCompleted ? kColorTextMuted : kColorText,
                                decoration: isCompleted ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            subtitle: Text(
                              day.steps.isNotEmpty ? '${day.steps.length} Übungen' : 'Stretching / Erholung',
                              style: const TextStyle(color: kColorTextMuted),
                            ),
                            trailing: isCompleted
                                ? const Icon(Icons.check_circle, color: kColorWork)
                                : const Icon(Icons.chevron_right, color: kColorTextMuted),
                          ),
                        );
                     }),
                   ],
                 );
              }),
            ],
          );
        },
      ),
    );
  }
}
