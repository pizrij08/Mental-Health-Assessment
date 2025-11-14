import 'package:flutter/material.dart';
import 'package:flutter_application_mhproj/design_system/components/common_widgets.dart';
import 'package:flutter_application_mhproj/design_system/tokens/color_tokens.dart';
import 'package:flutter_application_mhproj/design_system/tokens/typography.dart';
import 'package:flutter_application_mhproj/features/clinic/presentation/clinic_dashboard_page.dart';
import 'package:flutter_application_mhproj/features/user/presentation/user_main_page.dart';
import 'package:flutter_application_mhproj/features/admin/presentation/admin_dashboard_page.dart';
import 'package:flutter_application_mhproj/models/models.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.role, required this.onThemeChanged});
  final Role role;
  final ValueChanged<bool> onThemeChanged;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  bool _obscure = true;

  String get _title => switch (widget.role) {
        Role.user => 'User Login',
        Role.clinic => 'Clinic Login',
        Role.admin => 'Admin Login',
      };

  @override
  void dispose() {
    _idController.dispose();
    _pwdController.dispose();
    super.dispose();
  }

  void _onLogin() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (widget.role) {
      case Role.user:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => UserMainPage(
              userName: _idController.text.isNotEmpty ? _idController.text : 'User',
              isDarkMode: isDark,
              onThemeChanged: widget.onThemeChanged,
            ),
          ),
        );
        break;
      case Role.clinic:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ClinicDashboardPage(onThemeChanged: widget.onThemeChanged)),
        );
        break;
      case Role.admin:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AdminDashboardPage(onThemeChanged: widget.onThemeChanged)),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: MindWellColors.cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(_title, style: MindWellTypography.sectionSubtitle(color: MindWellColors.darkGray).copyWith(fontSize: 22)),
        actions: [
          Switch(value: isDark, onChanged: widget.onThemeChanged),
          Padding(padding: const EdgeInsets.only(right: 8), child: Text(isDark ? '☾' : '☀')),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Secure Access',
                  textAlign: TextAlign.center,
                  style: MindWellTypography.sectionSubtitle(color: MindWellColors.darkGray).copyWith(fontSize: 28),
                ),
                const SizedBox(height: 10),
                Text(
                  'Enter your credentials to continue to the MindWell experience.',
                  textAlign: TextAlign.center,
                  style: MindWellTypography.body(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 32),
                InputCard(
                  child: TextField(
                    controller: _idController,
                    decoration: InputDecoration(
                      labelText: widget.role == Role.user ? 'NRIC/Passport Number (without dashes)' : 'Account / Email',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      labelStyle: MindWellTypography.body(color: MindWellColors.darkGray),
                    ),
                    style: MindWellTypography.body(color: MindWellColors.darkGray),
                  ),
                ),
                const SizedBox(height: 16),
                InputCard(
                  child: TextField(
                    controller: _pwdController,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.all(16),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: MindWellColors.darkGray),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      labelStyle: MindWellTypography.body(color: MindWellColors.darkGray),
                    ),
                    style: MindWellTypography.body(color: MindWellColors.darkGray),
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 54)),
                  onPressed: _onLogin,
                  child: Text('Login'.toUpperCase(), style: MindWellTypography.button(color: MindWellColors.cream).copyWith(fontSize: 14)),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Forgot Password? coming soon'))),
                  child: Text('Forgot Password?', style: MindWellTypography.body(color: MindWellColors.darkGray)),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CopyrightBar(),
    );
  }
}
