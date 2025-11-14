import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_application_mhproj/features/assessment/domain/models/assessment.dart';
import 'package:flutter_application_mhproj/features/companions/domain/models/companion.dart';
import 'package:flutter_application_mhproj/features/companions/application/services/companion_api.dart';

class CompanionViewState {
  const CompanionViewState({
    required this.presets,
    required this.current,
    required this.messages,
    this.isLoading = false,
  });

  final List<Companion> presets;
  final Companion current;
  final List<AssessmentMessage> messages;
  final bool isLoading;

  CompanionViewState copyWith({
    List<Companion>? presets,
    Companion? current,
    List<AssessmentMessage>? messages,
    bool? isLoading,
  }) {
    return CompanionViewState(
      presets: presets ?? this.presets,
      current: current ?? this.current,
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CompanionController extends StateNotifier<CompanionViewState> {
  CompanionController({required CompanionApi api})
      : _api = api,
        super(_initialState()) {
    state = state.copyWith(messages: [
      AssessmentMessage(
        role: AgentRole.assistant,
        text:
            "Hi~ I’m ${state.current.name}。${state.current.description}\nFeel free to tell me anytime what you’re thinking or what you want to do.",
      ),
    ]);
  }

  final CompanionApi _api;

  static CompanionViewState _initialState() {
    const presets = [
      Companion(
        id: 'c_listener',
        name: 'Listener',
        persona: CompanionPersona.listener,
        description: 'Empathic listening, helping you finish your thoughts.',
        icon: Icons.hearing_rounded,
      ),
      Companion(
        id: 'c_coach',
        name: 'Coach',
        persona: CompanionPersona.coach,
        description: 'Goal breakdown and action follow-up.',
        icon: Icons.sports_gymnastics_rounded,
      ),
      Companion(
        id: 'c_planner',
        name: 'Planner',
        persona: CompanionPersona.planner,
        description: 'Task breakdown, time blocking, reminders.',
        icon: Icons.event_note_rounded,
      ),
      Companion(
        id: 'c_cheer',
        name: 'Cheerleader',
        persona: CompanionPersona.cheerleader,
        description: 'Positive reinforcement and supportive encouragement.',
        icon: Icons.emoji_emotions_rounded,
      ),
    ];
    return CompanionViewState(
      presets: presets,
      current: presets.first,
      messages: const [],
    );
  }

  Future<void> send(String text) async {
    if (text.trim().isEmpty) return;
    final trimmed = text.trim();
    final userMessage = AssessmentMessage(role: AgentRole.user, text: trimmed);
    state = state.copyWith(
      messages: [...state.messages, userMessage],
      isLoading: true,
    );
    final reply = await _api.reply(_toCompanionState(state), trimmed);
    state = state.copyWith(
      messages: [...state.messages, reply],
      isLoading: false,
    );
  }

  void switchCompanion(Companion companion) {
    if (companion.id == state.current.id) return;
    final systemMessage = AssessmentMessage(
      role: AgentRole.system,
      text: 'Switched to ${companion.name}（${companion.description}）',
      meta: {'companion': companion.id},
    );
    state = state.copyWith(
      current: companion,
      messages: [...state.messages, systemMessage],
    );
  }

  List<String> suggestions() {
    switch (state.current.persona) {
      case CompanionPersona.listener:
        return const ['My current feeling is', 'What’s troubling me is…'];
      case CompanionPersona.coach:
        return const ['My goal is', 'The obstacle I’m facing is'];
      case CompanionPersona.planner:
        return const ['Help me break down the task', 'Give me a 15-minute plan'];
      case CompanionPersona.cheerleader:
        return const ['I need some encouragement', 'Let’s celebrate today’s small progress'];
    }
  }

  CompanionState _toCompanionState(CompanionViewState viewState) {
    final companionState = CompanionState(current: viewState.current);
    companionState.messages.addAll(viewState.messages);
    return companionState;
  }
}

final companionApiProvider = Provider<CompanionApi>((ref) => LocalCompanionApi());

final companionControllerProvider =
    StateNotifierProvider<CompanionController, CompanionViewState>((ref) {
  final api = ref.watch(companionApiProvider);
  return CompanionController(api: api);
});
