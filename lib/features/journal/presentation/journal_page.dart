// lib/pages/journal_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_mhproj/services/journal_store.dart' as journal;
import 'journal_stats_page.dart';

class JournalPage extends StatefulWidget {
  JournalPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.storeKey,                      // 用于区分用户/会话
    journal.JournalEntryStore? entryStore,       // 可外部注入；默认内存实现
  }) : entryStore = entryStore ?? journal.HiveJournalEntryStore();

  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final String storeKey;
  final journal.JournalEntryStore entryStore;

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  late bool _isDark;
  String? _feeling;
  final Set<String> _tags = <String>{};
  final _text = TextEditingController();

  // 历史用于统计
  List<journal.JournalEntry> _history = [];

  final List<String> _feelings = const [
    '😄 Happy', '😐 Neutral', '😔 Sad', '😠 Angry', '😟 Anxious'
  ];

  List<String> get _suggestedTags {
    switch (_feeling) {
      case 'Happy':   return const ['Gratitude', 'High-light', 'Win', 'Connection'];
      case 'Neutral': return const ['Routine', 'Note', 'Plan', 'Idea'];
      case 'Sad':     return const ['Loss', 'Support', 'Self-care', 'Reach-out'];
      case 'Angry':   return const ['Boundary', 'Need', 'Cool-down', 'Assertive'];
      case 'Anxious': return const ['What-if', 'Control', 'Step', 'Breath'];
      default:        return const ['Today', 'Thought', 'Event', 'Reflection'];
    }
  }

  @override
  void initState() {
    super.initState();
    _isDark = widget.isDarkMode;
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    _history = await widget.entryStore.loadAll(widget.storeKey);
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _pickFeeling(String f) {
    setState(() => _feeling = f);
  }

  Future<void> _save() async {
    final t = _text.text.trim();
    if (t.isEmpty && _feeling == null && _tags.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('What on your mind? Tag adn Label')));
      return;
    }
    final entry = journal.JournalEntry(
      ts: DateTime.now(),
      feeling: _feeling,
      tags: _tags.toList(),
      text: t,
    );
    await widget.entryStore.add(widget.storeKey, entry);
    _text.clear();
    _tags.clear();
    // 保留情绪选择（如需清空可自行置 null）
    _history = await widget.entryStore.loadAll(widget.storeKey);
    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Saved')));
  }

  @override
  Widget build(BuildContext context) {
    _isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal'),
        actions: [
          IconButton(
            tooltip: 'Statistics',
            icon: const Icon(Icons.query_stats),
            onPressed: _history.isEmpty
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => JournalStatsPage(entries: _history),
                      ),
                    );
                  },
          ),
          Switch(
            value: _isDark,
            onChanged: (v) { setState(() => _isDark = v); widget.onThemeChanged(v); },
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(_isDark ? '☾' : '☀'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Icon(Icons.book, color: Theme.of(context).primaryColor, size: 56),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Write your day.\nPick an emotion & tags, then jot down your thoughts.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 情绪
          Text('How are you feeling today?',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _feelings.map((e) {
              final parts = e.split(' ');
              final emoji = parts.first;
              final name = parts.last;
              final selected = _feeling == name;
              return ChoiceChip(
                selected: selected,
                label: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(emoji, style: const TextStyle(fontSize: 16)),
                  const SizedBox(width: 6),
                  Text(name),
                ]),
                onSelected: (_) => _pickFeeling(name),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // 标签
          Text('Tags (optional)', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _suggestedTags.map((tag) {
              final on = _tags.contains(tag);
              return FilterChip(
                selected: on,
                label: Text(tag),
                onSelected: (v) => setState(() => v ? _tags.add(tag) : _tags.remove(tag)),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // 文本输入区域
          Text('Your journal', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _text,
              minLines: 8,
              maxLines: 16,
              decoration: const InputDecoration(
                hintText: 'Write down todays experiences, ideas or anything you want to record... (can be saved with the emotions and labels above)',
                border: InputBorder.none,
              ),
            ),
          ),

          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton.icon(
              icon: const Icon(Icons.save),
              label: const Text('Save'),
              onPressed: _save,
            ),
          ),

          const SizedBox(height: 16),

          if (_history.isNotEmpty) ...[
            Text('Recent entries', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ..._history.reversed.take(5).map((e) => _EntryTile(e)),
          ],
        ],
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile(this.e);
  final journal.JournalEntry e;

  @override
  Widget build(BuildContext context) {
    final ts = '${e.ts.year}-${e.ts.month.toString().padLeft(2, '0')}-${e.ts.day.toString().padLeft(2, '0')} '
        '${e.ts.hour.toString().padLeft(2, '0')}:${e.ts.minute.toString().padLeft(2, '0')}';
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      leading: const Icon(Icons.note_alt_outlined),
      title: Text(e.feeling ?? 'No emotion', style: Theme.of(context).textTheme.bodyMedium),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (e.tags.isNotEmpty)
            Wrap(spacing: 6, runSpacing: 6, children: e.tags.map((t) => Chip(label: Text(t))).toList()),
          Text(e.text, maxLines: 2, overflow: TextOverflow.ellipsis),
        ],
      ),
      trailing: Text(ts, style: Theme.of(context).textTheme.bodySmall),
    );
  }
}
