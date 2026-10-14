import 'package:flutter/material.dart';
import '../about/about_service_status_screen.dart';

class SettingsPrivacySecurityScreen extends StatefulWidget {
  const SettingsPrivacySecurityScreen({super.key});

  @override
  State<SettingsPrivacySecurityScreen> createState() =>
      _SettingsPrivacySecurityScreenState();
}

class _SettingsPrivacySecurityScreenState
    extends State<SettingsPrivacySecurityScreen> {
  static const Color navy = Color(0xFF071B2C);
  static const Color navySoft = Color(0xFF123247);
  static const Color teal = Color(0xFF00C7B7);
  static const Color cyan = Color(0xFF21D4FD);
  static const Color ice = Color(0xFFF4FBFD);
  static const Color white = Color(0xFFFFFFFF);
  static const Color softCyan = Color(0xFFDDFBFA);
  static const Color textDark = Color(0xFF12212D);
  static const Color textMuted = Color(0xFF6B7C88);
  static const Color lightBorder = Color(0xFFE1EDF1);
  static const Color success = Color(0xFF22C55E);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);

  bool _notifications = true;
  bool _serviceAlerts = true;
  bool _tripUpdates = true;
  bool _darkMode = false;
  bool _locationPermission = true;
  bool _notificationPermission = true;
  bool _analytics = true;
  bool _personalizedRoutes = true;
  bool _biometricLock = false;
  bool _rememberLogin = true;

  String _language = 'English';
  String _distanceUnit = 'Kilometers';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ice,
      body: Stack(
        children: [
          const _SettingsBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildHero(),
                  const SizedBox(height: 24),
                  _sectionTitle(
                    'App Settings',
                    'Control how MOVIRA looks and behaves',
                  ),
                  const SizedBox(height: 14),
                  _buildAppSettingsCard(),
                  const SizedBox(height: 24),
                  _sectionTitle(
                    'Notifications',
                    'Choose which updates you want to receive',
                  ),
                  const SizedBox(height: 14),
                  _buildNotificationCard(),
                  const SizedBox(height: 24),
                  _sectionTitle(
                    'Privacy & Permissions',
                    'Manage data access and device permissions',
                  ),
                  const SizedBox(height: 14),
                  _buildPrivacyCard(),
                  const SizedBox(height: 24),
                  _sectionTitle(
                    'Security',
                    'Protect your MOVIRA account',
                  ),
                  const SizedBox(height: 14),
                  _buildSecurityCard(),
                  const SizedBox(height: 24),
                  _buildAboutShortcut(),
                  const SizedBox(height: 24),
                  _buildAccountActions(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: lightBorder),
            ),
            child: const Icon(Icons.arrow_back_rounded, color: navy),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: lightBorder),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.asset(
              'assets/branding/movira_icon.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 11),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SETTINGS',
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Settings, privacy and security',
                style: TextStyle(
                  color: textMuted,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: softCyan,
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(Icons.settings_rounded, color: teal),
        ),
      ],
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [navy, navySoft, Color(0xFF15516A)],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(colors: [teal, cyan]),
            ),
            child: const Icon(
              Icons.admin_panel_settings_rounded,
              color: navy,
              size: 31,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You are in control',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Manage preferences, permissions, privacy and account security in one place.',
                  style: TextStyle(
                    color: Color(0xFFC7E3EF),
                    fontSize: 11.5,
                    height: 1.4,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppSettingsCard() {
    return _card(
      children: [
        _dropdownRow(
          icon: Icons.language_rounded,
          title: 'Language',
          subtitle: 'Choose app language',
          value: _language,
          color: teal,
          options: const ['English', 'Urdu'],
          onChanged: (value) {
            if (value != null) setState(() => _language = value);
          },
        ),
        const Divider(height: 24, color: Color(0xFFE7EEF1)),
        _dropdownRow(
          icon: Icons.straighten_rounded,
          title: 'Distance Unit',
          subtitle: 'Choose how distance is shown',
          value: _distanceUnit,
          color: cyan,
          options: const ['Kilometers', 'Miles'],
          onChanged: (value) {
            if (value != null) setState(() => _distanceUnit = value);
          },
        ),
        const Divider(height: 24, color: Color(0xFFE7EEF1)),
        _switchRow(
          icon: Icons.dark_mode_rounded,
          title: 'Dark Mode',
          subtitle: 'Use a darker visual theme',
          value: _darkMode,
          color: const Color(0xFF8B5CF6),
          onChanged: (v) => setState(() => _darkMode = v),
        ),
      ],
    );
  }

  Widget _buildNotificationCard() {
    return _card(
      children: [
        _switchRow(
          icon: Icons.notifications_active_rounded,
          title: 'Notifications',
          subtitle: 'Allow MOVIRA notifications',
          value: _notifications,
          color: teal,
          onChanged: (v) => setState(() => _notifications = v),
        ),
        const Divider(height: 24, color: Color(0xFFE7EEF1)),
        _switchRow(
          icon: Icons.warning_amber_rounded,
          title: 'Service Alerts',
          subtitle: 'Receive delay and route-change updates',
          value: _serviceAlerts,
          color: warning,
          onChanged: (v) => setState(() => _serviceAlerts = v),
        ),
        const Divider(height: 24, color: Color(0xFFE7EEF1)),
        _switchRow(
          icon: Icons.route_rounded,
          title: 'Trip Updates',
          subtitle: 'Receive reminders and journey updates',
          value: _tripUpdates,
          color: cyan,
          onChanged: (v) => setState(() => _tripUpdates = v),
        ),
      ],
    );
  }

  Widget _buildPrivacyCard() {
    return _card(
      children: [
        _switchRow(
          icon: Icons.location_on_rounded,
          title: 'Location Permission',
          subtitle: 'Allow location for nearby stops and tracking',
          value: _locationPermission,
          color: teal,
          onChanged: (v) => setState(() => _locationPermission = v),
        ),
        const Divider(height: 24, color: Color(0xFFE7EEF1)),
        _switchRow(
          icon: Icons.notifications_rounded,
          title: 'Notification Permission',
          subtitle: 'Allow system notifications',
          value: _notificationPermission,
          color: cyan,
          onChanged: (v) => setState(() => _notificationPermission = v),
        ),
        const Divider(height: 24, color: Color(0xFFE7EEF1)),
        _switchRow(
          icon: Icons.analytics_outlined,
          title: 'Usage Analytics',
          subtitle: 'Share anonymous app usage data',
          value: _analytics,
          color: const Color(0xFF8B5CF6),
          onChanged: (v) => setState(() => _analytics = v),
        ),
        const Divider(height: 24, color: Color(0xFFE7EEF1)),
        _switchRow(
          icon: Icons.auto_awesome_rounded,
          title: 'Personalized Routes',
          subtitle: 'Use preferences to improve recommendations',
          value: _personalizedRoutes,
          color: success,
          onChanged: (v) => setState(() => _personalizedRoutes = v),
        ),
      ],
    );
  }

  Widget _buildSecurityCard() {
    return _card(
      children: [
        _switchRow(
          icon: Icons.fingerprint_rounded,
          title: 'Biometric Lock',
          subtitle: 'Use fingerprint or face unlock',
          value: _biometricLock,
          color: teal,
          onChanged: (v) => setState(() => _biometricLock = v),
        ),
        const Divider(height: 24, color: Color(0xFFE7EEF1)),
        _switchRow(
          icon: Icons.login_rounded,
          title: 'Remember Login',
          subtitle: 'Keep this device signed in',
          value: _rememberLogin,
          color: cyan,
          onChanged: (v) => setState(() => _rememberLogin = v),
        ),
        const Divider(height: 24, color: Color(0xFFE7EEF1)),
        _actionRow(
          icon: Icons.lock_reset_rounded,
          title: 'Change Password',
          subtitle: 'Update your account password',
          color: warning,
          onTap: () => _message('Password change will connect with Firebase Auth later.'),
        ),
        const Divider(height: 24, color: Color(0xFFE7EEF1)),
        _actionRow(
          icon: Icons.devices_rounded,
          title: 'Active Sessions',
          subtitle: 'Review signed-in devices',
          color: const Color(0xFF8B5CF6),
          onTap: () => _message('Active sessions will connect with backend security later.'),
        ),
      ],
    );
  }

  Widget _buildAboutShortcut() {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AboutServiceStatusScreen(),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: lightBorder),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 46,
              height: 46,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: softCyan,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Icon(
                  Icons.info_outline_rounded,
                  color: teal,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About & Service Status',
                    style: TextStyle(
                      color: textDark,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'View app information, legal links and current service health.',
                    style: TextStyle(
                      color: textMuted,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_rounded,
              color: teal,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountActions() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _message('Logout will connect with Firebase Auth later.'),
            icon: const Icon(Icons.logout_rounded),
            label: const Text('Log Out'),
            style: OutlinedButton.styleFrom(
              foregroundColor: navy,
              side: const BorderSide(color: lightBorder),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => _message('Account deletion will require confirmation and backend handling later.'),
            icon: const Icon(Icons.delete_outline_rounded),
            label: const Text('Delete Account'),
            style: OutlinedButton.styleFrom(
              foregroundColor: error,
              side: BorderSide(color: error.withOpacity(0.25)),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _card({required List<Widget> children}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: lightBorder),
      ),
      child: Column(children: children),
    );
  }

  Widget _switchRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Color color,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: textDark,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: textMuted,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: teal,
        ),
      ],
    );
  }

  Widget _dropdownRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    required Color color,
    required List<String> options,
    required ValueChanged<String?> onChanged,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: textDark,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: textMuted,
                  fontSize: 10.5,
                ),
              ),
            ],
          ),
        ),
        DropdownButton<String>(
          value: value,
          underline: const SizedBox.shrink(),
          items: options
              .map(
                (item) => DropdownMenuItem(
              value: item,
              child: Text(
                item,
                style: const TextStyle(
                  color: textDark,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          )
              .toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _actionRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 21),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: textMuted,
                    fontSize: 10.5,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: textMuted,
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: textDark,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: const TextStyle(
            color: textMuted,
            fontSize: 11.5,
          ),
        ),
      ],
    );
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }
}

class _SettingsBackground extends StatelessWidget {
  const _SettingsBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFF9FDFF),
                Color(0xFFF0FAFD),
                Color(0xFFF7FCFD),
              ],
            ),
          ),
        ),
        Positioned(
          top: -110,
          right: -80,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF21D4FD).withOpacity(0.09),
            ),
          ),
        ),
        Positioned(
          bottom: -130,
          left: -100,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00C7B7).withOpacity(0.07),
            ),
          ),
        ),
      ],
    );
  }
}
