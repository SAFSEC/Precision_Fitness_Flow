import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/constants/app_colors.dart';
import '../../data/workout_plan.dart';
import '../../data/models/training_day.dart';
import '../../data/models/workout_step.dart';
import '../../core/providers/active_program_provider.dart';
import '../../core/services/history_service.dart';
import '../../data/models/workout_session.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeProgram = ref.watch(activeProgramProvider);
    final historyList = ref.watch(historyListProvider);

    final workoutDays = activeProgram.days.where((d) => d.type != 'rest').toList();
    final recentSessions = historyList.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Training', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/history'),
            tooltip: 'Trainingshistorie',
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Plan Selector
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
              child: _PlanChip(
                programTitle: activeProgram.title,
                onTap: () => _showPlanSelection(context, ref),
              ),
            ),
          ),

          // Section Header
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Text(
                'Workout wählen',
                style: TextStyle(
                  color: kColorText,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Workout Cards
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final day = workoutDays[index];
                  final tagNumber = _tagNumber(workoutDays, day);
                  return _WorkoutCard(day: day, tagNumber: tagNumber);
                },
                childCount: workoutDays.length,
              ),
            ),
          ),

          // Recent Sessions Header
          if (recentSessions.isNotEmpty) ...[
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Text(
                  'Zuletzt trainiert',
                  style: TextStyle(
                    color: kColorTextMuted,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _RecentSessionTile(
                    session: recentSessions[index],
                  ),
                  childCount: recentSessions.length,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Center(
                child: TextButton(
                  onPressed: () => context.push('/history'),
                  child: const Text(
                    'Alle anzeigen',
                    style: TextStyle(color: kColorTextMuted, fontSize: 13),
                  ),
                ),
              ),
            ),
          ],

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  int _tagNumber(List<TrainingDay> days, TrainingDay day) {
    final uniqueDays = days.map((d) => d.dayOfWeek ?? 0).toSet().toList()..sort();
    return uniqueDays.indexOf(day.dayOfWeek ?? 0) + 1;
  }

  void _showPlanSelection(BuildContext context, WidgetRef ref) {
    final activeProgram = ref.read(activeProgramProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: kColorSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Trainingsplan wählen',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: kColorText,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...kAllPrograms.map((program) {
                  final isActive = program.id == activeProgram.id;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24.0,
                      vertical: 4.0,
                    ),
                    leading: Text(
                      program.icon ?? '📋',
                      style: const TextStyle(fontSize: 24),
                    ),
                    title: Text(
                      program.title,
                      style: TextStyle(
                        color: isActive ? kColorAccent : kColorText,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text(
                      program.description,
                      style: const TextStyle(color: kColorTextMuted, fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: isActive
                        ? const Icon(Icons.check_circle, color: kColorAccent, size: 20)
                        : null,
                    onTap: () {
                      ref.read(activeProgramProvider.notifier).setProgram(program);
                      Navigator.pop(ctx);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PlanChip extends StatelessWidget {
  final String programTitle;
  final VoidCallback onTap;

  const _PlanChip({required this.programTitle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: kColorSurface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.fitness_center, size: 14, color: kColorAccent),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                programTitle,
                style: const TextStyle(
                  color: kColorTextMuted,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.expand_more, size: 16, color: kColorTextMuted),
          ],
        ),
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  final TrainingDay day;
  final int tagNumber;

  const _WorkoutCard({required this.day, required this.tagNumber});

  @override
  Widget build(BuildContext context) {
    final isHiit = day.type == 'hiit';
    final typeColor = isHiit ? kColorAccent : kColorWork;
    final typeLabel = isHiit ? 'HIIT' : 'Kraft';
    final typeIcon = isHiit ? Icons.bolt : Icons.fitness_center;
    final summary = _buildSummary(day.steps);
    final displayTitle = _replaceWeekday(day.title, tagNumber);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: kColorSurface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: InkWell(
        onTap: () => context.push('/workout/${day.id}'),
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(typeIcon, color: typeColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayTitle,
                      style: const TextStyle(
                        color: kColorText,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            typeLabel,
                            style: TextStyle(
                              color: typeColor,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          summary,
                          style: const TextStyle(
                            color: kColorTextMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => context.push('/workout/${day.id}'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: typeColor,
                  foregroundColor: kColorBackground,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Start',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const _weekdays = [
    'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag',
    'Freitag', 'Samstag', 'Sonntag',
  ];

  String _replaceWeekday(String title, int tagNum) {
    for (final day in _weekdays) {
      if (title.startsWith(day)) {
        return title.replaceFirst(day, 'Tag $tagNum');
      }
    }
    return title;
  }

  String _buildSummary(List<WorkoutStep> steps) {
    if (steps.isEmpty) return 'Keine Übungen';
    final uniqueExercises = steps.map((s) => s.exercise.id).toSet().length;
    final hasSets = steps.any((s) => s.sets != null && s.sets! > 0);
    if (hasSets) {
      final sets = steps.first.sets ?? 3;
      final reps = steps.first.reps ?? 0;
      return '$uniqueExercises Übungen · ${sets}×$reps Wdh';
    } else {
      return '$uniqueExercises Übungen · Intervall';
    }
  }
}

class _RecentSessionTile extends StatelessWidget {
  final WorkoutSession session;

  const _RecentSessionTile({required this.session});

  @override
  Widget build(BuildContext context) {
    final date = session.completedAt;
    final now = DateTime.now();
    final diff = now.difference(date);
    String dateLabel;
    if (diff.inDays == 0) {
      dateLabel = 'Heute';
    } else if (diff.inDays == 1) {
      dateLabel = 'Gestern';
    } else {
      dateLabel = '${date.day}.${date.month}.${date.year}';
    }

    final minutes = (session.durationSeconds / 60).round();
    final statusColor = session.completed ? kColorWork : kColorSafetyHint;

    // Try to find workout title from programs
    final title = _findWorkoutTitle(session.workoutId);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: kColorSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: statusColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(
            session.completed ? Icons.check_circle_outline : Icons.cancel_outlined,
            color: statusColor,
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(color: kColorText, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '$dateLabel · ${minutes}min',
            style: const TextStyle(color: kColorTextMuted, fontSize: 12),
          ),
        ],
      ),
    );
  }

  String _findWorkoutTitle(String workoutId) {
    for (final program in kAllPrograms) {
      for (final day in program.days) {
        if (day.id == workoutId) return day.title;
      }
    }
    return 'Workout';
  }
}
