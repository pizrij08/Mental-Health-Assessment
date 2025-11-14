import 'package:hive/hive.dart';
import 'assessment.dart';

/// Hive TypeAdapter for AssessmentResult
/// TypeId: 0
class AssessmentResultAdapter extends TypeAdapter<AssessmentResult> {
  @override
  final int typeId = 0;

  @override
  AssessmentResult read(BinaryReader reader) {
    return AssessmentResult(
      scale: reader.readString(),
      score: reader.readInt(),
      severity: reader.readString(),
      at: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
    );
  }

  @override
  void write(BinaryWriter writer, AssessmentResult obj) {
    writer.writeString(obj.scale);
    writer.writeInt(obj.score);
    writer.writeString(obj.severity);
    writer.writeInt(obj.at.millisecondsSinceEpoch);
  }
}
