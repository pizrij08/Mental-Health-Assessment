import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive/hive.dart';
import '../../domain/models/assessment.dart';

/// 评估历史数据迁移服务
/// 负责将数据从 SharedPreferences 迁移到 Hive
class AssessmentMigration {
  static const String _phq9HistoryKey = 'assessment_phq9_history';
  static const String _gad7HistoryKey = 'assessment_gad7_history';
  static const String _migrationCompleteKey = 'assessment_migration_complete';

  static const String _phq9BoxName = 'phq9_history';
  static const String _gad7BoxName = 'gad7_history';

  /// 执行数据迁移（仅在首次运行时执行）
  static Future<void> migrateIfNeeded() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // 检查是否已经迁移过
      final migrationComplete = prefs.getBool(_migrationCompleteKey) ?? false;
      if (migrationComplete) {
        debugPrint('✓ 数据迁移已完成，跳过');
        return;
      }

      debugPrint('>>> 开始数据迁移: SharedPreferences → Hive');

      // 迁移 PHQ-9 历史记录
      await _migratePhq9History(prefs);

      // 迁移 GAD-7 历史记录
      await _migrateGad7History(prefs);

      // 标记迁移完成
      await prefs.setBool(_migrationCompleteKey, true);
      debugPrint('✓ 数据迁移完成');

      // 可选：删除 SharedPreferences 中的旧数据以释放空间
      await _cleanupOldData(prefs);

    } catch (e) {
      debugPrint('✗ 数据迁移失败: $e');
      // 不抛出异常，允许应用继续运行
    }
  }

  /// 迁移 PHQ-9 历史记录
  static Future<void> _migratePhq9History(SharedPreferences prefs) async {
    try {
      final jsonString = prefs.getString(_phq9HistoryKey);
      if (jsonString == null || jsonString.isEmpty) {
        debugPrint('  - PHQ-9: 无旧数据需要迁移');
        return;
      }

      // 解析 JSON 数据
      final jsonList = jsonDecode(jsonString) as List;
      final results = <AssessmentResult>[];

      for (final item in jsonList) {
        if (item is Map) {
          final at = DateTime.tryParse(item['at'] ?? '');
          final score = item['score'] as int?;
          final severity = item['severity'] as String? ?? '';
          if (at != null && score != null) {
            results.add(AssessmentResult(
              scale: 'phq9',
              score: score,
              severity: severity,
              at: at,
            ));
          }
        }
      }

      // 写入 Hive
      if (results.isNotEmpty) {
        final box = await Hive.openBox<AssessmentResult>(_phq9BoxName);
        await box.clear();
        await box.addAll(results);
        debugPrint('  ✓ PHQ-9: 迁移 ${results.length} 条记录');
      } else {
        debugPrint('  - PHQ-9: 无有效数据');
      }
    } catch (e) {
      debugPrint('  ✗ PHQ-9 迁移失败: $e');
    }
  }

  /// 迁移 GAD-7 历史记录
  static Future<void> _migrateGad7History(SharedPreferences prefs) async {
    try {
      final jsonString = prefs.getString(_gad7HistoryKey);
      if (jsonString == null || jsonString.isEmpty) {
        debugPrint('  - GAD-7: 无旧数据需要迁移');
        return;
      }

      // 解析 JSON 数据
      final jsonList = jsonDecode(jsonString) as List;
      final results = <AssessmentResult>[];

      for (final item in jsonList) {
        if (item is Map) {
          final at = DateTime.tryParse(item['at'] ?? '');
          final score = item['score'] as int?;
          final severity = item['severity'] as String? ?? '';
          if (at != null && score != null) {
            results.add(AssessmentResult(
              scale: 'gad7',
              score: score,
              severity: severity,
              at: at,
            ));
          }
        }
      }

      // 写入 Hive
      if (results.isNotEmpty) {
        final box = await Hive.openBox<AssessmentResult>(_gad7BoxName);
        await box.clear();
        await box.addAll(results);
        debugPrint('  ✓ GAD-7: 迁移 ${results.length} 条记录');
      } else {
        debugPrint('  - GAD-7: 无有效数据');
      }
    } catch (e) {
      debugPrint('  ✗ GAD-7 迁移失败: $e');
    }
  }

  /// 清理 SharedPreferences 中的旧数据
  static Future<void> _cleanupOldData(SharedPreferences prefs) async {
    try {
      await prefs.remove(_phq9HistoryKey);
      await prefs.remove(_gad7HistoryKey);
      debugPrint('  ✓ 清理 SharedPreferences 旧数据完成');
    } catch (e) {
      debugPrint('  ✗ 清理旧数据失败: $e');
    }
  }
}
