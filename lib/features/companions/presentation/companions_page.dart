import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_application_mhproj/design_system/tokens/color_tokens.dart';
import 'package:flutter_application_mhproj/design_system/tokens/typography.dart';
import 'package:flutter_application_mhproj/features/companions/domain/models/companion.dart';
import 'package:flutter_application_mhproj/features/assessment/presentation/widgets/chat_bubble.dart';

import '../application/companion_controller.dart';

class CompanionsPage extends ConsumerStatefulWidget {
  const CompanionsPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  @override
  ConsumerState<CompanionsPage> createState() => _CompanionsPageState();
}

class _CompanionsPageState extends ConsumerState<CompanionsPage> {
  final TextEditingController _input = TextEditingController();
  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  Future<void> _send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    await ref.read(companionControllerProvider.notifier).send(trimmed);
    _input.clear();
    _jumpToBottom();
  }

  void _switchCompanion(Companion companion) {
    ref.read(companionControllerProvider.notifier).switchCompanion(companion);
    _jumpToBottom();
  }

  void _jumpToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 120,
          duration: const Duration(milliseconds: 240),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final viewState = ref.watch(companionControllerProvider);
    final suggestions = ref.read(companionControllerProvider.notifier).suggestions();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Companions'),
        actions: [
          Switch(value: isDark, onChanged: widget.onThemeChanged),
          Padding(padding: const EdgeInsets.only(right: 8), child: Text(isDark ? '☾' : '☀')),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 96,
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, i) {
                final companion = viewState.presets[i];
                final selected = companion.id == viewState.current.id;
                return InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => _switchCompanion(companion),
                  child: Container(
                    width: 220,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: selected ? MindWellColors.lightGreen.withOpacity(0.15) : Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected ? MindWellColors.darkGray : Theme.of(context).dividerColor.withOpacity(0.6),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(companion.icon, color: MindWellColors.darkGray),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(companion.name, style: MindWellTypography.cardTitle(color: MindWellColors.darkGray)),
                              Text(
                                companion.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: MindWellTypography.body(color: MindWellColors.warmGray),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemCount: viewState.presets.length,
            ),
          ),
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(16),
              itemCount: viewState.messages.length + (viewState.isLoading ? 1 : 0),
              itemBuilder: (_, i) {
                if (viewState.isLoading && i == viewState.messages.length) {
                  return const TypingBubble();
                }
                return ChatBubble(message: viewState.messages[i]);
              },
            ),
          ),
          if (suggestions.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    for (final suggestion in suggestions)
                      ActionChip(label: Text(suggestion), onPressed: () => _send(suggestion)),
                  ],
                ),
              ),
            ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _input,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Chat with your companion',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      onSubmitted: _send,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: viewState.isLoading ? null : () => _send(_input.text),
                    icon: const Icon(Icons.send),
                    label: const Text('Send'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
