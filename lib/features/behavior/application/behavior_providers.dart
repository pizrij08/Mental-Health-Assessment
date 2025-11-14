import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BehaviorDashboardData {
  BehaviorDashboardData({required this.trend, required this.currentMood, required this.shortcuts});

  final List<FlSpot> trend;
  final String currentMood;
  final List<BehaviorShortcut> shortcuts;
}

class BehaviorShortcut {
  const BehaviorShortcut({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

final behaviorDashboardProvider = Provider<BehaviorDashboardData>((ref) {
  return BehaviorDashboardData(
    trend: const [
      FlSpot(0, 2),
      FlSpot(1, 3),
      FlSpot(2, 1),
      FlSpot(3, 4),
      FlSpot(4, 2),
      FlSpot(5, 3),
      FlSpot(6, 5),
    ],
    currentMood: '😊 Calm & Focused',
    shortcuts: const [
      BehaviorShortcut(icon: Icons.bar_chart, label: 'Weekly Report'),
      BehaviorShortcut(icon: Icons.psychology, label: 'AI Insights'),
    ],
  );
});
