import 'dart:async';
import '../models/assessment.dart';
import '../models/companion.dart';

/// 抽象层：后续可替换为 Transformer/云端服务
abstract class CompanionApi {
  Future<AssessmentMessage> reply(CompanionState state, String userInput);
}

/// 本地规则引擎（占位），便于 UI 联调与单测
class LocalCompanionApi implements CompanionApi {
  @override
  Future<AssessmentMessage> reply(CompanionState state, String userInput) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final c = state.current;
    final text = _generate(c.persona, userInput);
    return AssessmentMessage(role: AgentRole.assistant, text: text);
  }

  String _generate(CompanionPersona p, String user) {
    switch (p) {
      case CompanionPersona.listener:
        return "I’m listening. You just said:\"$user\"How does that make you feel? Tell me more about the details.";
      case CompanionPersona.coach:
        return "As your coach, I hear that your goal/challenge is:\"$user\".\n"
               "Let’s break it down into the smallest actionable step: What is the first step you’re willing to take in the next 24 hours?";
      case CompanionPersona.planner:
        return "Planning mode: Based on“$user”， I suggest writing the task as:：\n"
               "• Clear deliverable\n• Deadline\n• Small step doable in 15 minutes\nWould you like to start by setting a 15-minute block?";
      case CompanionPersona.cheerleader:
        return "You’ve got this! Hearing you say“$user”，shows it’s not easy. You’ve already taken the first step, and I’m applauding you for that. 👏。\n"
               "What small reward would you like to give yourself today?";
    }
  }
}

/// 远端/本地 Transformer（占位）
class RemoteCompanionApi implements CompanionApi {
  RemoteCompanionApi({required this.endpoint, this.apiKey});
  final String endpoint;
  final String? apiKey;

  @override
  Future<AssessmentMessage> reply(CompanionState state, String userInput) async {
    // TODO: 把 state.current/persona + state.messages 序列化后 POST 到你的推理服务
    // 返回文本后组装成 AssessmentMessage
    throw UnimplementedError('Hook your transformer endpoint here.');
  }
}
