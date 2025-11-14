import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/models/assessment.dart';

/// 问卷历史记录存储服务
/// 使用 SharedPreferences 持久化存储 PHQ-9 和 GAD-7 的历史记录
class AssessmentStorage {
  static const String _phq9HistoryKey = 'assessment_phq9_history';
  static const String _gad7HistoryKey = 'assessment_gad7_history';

  /// 保存 PHQ-9 历史记录
  static Future<void> savePhq9History(List<AssessmentResult> history) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = history.map((result) => {
        'scale': result.scale,
        'score': result.score,
        'severity': result.severity,
        'at': result.at.toIso8601String(),
      }).toList();
      final jsonString = jsonEncode(jsonList);
      final success = await prefs.setString(_phq9HistoryKey, jsonString);
      if (!success) {
        debugPrint('✗ 保存 PHQ-9 到 SharedPreferences 失败');
      } else {
        debugPrint('✓ 保存 PHQ-9 历史记录: ${history.length} 条');
      }
    } catch (e) {
      debugPrint('✗ 保存 PHQ-9 历史记录失败: $e');
      rethrow;
    }
  }

  /// 保存 GAD-7 历史记录
  static Future<void> saveGad7History(List<AssessmentResult> history) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = history.map((result) => {
        'scale': result.scale,
        'score': result.score,
        'severity': result.severity,
        'at': result.at.toIso8601String(),
      }).toList();
      final jsonString = jsonEncode(jsonList);
      final success = await prefs.setString(_gad7HistoryKey, jsonString);
      if (!success) {
        debugPrint('✗ 保存 GAD-7 到 SharedPreferences 失败');
      } else {
        debugPrint('✓ 保存 GAD-7 历史记录: ${history.length} 条');
      }
    } catch (e) {
      debugPrint('✗ 保存 GAD-7 历史记录失败: $e');
      rethrow;
    }
  }

  /// 加载 PHQ-9 历史记录
  static Future<List<AssessmentResult>> loadPhq9History() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_phq9HistoryKey);
      if (jsonString == null || jsonString.isEmpty) {
        debugPrint('✓ 加载 PHQ-9 历史记录: 无数据');
        return [];
      }
      
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
      debugPrint('✓ 加载 PHQ-9 历史记录: ${results.length} 条');
      return results;
    } catch (e) {
      debugPrint('✗ 加载 PHQ-9 历史记录失败: $e');
      return [];
    }
  }

  /// 加载 GAD-7 历史记录
  static Future<List<AssessmentResult>> loadGad7History() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_gad7HistoryKey);
      if (jsonString == null || jsonString.isEmpty) {
        debugPrint('✓ 加载 GAD-7 历史记录: 无数据');
        return [];
      }
      
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
      debugPrint('✓ 加载 GAD-7 历史记录: ${results.length} 条');
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

