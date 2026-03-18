import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../data/workout_plan.dart';
import '../home/home_controller.dart';

class PlanOverviewPage extends ConsumerWidget {
  const PlanOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homeControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('3-Wochen-Plan', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemCount: 3, // 3 Weeks
        itemBuilder: (context, weekIndex) {
          final weekNum = weekIndex + 1;
          final weekDays = kWorkoutPlan.where((d) => d.week == weekNum).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 24, bottom: 12, left: 8),
                child: Text(
                  'Woche $weekNum',
                  style: const TextStyle(
                    color: kColorText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ...weekDays.map((day) {
                final isCompleted = state.completedIds.contains(day.id);
                final isActive = state.activeDay.id == day.id;

                String typeLabel = '';
                Color iconColor = kColorWork;
                IconData listIcon = Icons.fitness_center;

                if (day.type == 'strengthA') {
                  typeLabel = 'Kraft-Tag A';
                } else if (day.type == 'strengthB') {
                  typeLabel = 'Kraft-Tag B';
                } else if (day.type == 'hiit') {
                  typeLabel = 'HIIT Flow';
                  iconColor = kColorAccent;
                  listIcon = Icons.timer;
                } else {
                  typeLabel = 'Regeneration';
                  iconColor = kColorRest;
                  listIcon = Icons.self_improvement;
                }

                return Card(
                  color: isActive ? kColorSurface : Colors.transparent,
                  margin: const EdgeInsets.only(bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isActive 
                        ? kColorAccent.withOpacity(0.5) 
                        : Colors.white12,
                    ),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: isCompleted ? Colors.transparent : iconColor.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: isCompleted ? Border.all(color: kColorWork) : null,
                      ),
                      child: Icon(
                        isCompleted ? Icons.check : listIcon,
                        color: isCompleted ? kColorWork : iconColor,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      'Tag ${day.dayOfWeek} – $typeLabel',
                      style: TextStyle(
                        color: isCompleted ? kColorTextMuted : kColorText,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      day.exercises.isNotEmpty ? '${day.exercises.length} Übungen' : 'Stretching / Erholung',
                      style: const TextStyle(color: kColorTextMuted),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: kColorTextMuted),
                    onTap: () {
                      context.push('/plan/${day.id}');
                    },
                  ),
                );
              }).toList(),
            ],
          );
        },
      ),
    );
  }
}
