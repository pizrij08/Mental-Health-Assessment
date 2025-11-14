import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../../domain/models/assessment.dart';

/// 问卷历史记录存储服务
/// 使用 Hive 持久化存储 PHQ-9 和 GAD-7 的历史记录
class AssessmentStorage {
  static const String _phq9BoxName = 'phq9_history';
  static const String _gad7BoxName = 'gad7_history';

  /// 保存 PHQ-9 历史记录
  static Future<void> savePhq9History(List<AssessmentResult> history) async {
    try {
      final box = await Hive.openBox<AssessmentResult>(_phq9BoxName);
      await box.clear(); // 清空现有数据
      await box.addAll(history); // 批量添加
      debugPrint('✓ 保存 PHQ-9 历史记录到 Hive: ${history.length} 条');
    } catch (e) {
      debugPrint('✗ 保存 PHQ-9 历史记录失败: $e');
      rethrow;
    }
  }

  /// 保存 GAD-7 历史记录
  static Future<void> saveGad7History(List<AssessmentResult> history) async {
    try {
      final box = await Hive.openBox<AssessmentResult>(_gad7BoxName);
      await box.clear(); // 清空现有数据
      await box.addAll(history); // 批量添加
      debugPrint('✓ 保存 GAD-7 历史记录到 Hive: ${history.length} 条');
    } catch (e) {
      debugPrint('✗ 保存 GAD-7 历史记录失败: $e');
      rethrow;
    }
  }

  /// 加载 PHQ-9 历史记录
  static Future<List<AssessmentResult>> loadPhq9History() async {
    try {
      final box = await Hive.openBox<AssessmentResult>(_phq9BoxName);
      final results = box.values.toList();
      debugPrint('✓ 加载 PHQ-9 历史记录从 Hive: ${results.length} 条');
      return results;
    } catch (e) {
      debugPrint('✗ 加载 PHQ-9 历史记录失败: $e');
      return [];
    }
  }

  /// 加载 GAD-7 历史记录
  static Future<List<AssessmentResult>> loadGad7History() async {
    try {
      final box = await Hive.openBox<AssessmentResult>(_gad7BoxName);
      final results = box.values.toList();
      debugPrint('✓ 加载 GAD-7 历史记录从 Hive: ${results.length} 条');
      return results;
    } catch (e) {
      debugPrint('✗ 加载 GAD-7 历史记录失败: $e');
      return [];
    }
  }

  /// 保存完整历史记录（PHQ-9 和 GAD-7）
  static Future<void> saveHistory({
    required List<AssessmentResult> phq9History,
    required List<AssessmentResult> gad7History,
  }) async {
    try {
      debugPrint('>>> AssessmentStorage.saveHistory 开始: PHQ-9=${phq9History.length}, GAD-7=${gad7History.length}');
      await Future.wait([
        savePhq9History(phq9History),
        saveGad7History(gad7History),
      ]);
      debugPrint('>>> AssessmentStorage.saveHistory 完成');
    } catch (e) {
      debugPrint('>>> AssessmentStorage.saveHistory 失败: $e');
      rethrow;
    }
  }

  /// 加载完整历史记录（PHQ-9 和 GAD-7）
  static Future<({
    List<AssessmentResult> phq9History,
    List<AssessmentResult> gad7History,
  })> loadHistory() async {
    final results = await Future.wait([
      loadPhq9History(),
      loadGad7History(),
    ]);
    return (
      phq9History: results[0],
      gad7History: results[1],
    );
  }
}
