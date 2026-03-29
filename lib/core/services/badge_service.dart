import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'motivation_service.dart';

enum BadgeTier { bronze, silver, gold }

class Badge {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final BadgeTier tier;
  final String category;

  Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.tier,
    required this.category,
  });

  String get key => '${category}_${tier.name}';
}

final badgeServiceProvider = StateNotifierProvider<BadgeService, List<Badge>>((ref) {
  final stats = ref.watch(motivationStatsProvider);
  return BadgeService(stats);
});

class BadgeService extends StateNotifier<List<Badge>> {
  final MotivationStats _stats;
  final Box<String> _box = Hive.box<String>('badges');

  BadgeService(this._stats) : super([]) {
    _init();
  }

  void _init() {
    _checkUnlocks();
    _loadBadges();
  }

  void _checkUnlocks() {
    // 1. Streaks
    if (_stats.currentStreak >= 30) _unlock('streak', BadgeTier.gold);
    if (_stats.currentStreak >= 14) _unlock('streak', BadgeTier.silver);
    if (_stats.currentStreak >= 7) _unlock('streak', BadgeTier.bronze);

    // 2. HIIT
    if (_stats.hiitCompleted >= 50) _unlock('hiit', BadgeTier.gold);
    if (_stats.hiitCompleted >= 25) _unlock('hiit', BadgeTier.silver);
    if (_stats.hiitCompleted >= 5) _unlock('hiit', BadgeTier.bronze);

    // 3. Strength
    if (_stats.strengthCompleted >= 50) _unlock('strength', BadgeTier.gold);
    if (_stats.strengthCompleted >= 25) _unlock('strength', BadgeTier.silver);
    if (_stats.strengthCompleted >= 5) _unlock('strength', BadgeTier.bronze);

    // 4. Total
    if (_stats.totalCompleted >= 100) _unlock('total', BadgeTier.gold);
    if (_stats.totalCompleted >= 50) _unlock('total', BadgeTier.silver);
    if (_stats.totalCompleted >= 10) _unlock('total', BadgeTier.bronze);
  }

  void _unlock(String category, BadgeTier tier) {
    final key = '${category}_${tier.name}';
    if (!_box.containsKey(key)) {
      _box.put(key, DateTime.now().toIso8601String());
    }
  }

  void _loadBadges() {
    final unlocked = <Badge>[];
    
    // Streak Badges
    _addIfUnlocked(unlocked, 'streak', BadgeTier.gold, 'Streak-Legende', '30 Tage am Stück trainiert', Icons.local_fire_department);
    _addIfUnlocked(unlocked, 'streak', BadgeTier.silver, 'Streak-Profi', '14 Tage am Stück trainiert', Icons.local_fire_department);
    _addIfUnlocked(unlocked, 'streak', BadgeTier.bronze, 'Durchbeißer', '7 Tage am Stück trainiert', Icons.local_fire_department);

    // HIIT Badges
    _addIfUnlocked(unlocked, 'hiit', BadgeTier.gold, 'HIIT-Gott', '50 HIIT Einheiten absolviert', Icons.bolt);
    _addIfUnlocked(unlocked, 'hiit', BadgeTier.silver, 'HIIT-Meister', '25 HIIT Einheiten absolviert', Icons.bolt);
    _addIfUnlocked(unlocked, 'hiit', BadgeTier.bronze, 'HIIT-Starter', '5 HIIT Einheiten absolviert', Icons.bolt);

    // Strength Badges
    _addIfUnlocked(unlocked, 'strength', BadgeTier.gold, 'Titan', '50 Kraft Einheiten absolviert', Icons.fitness_center);
    _addIfUnlocked(unlocked, 'strength', BadgeTier.silver, 'Kraft-Paket', '25 Kraft Einheiten absolviert', Icons.fitness_center);
    _addIfUnlocked(unlocked, 'strength', BadgeTier.bronze, 'Starker Anfang', '5 Kraft Einheiten absolviert', Icons.fitness_center);

    // Total Badges
    _addIfUnlocked(unlocked, 'total', BadgeTier.gold, 'Legendenstatus', '100 Workouts insgesamt', Icons.emoji_events);
    _addIfUnlocked(unlocked, 'total', BadgeTier.silver, 'Gewohnheitstier', '50 Workouts insgesamt', Icons.emoji_events);
    _addIfUnlocked(unlocked, 'total', BadgeTier.bronze, 'Erster Schritt', '10 Workouts insgesamt', Icons.emoji_events);

    state = unlocked;
  }

  void _addIfUnlocked(List<Badge> list, String category, BadgeTier tier, String name, String desc, IconData icon) {
    final key = '${category}_${tier.name}';
    if (_box.containsKey(key)) {
      list.add(Badge(
        id: key,
        name: name,
        description: desc,
        icon: icon,
        tier: tier,
        category: category,
      ));
    }
  }
}
