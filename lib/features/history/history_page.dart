import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/history_service.dart';
import '../../core/services/motivation_service.dart';
import '../../core/utils/duration_formatter.dart';
import '../../widgets/streak_card.dart';
import '../../widgets/workout_heatmap_widget.dart';
import '../../widgets/badges_section.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyList = ref.watch(historyListProvider);
    final stats = ref.watch(motivationStatsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trainingshistorie', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          // Motivation Header (Always visible)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                children: [
                  StreakCard(
                    currentStreak: stats.currentStreak,
                    totalCompleted: stats.totalCompleted,
                  ),
                  const SizedBox(height: 16),
                  WorkoutHeatmapWidget(activeDays: stats.activeDays),
                  const SizedBox(height: 16),
                  const BadgesSection(),
                  const Divider(color: kColorTextMuted, thickness: 0.1),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),

          // History List or Empty Message
          if (historyList.isEmpty)
            const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    'Noch keine abgeschlossenen Trainings.',
                    style: TextStyle(color: kColorTextMuted, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final session = historyList[index];
                  
                  final isCompleted = session.completed;
                  final statusColor = isCompleted ? kColorWork : kColorSafetyHint;
                  final statusIcon = isCompleted ? Icons.check_circle : Icons.cancel;
                  final statusText = isCompleted ? 'Erfolgreich' : 'Abgebrochen';

                  // Format Date: DD.MM.YYYY HH:mm
                  final date = session.completedAt;
                  final dateStr = '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year} '
                                  '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Card(
                      color: kColorSurface,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: statusColor.withOpacity(0.3)),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: statusColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(statusIcon, color: statusColor, size: 28),
                        ),
                        title: Text(
                          'Woche ${session.week} – Tag ${session.dayOfWeek}',
                          style: const TextStyle(
                            color: kColorText,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today, size: 14, color: kColorTextMuted),
                                  const SizedBox(width: 6),
                                  Text(dateStr, style: const TextStyle(color: kColorTextMuted, fontSize: 13)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(Icons.timer_outlined, size: 14, color: kColorTextMuted),
                                  const SizedBox(width: 6),
                                  Text(formatDuration(session.durationSeconds), style: const TextStyle(color: kColorTextMuted, fontSize: 13)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              statusText,
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: historyList.length,
              ),
            ),
        ],
      ),
    );
    );
  }
}
