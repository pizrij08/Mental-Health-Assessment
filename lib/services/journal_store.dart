// lib/services/journal_store.dart

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'adapters/journal_entry_adapter.dart';

/// 统一模型 & 存储接口（使用 Hive 数据库持久化存储）
class JournalEntry {
  final DateTime ts;
  final String? feeling;        // 'Happy' | 'Neutral' | 'Sad' | 'Angry' | 'Anxious'
  final List<String> tags;      // 任意标签
  final String text;            // 日记正文

  JournalEntry({
    required this.ts,
    this.feeling,
    List<String>? tags,
    this.text = '',
  }) : tags = List.unmodifiable(tags ?? const []);

  Map<String, dynamic> toJson() => {
        'ts': ts.toIso8601String(),
        'feeling': feeling,
        'tags': tags,
        'text': text,
      };

  factory JournalEntry.fromJson(Map<String, dynamic> j) => JournalEntry(
        ts: DateTime.parse(j['ts'] as String),
        feeling: j['feeling'] as String?,
        tags: (j['tags'] as List?)?.cast<String>() ?? const [],
        text: (j['text'] as String?) ?? '',
      );
}

abstract class JournalEntryStore {
  Future<void> add(String key, JournalEntry e);
  Future<List<JournalEntry>> loadAll(String key);
}

/// 使用 Hive 数据库持久化存储日记条目
class HiveJournalEntryStore implements JournalEntryStore {
  static const String _boxName = 'journal_entry_box';
  static Box? _box;
  static bool _initialized = false;

  /// 初始化 Hive 数据库
  /// 必须在应用启动时调用一次
  static Future<void> init() async {
    if (_initialized) return;
    
    try {
      // 注册 TypeAdapter
      if (!Hive.isAdapterRegistered(1)) {
        Hive.registerAdapter(JournalEntryAdapter());
      }
      
      // 打开或创建 Hive box
      _box = await Hive.openBox(_boxName);
      _initialized = true;
      debugPrint('✓ 日记 Hive 数据库初始化成功');
    } catch (e) {
      debugPrint('✗ 日记 Hive 数据库初始化失败: $e');
      rethrow;
    }
  }

  /// 确保数据库已初始化
  static Future<void> _ensureInitialized() async {
    if (!_initialized || _box == null) {
      await init();
    }
  }

  @override
  Future<void> add(String key, JournalEntry e) async {
    try {
      await _ensureInitialized();
      final existing = _box!.get(key);
      List<JournalEntry> list;
      if (existing == null) {
        list = <JournalEntry>[];
      } else {
        list = (existing as List).cast<JournalEntry>().toList();
      }
      list.add(e);
      await _box!.put(key, list);
      debugPrint('✓ 保存日记条目到 Hive: key=$key');
    } catch (e) {
      debugPrint('✗ 保存日记条目失败: $e');
      rethrow;
    }
  }

  @override
  Future<List<JournalEntry>> loadAll(String key) async {
    try {
      await _ensureInitialized();
      final data = _box!.get(key);
      if (data == null) {
        return const [];
      }
      final list = (data as List).cast<JournalEntry>().toList();
      return List.unmodifiable(list);
    } catch (e) {
      debugPrint('✗ 加载日记条目失败: $e');
      return [];
    }
  }
}
