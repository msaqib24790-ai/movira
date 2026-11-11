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
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LegalDocumentScreen(
                documentType: LegalDocumentType.terms,
              ),
            ),
          ),
        ),
        const Divider(height: 24, color: Color(0xFFE7EEF1)),
        _actionRow(
          Icons.privacy_tip_outlined,
          'Privacy Policy',
          'Review how MOVIRA handles user data',
          cyan,
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const LegalDocumentScreen(
                documentType: LegalDocumentType.privacy,
              ),
            ),
          ),
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
          subtitle: 'App interface and local features',
          status: 'App loaded',
          color: success,
        ),
        const Divider(height: 24, color: Color(0xFFE7EEF1)),
        _statusRow(
          icon: Icons.location_on_rounded,
          title: 'Location Services',
          subtitle: 'Depends on device permissions',
          status: 'Permission-based',
          color: warning,
        ),
        const Divider(height: 24, color: Color(0xFFE7EEF1)),
        _statusRow(
          icon: Icons.directions_bus_rounded,
          title: 'Transit Data',
          subtitle: 'Local routes and scheduled departures',
          status: 'Local data',
          color: success,
        ),
        const Divider(height: 24, color: Color(0xFFE7EEF1)),
        _statusRow(
          icon: Icons.notifications_rounded,
          title: 'Notifications',
          subtitle: 'Push alerts and trip reminders',
          status: 'Not configured',
          color: warning,
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
          'Transit Data Info',
          'View available transit data information',
          cyan,
          () => _message(
            'Transit schedules use local GTFS data. '
            'This action does not reconnect external services.',
          ),
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
        color: problem ? const Color(0xFFFFF7E8) : const Color(0xFFECFDF5),
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
            problem ? Icons.info_outline_rounded : Icons.check_circle_rounded,
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
                  : 'Local routes and scheduled departures are available. External live transit feeds and push notifications are not configured.',
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
                style: const TextStyle(color: textMuted, fontSize: 10.5),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                style: const TextStyle(color: textMuted, fontSize: 10.5),
              ),
            ],
          ),
        ),
        Switch(value: value, onChanged: onChanged, activeColor: teal),
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
                  style: const TextStyle(color: textMuted, fontSize: 10.5),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded, color: textMuted),
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
          style: const TextStyle(color: textMuted, fontSize: 11.5),
        ),
      ],
    );
  }

  void _message(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
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
              colors: [Color(0xFFF9FDFF), Color(0xFFF0FAFD), Color(0xFFF7FCFD)],
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

// -----------------------------------------------------------------------------
// Legal document screens
// -----------------------------------------------------------------------------

enum LegalDocumentType { terms, privacy }

class LegalDocumentScreen extends StatelessWidget {
  final LegalDocumentType documentType;

  const LegalDocumentScreen({super.key, required this.documentType});

  static const Color navy = Color(0xFF071B2C);
  static const Color teal = Color(0xFF00C7B7);
  static const Color cyan = Color(0xFF21D4FD);
  static const Color ice = Color(0xFFF4FBFD);
  static const Color textDark = Color(0xFF12212D);
  static const Color textMuted = Color(0xFF6B7C88);
  static const Color border = Color(0xFFE1EDF1);

  bool get isPrivacy => documentType == LegalDocumentType.privacy;

  String get pageTitle => isPrivacy ? 'Privacy Policy' : 'Terms of Service';

  String get subtitle => isPrivacy
      ? 'How MOVIRA handles information and device permissions'
      : 'The conditions for using the MOVIRA application';

  List<_LegalSection> get _sections =>
      isPrivacy ? _privacySections : _termsSections;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ice,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 8, 18, 28),
                children: [
                  _buildIntroduction(),
                  const SizedBox(height: 16),
                  ..._sections.map(_buildSection),
                  const SizedBox(height: 16),
                  _buildContactCard(),
                  const SizedBox(height: 12),
                  const Center(
                    child: Text(
                      'MOVIRA — Move Smarter. Travel Better.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textMuted,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: border)),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () => Navigator.pop(context),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: ice,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: border),
              ),
              child: const Icon(Icons.arrow_back_rounded, color: navy),
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  pageTitle,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  maxLines: 2,
                  style: const TextStyle(color: textMuted, fontSize: 10.5),
                ),
              ],
            ),
          ),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFDDFBFA),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              isPrivacy
                  ? Icons.privacy_tip_outlined
                  : Icons.description_outlined,
              color: teal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroduction() {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [navy, Color(0xFF123247), Color(0xFF15516A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.directions_bus_filled_rounded,
                color: cyan,
                size: 23,
              ),
              const SizedBox(width: 9),
              const Text(
                'MOVIRA',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          Text(
            isPrivacy ? 'Your information matters.' : 'Welcome to MOVIRA.',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            isPrivacy
                ? 'This policy explains the information used by the current MOVIRA application, why it is needed, and the services involved.'
                : 'These terms explain the basic conditions and limitations that apply when you access or use MOVIRA.',
            style: const TextStyle(
              color: Color(0xFFD5E8EF),
              fontSize: 12,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 13),
          const Text(
            'Last updated: 11 November 2026',
            style: TextStyle(
              color: Color(0xFF9EDBD9),
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(_LegalSection section) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFDDFBFA),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(section.icon, color: teal, size: 17),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    section.title,
                    style: const TextStyle(
                      color: navy,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...section.paragraphs.map(
            (paragraph) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                paragraph,
                style: const TextStyle(
                  color: textDark,
                  fontSize: 11.5,
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFDDFBFA),
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: teal.withValues(alpha: 0.18)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Questions or concerns?',
            style: TextStyle(
              color: navy,
              fontSize: 13.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 7),
          Text(
            'Contact MOVIRA Support at supportmovira82q@gmail.com for questions about these documents or requests concerning your account information.',
            style: TextStyle(color: textDark, fontSize: 11.5, height: 1.55),
          ),
          SizedBox(height: 7),
          SelectableText(
            'supportmovira82q@gmail.com',
            style: TextStyle(
              color: Color(0xFF087F78),
              fontSize: 11.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Privacy Policy
  // ---------------------------------------------------------------------------

  static const List<_LegalSection> _privacySections = [
    _LegalSection('1. Information we use', Icons.person_outline_rounded, [
      'When you create an account, MOVIRA processes information such as your name, email address and phone number.',
      'Your account identifier and profile information are stored in Firebase services used by the application. Email and password authentication is handled through Firebase Authentication. Google sign-in is also supported.',
      'MOVIRA does not intentionally request your payment card details through the account and profile features inspected for this policy.',
    ]),
    _LegalSection(
      '2. Travel preferences and saved trips',
      Icons.route_rounded,
      [
        'If you use profile and travel preference features, MOVIRA stores preferences such as route priority, accessibility needs, reduced walking, lower-crowd preference and air-conditioned travel preference.',
        'Saved trips may contain your trip identifier, starting point, destination and creation or update timestamps. These records are stored under your user account in Firestore.',
        'Support requests may contain a request type, title, description, details, status, optional rating and timestamps.',
      ],
    ),
    _LegalSection('3. Location information', Icons.location_on_outlined, [
      'Nearby Stops can request your device location to calculate distances between your position and locally available transit stops. The inspected Nearby Stops feature performs these distance calculations on the device.',
      'A separate driver live-location feature is available only to drivers whose account has the required authorization and active-trip assignment. When used, it can send latitude, longitude, accuracy and update time to the MOVIRA Firestore database.',
      'The current Firestore access configuration permits signed-in users to read active-trip live-location records. Do not use this feature with an expectation that location visibility is restricted only to one assigned passenger.',
      'Location access depends on device settings and permissions. You can manage app location permission through your device settings.',
    ]),
    _LegalSection(
      '4. Notifications and device information',
      Icons.notifications_outlined,
      [
        'MOVIRA can request notification permission to deliver push notifications and local trip reminders.',
        'When Firebase Messaging registers a device, the application stores its installation identifier, platform information and an update timestamp in the signed-in user account.',
        'Local trip reminders may be scheduled on your device. Notification delivery depends on device permissions, operating-system settings, network availability and the relevant service.',
      ],
    ),
    _LegalSection('5. Why information is used', Icons.info_outline_rounded, [
      'Information is used to create and authenticate accounts, maintain user profiles, save trips and preferences, process support requests, provide relevant transport features, and support authorized driver live-location functionality.',
      'Firebase and Google services may process information as part of authentication, database, sign-in and messaging operations. Their own terms and privacy documentation may also apply.',
    ]),
    _LegalSection('6. Analytics and preference controls', Icons.tune_rounded, [
      'The inspected application source does not show a dedicated Firebase Analytics, Crashlytics, Mixpanel or Sentry integration. This statement describes the inspected application code and is not a guarantee about diagnostics or processing performed by third-party platform services.',
      'Some switches displayed in the Privacy & Security screen currently change their on-screen state only. They are not yet connected to actual analytics collection controls or operating-system permission management. Do not rely on those switches to change device permissions or disable data processing.',
    ]),
    _LegalSection('7. Sharing and service providers', Icons.cloud_outlined, [
      'MOVIRA uses Firebase services for authentication, database and messaging functions, and Google sign-in for supported account access. Information may be processed by these providers to deliver their services.',
      'If you choose to contact support using WhatsApp or your email application, the selected external service handles that communication under its own policies. MOVIRA does not automatically send the prefilled message without your action.',
      'We do not describe your information as being sold or shared for advertising purposes through a dedicated advertising integration in the inspected application code.',
    ]),
    _LegalSection('8. Storage, security and retention', Icons.shield_outlined, [
      'Account, saved-trip, support, device and live-location records may be stored in Firebase Firestore or Firebase Authentication as applicable to each feature.',
      'MOVIRA uses Firebase security rules to restrict access to several user-owned records. No online service can guarantee absolute security, and you should protect your sign-in credentials and device.',
      'The application does not currently provide a working in-app account deletion flow. Retention periods and deletion handling may depend on the relevant service and operational procedures. Contact support to ask about an account or information request; do not assume a request has been fulfilled until it is confirmed.',
    ]),
    _LegalSection(
      '9. Your choices and requests',
      Icons.manage_accounts_outlined,
      [
        'You can manage app permissions through your device settings and choose whether to use optional features that request location or notifications.',
        'For questions, correction requests or account-related data requests, contact supportmovira82q@gmail.com. Requests may require account verification and may be subject to technical, operational or legal limitations.',
      ],
    ),
    _LegalSection('10. Children and policy updates', Icons.policy_outlined, [
      'MOVIRA is a general transport application and is not specifically designed to collect personal information from children. A parent or guardian should contact support if they believe a child has provided information inappropriately.',
      'This policy may be revised as application features, service providers or legal requirements change. The updated date shown at the top indicates the latest stated revision.',
    ]),
  ];

  // ---------------------------------------------------------------------------
  // Terms of Service
  // ---------------------------------------------------------------------------

  static const List<_LegalSection> _termsSections = [
    _LegalSection('1. Acceptance of these terms', Icons.handshake_outlined, [
      'By accessing or using MOVIRA, you agree to these Terms of Service. If you do not agree, you should stop using the application.',
      'These terms apply to your use of the MOVIRA application and its available features. Additional terms from third-party services may apply when you use those services.',
    ]),
    _LegalSection('2. About MOVIRA', Icons.directions_bus_outlined, [
      'MOVIRA is a transport information and journey-planning companion intended to help users explore routes, stops, schedules, saved trips and related travel features.',
      'Available features may change as the application is developed. Some screens or controls may be experimental, unavailable or not connected to a live service.',
    ]),
    _LegalSection('3. Accounts and security', Icons.account_circle_outlined, [
      'You are responsible for providing accurate account information and protecting access to your account and device.',
      'You must not impersonate another person, misuse another user account, attempt unauthorized access, or interfere with application services.',
      'Email/password and Google sign-in are supported through the authentication services configured by MOVIRA. Keep your credentials secure and contact support if you suspect unauthorized account access.',
    ]),
    _LegalSection(
      '4. Transport information and accuracy',
      Icons.schedule_outlined,
      [
        'Routes, stops and scheduled departures may be based on locally bundled transit data. Such information may be incomplete, outdated or different from actual operator services.',
        'Estimated journey details, route suggestions and schedules are provided for general guidance. MOVIRA does not guarantee that a vehicle will arrive, a route will operate, or a displayed schedule will be followed.',
        'Always verify important journey details with the relevant transport operator and use your own judgment when travelling.',
      ],
    ),
    _LegalSection('5. Location and live tracking', Icons.my_location_rounded, [
      'Some features require device location permission. You are responsible for deciding whether to grant location access through your device settings.',
      'Driver live-location sharing is intended for authorized drivers assigned to an active trip. If you are granted this access, you must use it only for legitimate trip operations and must not falsify, misuse or unlawfully disclose location information.',
      'Live-location availability and accuracy depend on device hardware, permissions, connectivity and service availability. MOVIRA does not guarantee uninterrupted or exact tracking.',
    ]),
    _LegalSection(
      '6. Notifications and reminders',
      Icons.notifications_active_outlined,
      [
        'Notifications and local reminders are convenience features. Delivery or timing may be affected by device settings, permissions, battery restrictions, network conditions or third-party services.',
        'You remain responsible for checking your journey details and departure time. Do not rely solely on a notification for time-critical travel.',
      ],
    ),
    _LegalSection('7. Acceptable use', Icons.verified_user_outlined, [
      'You agree not to use MOVIRA for unlawful activities, harassment, fraud, unauthorized data access, service disruption or any activity that could harm other users.',
      'You must not attempt to reverse engineer, disrupt, overload or interfere with the application or its backend services except where applicable law permits.',
      'You must not submit false, abusive, threatening or unlawful material through support and feedback features.',
    ]),
    _LegalSection('8. Third-party services', Icons.link_rounded, [
      'MOVIRA relies on third-party services such as Firebase, Google sign-in, device location services and notification infrastructure. Their availability and operation may be governed by their own terms and policies.',
      'MOVIRA is not responsible for outages or changes caused by external providers or transport operators, to the extent permitted by applicable law.',
    ]),
    _LegalSection('9. Availability and changes', Icons.build_circle_outlined, [
      'MOVIRA is provided subject to service availability. Features may be changed, suspended, limited or discontinued for maintenance, security, technical or operational reasons.',
      'Some controls shown in the application may not yet be connected to a functioning backend service. In particular, in-app password change, active-session management and account deletion are not currently implemented as working flows.',
    ]),
    _LegalSection(
      '10. Disclaimer and limitation',
      Icons.warning_amber_rounded,
      [
        'MOVIRA is an informational travel companion, not a transport operator, emergency service or guarantee of transportation.',
        'To the extent permitted by applicable law, MOVIRA is not liable for losses caused by inaccurate third-party transport information, missed departures, service interruptions, device failures or network outages.',
        'Nothing in these terms excludes rights or liabilities that cannot legally be excluded under applicable law.',
      ],
    ),
    _LegalSection('11. Suspension and termination', Icons.block_outlined, [
      'MOVIRA may restrict access where reasonably necessary to protect users, services or security, or to address misuse and legal requirements.',
      'The current application does not provide a working self-service account deletion flow. Contact support for account-related questions or requests.',
    ]),
    _LegalSection('12. Updates and contact', Icons.mail_outline_rounded, [
      'These terms may be updated as MOVIRA changes. Continued use after an updated version is made available indicates acceptance of the revised terms, to the extent permitted by applicable law.',
      'For questions about these terms, contact supportmovira82q@gmail.com.',
    ]),
  ];
}

class _LegalSection {
  final String title;
  final IconData icon;
  final List<String> paragraphs;

  const _LegalSection(this.title, this.icon, this.paragraphs);
}
