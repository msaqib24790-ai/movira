import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../services/user_profile_service.dart';
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

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  bool _isEmailVerified = false;
  String _displayName = 'Passenger';

  bool _accessibleRoutes = false;
  bool _lessWalking = true;
  bool _lowCrowd = false;
  bool _airConditioned = true;
  int _selectedPriority = 0;

  final List<String> _priorities = <String>[
    'Fastest',
    'Cheapest',
    'Fewer stops',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        if (!mounted) return;
        setState(() => _isLoading = false);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Please sign in to view your profile.'),
            ),
          );
        });
        return;
      }

      final profile = await UserProfileService.getProfile(user.uid);
      final rawPreferences = profile?['travelPreferences'];
      final Map<String, dynamic> preferences =
      rawPreferences is Map<String, dynamic>
          ? rawPreferences
          : <String, dynamic>{};

      final rawName = profile?['name'];
      final profileName = rawName is String ? rawName.trim() : '';
      final rawPhone = profile?['phone'];
      final profilePhone = rawPhone is String ? rawPhone : '';
      final authName = user.displayName?.trim() ?? '';
      final resolvedName = profileName.isNotEmpty ? profileName : authName;
      final rawPriority = preferences['priority'];
      final priority = rawPriority is String ? rawPriority : 'Fastest';
      final priorityIndex = _priorities.indexOf(priority);

      if (!mounted) return;
      setState(() {
        _nameController.text = resolvedName;
        _emailController.text = user.email ?? '';
        _phoneController.text = profilePhone;
        _displayName = resolvedName.isNotEmpty ? resolvedName : 'Passenger';
        _isEmailVerified = user.emailVerified;
        _accessibleRoutes = preferences['accessibleRoutes'] is bool
            ? preferences['accessibleRoutes'] as bool
            : false;
        _lessWalking = preferences['lessWalking'] is bool
            ? preferences['lessWalking'] as bool
            : true;
        _lowCrowd = preferences['lowCrowd'] is bool
            ? preferences['lowCrowd'] as bool
            : false;
        _airConditioned = preferences['airConditioned'] is bool
            ? preferences['airConditioned'] as bool
            : true;
        _selectedPriority = priorityIndex >= 0 ? priorityIndex : 0;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not load your profile. Please try again.'),
          ),
        );
      });
    }
  }

  Future<void> _saveProfile() async {
    if (_isSaving || _isLoading) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in before saving your profile.'),
        ),
      );
      return;
    }

    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();

    if (name.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid name.')),
      );
      return;
    }

    if (phone.isNotEmpty &&
        phone.replaceAll(RegExp(r'\D'), '').length < 7) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number.')),
      );
      return;
    }

    setState(() => _isSaving = true);

    try {
      await user.updateDisplayName(name);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(
        <String, dynamic>{
          'uid': user.uid,
          'name': name,
          'email': user.email ?? '',
          'phone': phone,
          'travelPreferences': <String, dynamic>{
            'priority': _priorities[_selectedPriority],
            'accessibleRoutes': _accessibleRoutes,
            'lessWalking': _lessWalking,
            'lowCrowd': _lowCrowd,
            'airConditioned': _airConditioned,
          },
          'updatedAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      if (!mounted) return;
      setState(() {
        _displayName = name;
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile and travel preferences saved successfully.'),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Could not save your profile. Check your connection and permissions.',
          ),
        ),
      );
    }
  }

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
      MaterialPageRoute<void>(
        builder: (context) => const SettingsPrivacySecurityScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ice,
      body: Stack(
        children: <Widget>[
          const _ProfileBackground(),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(color: teal),
            )
          else
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 34),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
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
      children: <Widget>[
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
            children: <Widget>[
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
          child: const Icon(Icons.person_rounded, color: teal),
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
          colors: <Color>[navy, navySoft, Color(0xFF15516A)],
        ),
      ),
      child: Row(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: <Color>[teal, cyan]),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'MOVIRA Passenger',
                  style: TextStyle(
                    color: Color(0xFFC7E3EF),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 9),
                Row(
                  children: <Widget>[
                    Icon(
                      _isEmailVerified
                          ? Icons.verified_rounded
                          : Icons.info_outline_rounded,
                      color: _isEmailVerified ? success : Colors.orangeAccent,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isEmailVerified
                          ? 'Verified account'
                          : 'Email not verified',
                      style: const TextStyle(
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
          children: <Widget>[
            SizedBox(
              width: 46,
              height: 46,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: softCyan,
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                ),
                child: Icon(Icons.settings_rounded, color: teal),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
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
                    style: TextStyle(color: textMuted, fontSize: 10.5),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_rounded, color: teal, size: 20),
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
        children: <Widget>[
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
            readOnly: true,
          ),
          const SizedBox(height: 12),
          _inputField(
            controller: _phoneController,
            label: 'Phone Number',
            icon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
          ),
        ],
      ),
    );
  }

  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: textMuted, fontSize: 11.5),
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
      children: List<Widget>.generate(_priorities.length, (index) {
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
                  border: Border.all(color: selected ? navy : lightBorder),
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
        children: <Widget>[
          _optionRow(
            icon: Icons.accessible_rounded,
            title: 'Accessible routes',
            subtitle: 'Prefer wheelchair-friendly services',
            value: _accessibleRoutes,
            color: const Color(0xFF8B5CF6),
            onChanged: (value) => setState(() => _accessibleRoutes = value),
          ),
          const Divider(height: 24, color: Color(0xFFE7EEF1)),
          _optionRow(
            icon: Icons.directions_walk_rounded,
            title: 'Less walking',
            subtitle: 'Reduce walking between stops',
            value: _lessWalking,
            color: teal,
            onChanged: (value) => setState(() => _lessWalking = value),
          ),
          const Divider(height: 24, color: Color(0xFFE7EEF1)),
          _optionRow(
            icon: Icons.groups_rounded,
            title: 'Low crowd preference',
            subtitle: 'Prefer less crowded buses when possible',
            value: _lowCrowd,
            color: cyan,
            onChanged: (value) => setState(() => _lowCrowd = value),
          ),
          const Divider(height: 24, color: Color(0xFFE7EEF1)),
          _optionRow(
            icon: Icons.ac_unit_rounded,
            title: 'Air-conditioned buses',
            subtitle: 'Prefer AC-enabled buses',
            value: _airConditioned,
            color: const Color(0xFF0EA5E9),
            onChanged: (value) => setState(() => _airConditioned = value),
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
      children: <Widget>[
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: color, size: 21),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
        Switch(
          value: value,
          activeThumbColor: teal,
          onChanged: onChanged,
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
        children: <Widget>[
          _summaryRow(
            Icons.route_rounded,
            'Route priority',
            _priorities[_selectedPriority],
          ),
          const Divider(height: 24, color: Color(0xFF24485E)),
          _summaryRow(
            Icons.directions_walk_rounded,
            'Walking preference',
            _lessWalking ? 'Less walking' : 'Standard',
          ),
          const Divider(height: 24, color: Color(0xFF24485E)),
          _summaryRow(
            Icons.ac_unit_rounded,
            'Bus comfort',
            _airConditioned ? 'AC preferred' : 'Any bus',
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(IconData icon, String label, String value) {
    return Row(
      children: <Widget>[
        Icon(icon, color: cyan, size: 20),
        const SizedBox(width: 11),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFFB8D8E8), fontSize: 11.5),
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
        gradient: const LinearGradient(colors: <Color>[teal, cyan]),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: (_isSaving || _isLoading) ? null : _saveProfile,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_isSaving)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: navy,
                  ),
                )
              else
                const Icon(Icons.save_rounded, color: navy),
              const SizedBox(width: 9),
              Text(
                _isSaving ? 'Saving...' : 'Save Profile & Preferences',
                style: const TextStyle(
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
      children: <Widget>[
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
}

class _ProfileBackground extends StatelessWidget {
  const _ProfileBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
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
              color: const Color(0xFF21D4FD).withValues(alpha: 0.09),
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
              color: const Color(0xFF00C7B7).withValues(alpha: 0.07),
            ),
          ),
        ),
      ],
    );
  }
}
