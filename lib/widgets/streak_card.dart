import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class StreakCard extends StatelessWidget {
  final int currentStreak;
  final int totalCompleted;

  const StreakCard({
    super.key,
    required this.currentStreak,
    required this.totalCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kColorSurface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: kColorAccent.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Row(
          children: [
            _buildStatItem(
              icon: Icons.local_fire_department,
              iconColor: kColorAccent,
              value: '$currentStreak',
              label: 'Aktueller Streak',
            ),
            Container(
              height: 40,
              width: 1,
              color: kColorTextMuted.withOpacity(0.3),
              margin: const EdgeInsets.symmetric(horizontal: 24),
            ),
            _buildStatItem(
              icon: Icons.check_circle_outline,
              iconColor: kColorWork,
              value: '$totalCompleted',
              label: 'Workouts gesamt',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 8),
              Text(
                value,
                style: const TextStyle(
                  color: kColorText,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: kColorTextMuted,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
