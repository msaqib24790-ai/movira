import 'package:flutter/material.dart';
import '../settings/settings_privacy_security_screen.dart';

class ProfileTravelPreferencesScreen extends StatefulWidget {
  const ProfileTravelPreferencesScreen({super.key});

  @override
  State<ProfileTravelPreferencesScreen> createState() =>
      _ProfileTravelPreferencesScreenState();
}

class _ProfileTravelPreferencesScreenState
    extends State<ProfileTravelPreferencesScreen> {
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

  final TextEditingController _nameController =
  TextEditingController(text: 'Muhammad Saqib');
  final TextEditingController _emailController =
  TextEditingController(text: 'saqib@example.com');
  final TextEditingController _phoneController =
  TextEditingController(text: '+92 300 1234567');

  bool _accessibleRoutes = false;
  bool _lessWalking = true;
  bool _lowCrowd = false;
  bool _airConditioned = true;
  int _selectedPriority = 0;

  final List<String> _priorities = [
    'Fastest',
    'Cheapest',
    'Fewer stops',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsPrivacySecurityScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ice,
      body: Stack(
        children: [
          const _ProfileBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildProfileHero(),
                  const SizedBox(height: 16),
                  _buildSettingsShortcut(),
                  const SizedBox(height: 24),
                  _sectionTitle(
                    'Profile Information',
                    'Keep your personal details up to date',
                  ),
                  const SizedBox(height: 14),
                  _buildProfileForm(),
                  const SizedBox(height: 24),
                  _sectionTitle(
                    'Travel Preferences',
                    'Personalize route recommendations',
                  ),
                  const SizedBox(height: 14),
                  _buildPrioritySelector(),
                  const SizedBox(height: 18),
                  _buildTravelOptions(),
                  const SizedBox(height: 24),
                  _sectionTitle(
                    'Favorite Travel Settings',
                    'Preferences MOVIRA will remember',
                  ),
                  const SizedBox(height: 14),
                  _buildPreferenceSummary(),
                  const SizedBox(height: 24),
                  _buildSaveButton(),
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
            child: const Icon(
              Icons.arrow_back_rounded,
              color: navy,
            ),
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
                'PROFILE',
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Profile and travel preferences',
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
          child: const Icon(
            Icons.person_rounded,
            color: teal,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHero() {
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
          Stack(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [teal, cyan],
                  ),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  color: navy,
                  size: 38,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: white,
                    shape: BoxShape.circle,
                    border: Border.all(color: navySoft, width: 2),
                  ),
                  child: const Icon(
                    Icons.edit_rounded,
                    color: teal,
                    size: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Muhammad Saqib',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'MOVIRA Passenger',
                  style: TextStyle(
                    color: Color(0xFFC7E3EF),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 9),
                Row(
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      color: success,
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Verified account',
                      style: TextStyle(
                        color: Color(0xFFC7E3EF),
                        fontSize: 10.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsShortcut() {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: _openSettings,
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
                  Icons.settings_rounded,
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
                    'Settings, Privacy & Security',
                    style: TextStyle(
                      color: textDark,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Manage app preferences, permissions and account security.',
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

  Widget _buildProfileForm() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: lightBorder),
      ),
      child: Column(
        children: [
          _inputField(
            controller: _nameController,
            label: 'Full Name',
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(height: 12),
          _inputField(
            controller: _emailController,
            label: 'Email',
            icon: Icons.email_outlined,
          ),
          const SizedBox(height: 12),
          _inputField(
            controller: _phoneController,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
          ),
        ],
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(
          color: textMuted,
          fontSize: 11.5,
        ),
        prefixIcon: Icon(icon, color: teal),
        filled: true,
        fillColor: const Color(0xFFF7FBFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: lightBorder),
        ),
      ),
    );
  }

  Widget _buildPrioritySelector() {
    return Row(
      children: List.generate(_priorities.length, (index) {
        final selected = _selectedPriority == index;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == _priorities.length - 1 ? 0 : 8,
            ),
            child: GestureDetector(
              onTap: () => setState(() => _selectedPriority = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: selected ? navy : white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected ? navy : lightBorder,
                  ),
                ),
                child: Text(
                  _priorities[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? Colors.white : textMuted,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTravelOptions() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: lightBorder),
      ),
      child: Column(
        children: [
          _optionRow(
            icon: Icons.accessible_rounded,
            title: 'Accessible routes',
            subtitle: 'Prefer wheelchair-friendly services',
            value: _accessibleRoutes,
            color: const Color(0xFF8B5CF6),
            onChanged: (v) => setState(() => _accessibleRoutes = v),
          ),
          const Divider(height: 24, color: Color(0xFFE7EEF1)),
          _optionRow(
            icon: Icons.directions_walk_rounded,
            title: 'Less walking',
            subtitle: 'Reduce walking between stops',
            value: _lessWalking,
            color: teal,
            onChanged: (v) => setState(() => _lessWalking = v),
          ),
          const Divider(height: 24, color: Color(0xFFE7EEF1)),
          _optionRow(
            icon: Icons.groups_rounded,
            title: 'Low crowd preference',
            subtitle: 'Prefer less crowded buses when possible',
            value: _lowCrowd,
            color: cyan,
            onChanged: (v) => setState(() => _lowCrowd = v),
          ),
          const Divider(height: 24, color: Color(0xFFE7EEF1)),
          _optionRow(
            icon: Icons.ac_unit_rounded,
            title: 'Air-conditioned buses',
            subtitle: 'Prefer AC-enabled buses',
            value: _airConditioned,
            color: const Color(0xFF0EA5E9),
            onChanged: (v) => setState(() => _airConditioned = v),
          ),
        ],
      ),
    );
  }

  Widget _optionRow({
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

  Widget _buildPreferenceSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: navySoft,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          _summaryRow(
            Icons.route_rounded,
            'Route priority',
            _priorities[_selectedPriority],
          ),
          const Divider(
            height: 24,
            color: Color(0xFF24485E),
          ),
          _summaryRow(
            Icons.directions_walk_rounded,
            'Walking preference',
            _lessWalking ? 'Less walking' : 'Standard',
          ),
          const Divider(
            height: 24,
            color: Color(0xFF24485E),
          ),
          _summaryRow(
            Icons.ac_unit_rounded,
            'Bus comfort',
            _airConditioned ? 'AC preferred' : 'Any bus',
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
      IconData icon,
      String label,
      String value,
      ) {
    return Row(
      children: [
        Icon(icon, color: cyan, size: 20),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: Color(0xFFB8D8E8),
              fontSize: 11.5,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 11.5,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [teal, cyan],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'Profile and travel preferences saved.',
                ),
              ),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.save_rounded,
                color: navy,
              ),
              SizedBox(width: 9),
              Text(
                'Save Profile & Preferences',
                style: TextStyle(
                  color: navy,
                  fontSize: 15.5,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
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
}

class _ProfileBackground extends StatelessWidget {
  const _ProfileBackground();

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
