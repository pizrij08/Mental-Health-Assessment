import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_application_mhproj/design_system/tokens/color_tokens.dart';
import 'package:flutter_application_mhproj/design_system/tokens/typography.dart';

import '../application/behavior_providers.dart';

class BehaviorTrackerPage extends ConsumerWidget {
  static const routeName = '/behavior';

  final ValueChanged<bool> onThemeChanged;
  final bool isDarkMode;

  const BehaviorTrackerPage({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboard = ref.watch(behaviorDashboardProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Behavior Tracker"),
        actions: [
          // 风险提醒
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.redAccent),
            tooltip: "Risk Alerts",
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("No new risk alerts.")),
              );
            },
          ),
          // 紧急联系人
          IconButton(
            icon: const Icon(Icons.phone_in_talk, color: Colors.green),
            tooltip: "Emergency Contact",
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Calling emergency contact...")),
              );
            },
          ),
          // 主题切换
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.light_mode, size: 18),
                  Switch.adaptive(
                    value: isDarkMode,
                    onChanged: onThemeChanged,
                  ),
                  const Icon(Icons.dark_mode, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Behavior Trends",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final days = [
                            "Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"
                          ];
                          final idx = value.toInt();
                          return (idx >= 0 && idx < days.length)
                              ? Text(days[idx])
                              : const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, interval: 1),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: const FlGridData(show: true),
                  borderData: FlBorderData(show: true),
                  lineBarsData: [
                    LineChartBarData(
                      spots: dashboard.trend,
                      isCurved: true,
                      barWidth: 3,
                      color: MindWellColors.lightGreen,
                      dotData: const FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Note: The Y-axis represents your daily behavioral risk score (0–5), "
              "where higher values indicate increased behavioral risk based on activity patterns.",
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),

            // 今日情绪卡片
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: MindWellColors.lightGreen.withOpacity(0.18),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Today's Mood: ",
                      style: MindWellTypography.body(color: MindWellColors.darkGray).copyWith(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      dashboard.currentMood,
                      style: MindWellTypography.body(color: MindWellColors.darkGray).copyWith(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 周报 & AI 洞察
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (final shortcut in dashboard.shortcuts)
                  _FeatureIcon(shortcut.icon, shortcut.label),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  const _FeatureIcon(this.icon, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: MindWellColors.lightGreen.withOpacity(0.2),
          child: Icon(icon, size: 30, color: MindWellColors.darkGray),
        ),
        const SizedBox(height: 6),
        Text(label, style: MindWellTypography.body(color: MindWellColors.darkGray).copyWith(fontSize: 12)),
      ],
    );
  }
}
