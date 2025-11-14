// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'features/appointments/presentation/appointment_main_page.dart';
import 'features/behavior/presentation/behavior_tracker_page.dart';
import 'features/resources/presentation/my_resource_page.dart';
import 'features/auth/presentation/role_selection_page.dart';
import 'features/landing/presentation/mindwell_landing_page.dart';
import 'design_system/tokens/color_tokens.dart';
import 'core/providers/app_providers.dart';
import 'features/assessment/domain/models/assessment_result_adapter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Hive
  await Hive.initFlutter();

  // 注册 TypeAdapter
  Hive.registerAdapter(AssessmentResultAdapter());

  runApp(const ProviderScope(child: MentalTrekApp()));
}

class MentalTrekApp extends ConsumerStatefulWidget {
  const MentalTrekApp({super.key});

  @override
  ConsumerState<MentalTrekApp> createState() => _MentalTrekAppState();
}

class _MentalTrekAppState extends ConsumerState<MentalTrekApp> {
  bool _isDarkMode = false;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider);
    final lightColorScheme = ColorScheme.fromSeed(
      seedColor: MindWellColors.darkGray,
      primary: MindWellColors.darkGray,
      secondary: MindWellColors.lightGreen,
      surface: Colors.white,
    );

    final darkColorScheme = ColorScheme.fromSeed(
      seedColor: MindWellColors.darkGray,
      brightness: Brightness.dark,
    );

    TextTheme lightTextTheme = GoogleFonts.latoTextTheme();
    TextTheme darkTextTheme = GoogleFonts.latoTextTheme(ThemeData.dark().textTheme);

    lightTextTheme = lightTextTheme.copyWith(
      headlineLarge: GoogleFonts.openSans(
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
      titleMedium: GoogleFonts.openSans(fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.lato(fontSize: 16, height: 1.6),
    );

    darkTextTheme = darkTextTheme.copyWith(
      headlineLarge: GoogleFonts.openSans(
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
      titleMedium: GoogleFonts.openSans(fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.lato(fontSize: 16, height: 1.6),
    );

    void openRoleSelection() {
      _navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => RoleSelectionPage(
            isDarkMode: _isDarkMode,
            onThemeChanged: (value) => setState(() => _isDarkMode = value),
          ),
        ),
      );
    }

    void openAppointment() {
      _navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (_) => AppointmentMainPage(
            onThemeChanged: (value) => setState(() => _isDarkMode = value),
            isDarkMode: _isDarkMode,
          ),
        ),
      );
    }

    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: config.environment == 'production'
          ? 'MindWell Clinic'
          : 'MindWell Clinic (${config.environment})',
      debugShowCheckedModeBanner: false,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,

      // ===== 亮色主题 =====
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        scaffoldBackgroundColor: MindWellColors.cream,
        textTheme: lightTextTheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: MindWellColors.darkGray,
            foregroundColor: MindWellColors.cream,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: MindWellColors.darkGray,
            side: const BorderSide(color: MindWellColors.darkGray),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
        cardColor: Colors.white,
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
      ),

      // ===== 暗色主题 =====
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: darkColorScheme,
        scaffoldBackgroundColor: const Color(0xFF1B1F1C),
        textTheme: darkTextTheme,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: MindWellColors.lightGreen,
            foregroundColor: MindWellColors.darkGray,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: MindWellColors.lightGreen,
            side: const BorderSide(color: MindWellColors.lightGreen),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          ),
        ),
        cardColor: const Color(0xFF232825),
        appBarTheme: const AppBarTheme(backgroundColor: Colors.transparent, elevation: 0),
      ),

      // ===== 入口页：全新 MindWell UI =====
      home: MindWellLandingPage(
        onOpenBooking: openAppointment,
        onOpenLogin: openRoleSelection,
      ),

      // ===== 命名路由（可选用）=====
      routes: {
        '/landing': (_) => MindWellLandingPage(
              onOpenBooking: openAppointment,
              onOpenLogin: openRoleSelection,
            ),
        '/role': (_) => RoleSelectionPage(
              isDarkMode: _isDarkMode,
              onThemeChanged: (v) => setState(() => _isDarkMode = v),
            ),
        '/behavior': (_) => BehaviorTrackerPage(
              onThemeChanged: (v) => setState(() => _isDarkMode = v),
              isDarkMode: _isDarkMode,
            ),
        '/appointment': (_) => AppointmentMainPage(
              onThemeChanged: (v) => setState(() => _isDarkMode = v),
              isDarkMode: _isDarkMode,
            ),
        '/resources': (_) => const MyResourcePage(),
      },
    );
  }
}
