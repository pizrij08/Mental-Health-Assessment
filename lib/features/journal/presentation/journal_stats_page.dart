// lib/pages/journal_stats_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_mhproj/services/journal_store.dart' as journal;

class JournalStatsPage extends StatelessWidget {
  const JournalStatsPage({super.key, required this.entries});
  final List<journal.JournalEntry> entries;

  static const Map<String, int> _score = {
    'Happy':  2, 'Neutral': 0, 'Sad': -1, 'Angry': -2, 'Anxious': -1,
  };

  @override
  Widget build(BuildContext context) {
    final counts = <String, int>{};
    for (final e in entries) {
      final f = e.feeling ?? 'Unknown';
      counts[f] = (counts[f] ?? 0) + 1;
    }

    // 近 30 天每日分数（无记录为 null -> 画断点）
    final now = DateTime.now();
    final byDay = <DateTime, int?>{};
    for (int i = 29; i >= 0; i--) {
      final d = DateTime(now.year, now.month, now.day).subtract(Duration(days: i));
      byDay[d] = null;
    }
    for (final e in entries) {
      final d = DateTime(e.ts.year, e.ts.month, e.ts.day);
      if (byDay.containsKey(d)) {
        final s = _score[e.feeling ?? ''] ?? 0;
        byDay[d] = (byDay[d] ?? 0) + s;
      }
    }
    final points = byDay.entries
        .map((e) => _Point(e.key, e.value?.toDouble()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Statistics')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Text('Emotion counts', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10, runSpacing: 8,
              children: counts.entries.map((kv) {
                return Chip(
                  avatar: const Icon(Icons.emoji_emotions),
                  label: Text('${kv.key}: ${kv.value}'),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            Text('Last 30 days trend', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Container(
              height: 200,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CustomPaint(
                painter: _TrendPainter(points),
                child: Container(),
              ),
            ),
            const SizedBox(height: 8),
            Text('Tip: Higher = more positive mood; gaps = no entry.'),
          ],
        ),
      ),
    );
  }
}

class _Point {
  final DateTime day;
  final double? value;
  _Point(this.day, this.value);
}

class _TrendPainter extends CustomPainter {
  _TrendPainter(this.series);
  final List<_Point> series;

  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF5277D0);
    final paintAxis = Paint()
      ..color = const Color(0x33000000)
      ..strokeWidth = 1;

    const left = 28.0, right = 8.0, top = 8.0, bottom = 22.0;
    final w = size.width - left - right;
    final h = size.height - top - bottom;

    final vals = series.map((p) => p.value).whereType<double>().toList();
    final minV = (vals.isEmpty ? -2.0 : vals.reduce((a, b) => a < b ? a : b)) - 0.5;
    final maxV = (vals.isEmpty ?  2.0 : vals.reduce((a, b) => a > b ? a : b)) + 0.5;
    double yOf(double v) => top + h * (1 - (v - minV) / (maxV - minV));

    // 0 轴
    final zeroY = (minV <= 0 && maxV >= 0) ? yOf(0) : top + h / 2;
    canvas.drawLine(Offset(left, zeroY), Offset(size.width - right, zeroY), paintAxis);

    // 折线（null 断开）
    final dx = w / (series.length <= 1 ? 1 : (series.length - 1));
    Path? path;
    for (int i = 0; i < series.length; i++) {
      final p = series[i];
      final x = left + i * dx;
      if (p.value == null) {
        if (path != null) {
          canvas.drawPath(path, paintLine);
          path = null;
        }
        continue;
      }
      final y = yOf(p.value!);
      if (path == null) {
        path = Path()..moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    if (path != null) canvas.drawPath(path, paintLine);

    // x 轴刻度（每 7 天一个）
    final tp = TextPainter(textDirection: TextDirection.ltr, textAlign: TextAlign.center);
    for (int i = 0; i < series.length; i += 7) {
      final d = series[i].day.day.toString().padLeft(2, '0');
      tp.text = TextSpan(text: d, style: const TextStyle(fontSize: 10, color: Color(0x99000000)));
      tp.layout(minWidth: 14);
      final x = left + i * dx - tp.width / 2;
      tp.paint(canvas, Offset(x, size.height - bottom + 2));
    }
  }

  @override
  bool shouldRepaint(covariant _TrendPainter oldDelegate) => oldDelegate.series != series;
}
