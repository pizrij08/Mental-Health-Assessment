import 'package:flutter/material.dart';
import 'package:flutter_application_mhproj/design_system/components/common_widgets.dart';
import 'package:flutter_application_mhproj/design_system/tokens/color_tokens.dart';
import 'package:flutter_application_mhproj/design_system/tokens/typography.dart';
import 'package:flutter_application_mhproj/features/auth/presentation/role_selection_page.dart';
import 'package:flutter_application_mhproj/features/appointments/presentation/appointment_main_page.dart';
import 'package:flutter_application_mhproj/features/assessment/presentation/assessment_page.dart';
import 'package:flutter_application_mhproj/features/assessment/domain/models/assessment.dart';
import 'package:flutter_application_mhproj/features/behavior/presentation/behavior_tracker_page.dart';
import 'package:flutter_application_mhproj/features/companions/presentation/companions_page.dart';
import 'package:flutter_application_mhproj/features/journal/presentation/journal_page.dart' as journal_page;
import 'package:flutter_application_mhproj/features/resources/presentation/my_resource_page.dart';
import 'package:flutter_application_mhproj/services/journal_store.dart' as journal;

class UserMainPage extends StatefulWidget {
  const UserMainPage({
    super.key,
    required this.userName,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  final String userName;
  final ValueChanged<bool> onThemeChanged;
  final bool isDarkMode;

  @override
  State<UserMainPage> createState() => _UserMainPageState();
}

class _UserMainPageState extends State<UserMainPage> {
  late bool _isDarkMode;

  // 复用一个存储实例（当前为内存实现；未来切 Hive 也只改 services 层）
  final journal.JournalEntryStore _journalStore = journal.HiveJournalEntryStore();

  final List<Map<String, dynamic>> features = const [
    {'title': 'User Info', 'icon': Icons.person},
    {'title': 'Assessment', 'icon': Icons.assignment},
    {'title': 'Companions', 'icon': Icons.people},
    {'title': 'Journal', 'icon': Icons.book},
    {'title': 'Appointment', 'icon': Icons.calendar_today},
    {'title': 'My Resource', 'icon': Icons.library_books},
    {'title': 'Behavior Tracker', 'icon': Icons.trending_up},
  ];

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    _isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: MindWellColors.cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Welcome, ${widget.userName}',
            style: MindWellTypography.sectionSubtitle(color: MindWellColors.darkGray).copyWith(fontSize: 22)),
        actions: [
          Switch(value: _isDarkMode, onChanged: (v) => widget.onThemeChanged(v)),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(_isDarkMode ? '☾' : '☀'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (_) => RoleSelectionPage(
                  isDarkMode: _isDarkMode,
                  onThemeChanged: widget.onThemeChanged,
                ),
              ),
              (r) => false,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your MindWell Toolkit',
              style: MindWellTypography.sectionTitle(color: MindWellColors.darkGray).copyWith(fontSize: 32),
            ),
            const SizedBox(height: 8),
            Text(
              'Access journeys, reflections, and care in one place.',
              style: MindWellTypography.body(color: Colors.grey.shade700),
            ),
            const SizedBox(height: 24),
            ...features.map(
              (f) => FeatureButton(
                icon: f['icon'] as IconData,
                title: f['title'] as String,
                onTap: () {
                  final title = f['title'] as String;

                  if (title == 'Companions') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CompanionsPage(
                          isDarkMode: _isDarkMode,
                          onThemeChanged: widget.onThemeChanged,
                        ),
                      ),
                    );
                  } else if (title == 'Assessment') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AssessmentPage(
                          isDarkMode: _isDarkMode,
                          onThemeChanged: widget.onThemeChanged,
                          initialMode: AssessmentMode.act,
                        ),
                      ),
                    );
                  } else if (title == 'Journal') {
                    final convoId = 'journal_${widget.userName}'; // 用用户名区分
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => journal_page.JournalPage(
                          isDarkMode: _isDarkMode,
                          onThemeChanged: widget.onThemeChanged,
                          storeKey: convoId,
                          entryStore: _journalStore, // ✅ 统一使用同一实例
                        ),
                      ),
                    );
                  } else if (title == 'Appointment') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => AppointmentMainPage(
                          onThemeChanged: widget.onThemeChanged,
                          isDarkMode: _isDarkMode,
                        ),
                      ),
                    );
                  } else if (title == 'My Resource') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MyResourcePage(),
                      ),
                    );
                  } else if (title == 'Behavior Tracker') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BehaviorTrackerPage(
                          onThemeChanged: widget.onThemeChanged,
                          isDarkMode: _isDarkMode,
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('Opening ${f['title']}')));
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CopyrightBar(),
    );
  }
}
