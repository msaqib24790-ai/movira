import 'package:flutter/material.dart';

class AboutServiceStatusScreen extends StatefulWidget {
  const AboutServiceStatusScreen({super.key});

  @override
  State<AboutServiceStatusScreen> createState() =>
      _AboutServiceStatusScreenState();
}

class _AboutServiceStatusScreenState extends State<AboutServiceStatusScreen> {
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

  bool _offlineMode = false;
  bool _simulateError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ice,
      body: Stack(
        children: [
          const _AboutBackground(),
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
                    'About MOVIRA',
                    'App information and legal details',
                  ),
                  const SizedBox(height: 14),
                  _buildAboutCard(),
                  const SizedBox(height: 24),
                  _sectionTitle(
                    'Service Status',
                    'Current system and transport availability',
                  ),
                  const SizedBox(height: 14),
                  _buildServiceStatusCard(),
                  const SizedBox(height: 24),
                  _sectionTitle(
                    'Offline & Error Handling',
                    'How MOVIRA behaves when services are unavailable',
                  ),
                  const SizedBox(height: 14),
                  _buildOfflineCard(),
                  const SizedBox(height: 24),
                  _buildSystemMessage(),
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
                'ABOUT & STATUS',
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'App information and service health',
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
          child: const Icon(Icons.info_outline_rounded, color: teal),
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
              Icons.directions_bus_filled_rounded,
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
                  'MOVIRA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Move Smarter. Travel Better.',
                  style: TextStyle(
                    color: Color(0xFFC7E3EF),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Production-ready public transport companion for smarter journeys.',
                  style: TextStyle(
                    color: Color(0xFFA9C8D7),
                    fontSize: 10.5,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutCard() {
    return _card(
      children: [
        _infoRow(Icons.apps_rounded, 'App Version', '1.0.0'),
        const Divider(height: 24, color: Color(0xFFE7EEF1)),
        _infoRow(Icons.code_rounded, 'Build', 'Production UI'),
        const Divider(height: 24, color: Color(0xFFE7EEF1)),
        _actionRow(
          Icons.description_outlined,
          'Terms of Service',
          'Read MOVIRA terms and conditions',
          teal,
              () => _message('Terms of Service will open here later.'),
        ),
        const Divider(height: 24, color: Color(0xFFE7EEF1)),
        _actionRow(
          Icons.privacy_tip_outlined,
          'Privacy Policy',
          'Review how MOVIRA handles user data',
          cyan,
              () => _message('Privacy Policy will open here later.'),
        ),
      ],
    );
  }

  Widget _buildServiceStatusCard() {
    return _card(
      children: [
        _statusRow(
          icon: Icons.cloud_done_rounded,
          title: 'Core Services',
          subtitle: 'Main MOVIRA services',
          status: 'Operational',
          color: success,
        ),
        const Divider(height: 24, color: Color(0xFFE7EEF1)),
        _statusRow(
          icon: Icons.location_on_rounded,
          title: 'Location Services',
          subtitle: 'Maps and location access',
          status: 'Operational',
          color: success,
        ),
        const Divider(height: 24, color: Color(0xFFE7EEF1)),
        _statusRow(
          icon: Icons.directions_bus_rounded,
          title: 'Transit Data',
          subtitle: 'Routes, schedules and bus status',
          status: 'Limited Demo',
          color: warning,
        ),
        const Divider(height: 24, color: Color(0xFFE7EEF1)),
        _statusRow(
          icon: Icons.notifications_rounded,
          title: 'Notifications',
          subtitle: 'Alerts and trip reminders',
          status: 'Operational',
          color: success,
        ),
      ],
    );
  }

  Widget _buildOfflineCard() {
    return _card(
      children: [
        _switchRow(
          icon: Icons.offline_bolt_rounded,
          title: 'Offline Mode',
          subtitle: 'Use cached routes and saved trip information',
          value: _offlineMode,
          color: teal,
          onChanged: (value) {
            setState(() {
              _offlineMode = value;
            });
          },
        ),
        const Divider(height: 24, color: Color(0xFFE7EEF1)),
        _switchRow(
          icon: Icons.error_outline_rounded,
          title: 'Simulate Error State',
          subtitle: 'Preview app error handling UI',
          value: _simulateError,
          color: error,
          onChanged: (value) {
            setState(() {
              _simulateError = value;
            });
          },
        ),
        const Divider(height: 24, color: Color(0xFFE7EEF1)),
        _actionRow(
          Icons.refresh_rounded,
          'Retry Services',
          'Reconnect to MOVIRA services',
          cyan,
              () => _message('Service retry started.'),
        ),
      ],
    );
  }

  Widget _buildSystemMessage() {
    final bool problem = _offlineMode || _simulateError;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: problem
            ? const Color(0xFFFFF7E8)
            : const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: problem
              ? warning.withOpacity(0.25)
              : success.withOpacity(0.20),
        ),
      ),
      child: Row(
        children: [
          Icon(
            problem
                ? Icons.info_outline_rounded
                : Icons.check_circle_rounded,
            color: problem ? warning : success,
            size: 25,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _simulateError
                  ? 'A simulated service error is active. Retry actions remain available.'
                  : _offlineMode
                  ? 'Offline mode is active. Saved routes and cached information remain available.'
                  : 'All available MOVIRA services are currently ready.',
              style: TextStyle(
                color: problem
                    ? const Color(0xFF8A5A12)
                    : const Color(0xFF166534),
                fontSize: 11,
                height: 1.4,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
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

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: softCyan,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: teal, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: textDark,
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: textMuted,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _statusRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required String status,
    required Color color,
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
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: color.withOpacity(0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Text(
            status,
            style: TextStyle(
              color: color,
              fontSize: 9.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
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

  Widget _actionRow(
      IconData icon,
      String title,
      String subtitle,
      Color color,
      VoidCallback onTap,
      ) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
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

class _AboutBackground extends StatelessWidget {
  const _AboutBackground();

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
