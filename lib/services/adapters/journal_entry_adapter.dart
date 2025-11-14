import 'package:hive/hive.dart';
import '../journal_store.dart';

/// Hive TypeAdapter for JournalEntry
/// 用于将 JournalEntry 对象序列化/反序列化到 Hive 数据库
class JournalEntryAdapter extends TypeAdapter<JournalEntry> {
  @override
  final int typeId = 1; // 唯一类型 ID（与 AssessmentResultAdapter 不同）

  @override
  JournalEntry read(BinaryReader reader) {
    final tsString = reader.readString();
    final ts = DateTime.parse(tsString);
    final hasFeeling = reader.readBool();
    final feeling = hasFeeling ? reader.readString() : null;
    final tagsCount = reader.readInt();
    final tags = List<String>.generate(
      tagsCount,
      (_) => reader.readString(),
    );
    final text = reader.readString();
    
    return JournalEntry(
      ts: ts,
      feeling: feeling,
      tags: tags,
      text: text,
    );
  }

  @override
  void write(BinaryWriter writer, JournalEntry obj) {
    writer.writeString(obj.ts.toIso8601String());
    writer.writeBool(obj.feeling != null);
    if (obj.feeling != null) {
      writer.writeString(obj.feeling!);
    }
    writer.writeInt(obj.tags.length);
    for (final tag in obj.tags) {
      writer.writeString(tag);
    }
    writer.writeString(obj.text);
  }
}

