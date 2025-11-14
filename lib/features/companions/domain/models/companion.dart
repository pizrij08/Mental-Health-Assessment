import 'package:flutter/material.dart';
import 'package:flutter_application_mhproj/features/assessment/domain/models/assessment.dart' show AssessmentMessage;

/// 预设人格
enum CompanionPersona { listener, coach, planner, cheerleader }

@immutable
class Companion {
  final String id;
  final String name;
  final CompanionPersona persona;
  final String description;
  final IconData icon;

  const Companion({
    required this.id,
    required this.name,
    required this.persona,
    required this.description,
    required this.icon,
  });
}

/// 会话状态
class CompanionState {
  CompanionState({required this.current});
  Companion current;
  final List<AssessmentMessage> messages = [];
}

