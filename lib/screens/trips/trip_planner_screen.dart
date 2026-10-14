import 'package:flutter/material.dart';
import 'trip_summary_screen.dart';

class TripPlannerScreen extends StatefulWidget {
  const TripPlannerScreen({super.key});

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
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

  final TextEditingController _fromController =
  TextEditingController(text: 'Current Location');
  final TextEditingController _toController = TextEditingController();

  int _selectedTimeMode = 0;
  int _selectedPreference = 0;
  bool _accessible = false;
  bool _lowWalking = false;

  final List<String> _timeModes = ['Leave now', 'Depart at', 'Arrive by'];
  final List<String> _preferences = ['Fastest', 'Fewer stops', 'Cheapest'];

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _swapLocations() {
    final oldFrom = _fromController.text;
    setState(() {
      _fromController.text = _toController.text;
      _toController.text = oldFrom;
    });
  }

  void _planTrip() {
    if (_fromController.text.trim().isEmpty ||
        _toController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter both starting point and destination.'),
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TripSummaryScreen(
          from: _fromController.text.trim(),
          to: _toController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ice,
      body: Stack(
        children: [
          const _TripPlannerBackground(),
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
                  const Text(
                    'Plan your trip',
                    style: TextStyle(
                      color: textDark,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'Choose your journey, travel time and preferences.',
                    style: TextStyle(
                      color: textMuted,
                      fontSize: 13.5,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildRouteCard(),
                  const SizedBox(height: 24),
                  _sectionTitle('Travel Time', 'Choose when you want to travel'),
                  const SizedBox(height: 14),
                  _buildTimeModeSelector(),
                  const SizedBox(height: 24),
                  _sectionTitle(
                    'Route Preference',
                    'Tell MOVIRA what matters most',
                  ),
                  const SizedBox(height: 14),
                  _buildPreferenceSelector(),
                  const SizedBox(height: 24),
                  _sectionTitle('Trip Options', 'Customize your journey'),
                  const SizedBox(height: 14),
                  _buildOptionsCard(),
                  const SizedBox(height: 24),
                  _buildTripPreview(),
                  const SizedBox(height: 24),
                  _buildPlanTripButton(),
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
                'TRIP PLANNER',
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Plan a smarter journey',
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
          child: const Icon(Icons.alt_route_rounded, color: teal),
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
            child: const Icon(Icons.route_rounded, color: navy, size: 32),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart journey planning',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Compare routes, times and travel preferences in one place.',
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
          const Icon(Icons.chevron_right_rounded, color: cyan, size: 28),
        ],
      ),
    );
  }

  Widget _buildRouteCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: lightBorder),
      ),
      child: Column(
        children: [
          _locationField(
            controller: _fromController,
            label: 'From',
            hint: 'Enter starting point',
            icon: Icons.trip_origin_rounded,
            iconColor: teal,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Expanded(child: Divider(color: Color(0xFFE7EEF1))),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _swapLocations,
                child: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: softCyan,
                    shape: BoxShape.circle,
                    border: Border.all(color: teal.withOpacity(0.22)),
                  ),
                  child: const Icon(
                    Icons.swap_vert_rounded,
                    color: teal,
                    size: 21,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(child: Divider(color: Color(0xFFE7EEF1))),
            ],
          ),
          const SizedBox(height: 12),
          _locationField(
            controller: _toController,
            label: 'To',
            hint: 'Enter destination',
            icon: Icons.location_on_rounded,
            iconColor: cyan,
          ),
        ],
      ),
    );
  }

  Widget _locationField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FBFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: lightBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(
                color: textDark,
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
              ),
              decoration: InputDecoration(
                labelText: label,
                hintText: hint,
                border: InputBorder.none,
                isDense: true,
                labelStyle: const TextStyle(
                  color: textMuted,
                  fontSize: 11,
                ),
                hintStyle: const TextStyle(
                  color: Color(0xFF9AAAB4),
                  fontSize: 12,
                ),
              ),
            ),
          ),
          const Icon(Icons.my_location_rounded, color: teal, size: 19),
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

  Widget _buildTimeModeSelector() {
    final icons = [
      Icons.flash_on_rounded,
      Icons.schedule_rounded,
      Icons.flag_rounded,
    ];

    return Column(
      children: List.generate(_timeModes.length, (index) {
        final selected = _selectedTimeMode == index;

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == _timeModes.length - 1 ? 0 : 10,
          ),
          child: GestureDetector(
            onTap: () => setState(() => _selectedTimeMode = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: selected ? navy : white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selected ? navy : lightBorder,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: selected
                          ? cyan.withOpacity(0.13)
                          : softCyan,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      icons[index],
                      color: selected ? cyan : teal,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _timeModes[index],
                      style: TextStyle(
                        color: selected ? Colors.white : textDark,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Icon(
                    selected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: selected ? cyan : textMuted,
                    size: 21,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildPreferenceSelector() {
    return Row(
      children: List.generate(_preferences.length, (index) {
        final selected = _selectedPreference == index;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == _preferences.length - 1 ? 0 : 8,
            ),
            child: GestureDetector(
              onTap: () => setState(() => _selectedPreference = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  vertical: 14,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  color: selected ? softCyan : white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: selected
                        ? teal.withOpacity(0.30)
                        : lightBorder,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      index == 0
                          ? Icons.bolt_rounded
                          : index == 1
                          ? Icons.alt_route_rounded
                          : Icons.payments_outlined,
                      color: selected ? teal : textMuted,
                      size: 20,
                    ),
                    const SizedBox(height: 7),
                    Text(
                      _preferences[index],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: selected ? textDark : textMuted,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildOptionsCard() {
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
            title: 'Accessible route',
            subtitle: 'Prefer wheelchair-friendly services',
            value: _accessible,
            color: const Color(0xFF8B5CF6),
            onChanged: (value) => setState(() => _accessible = value),
          ),
          const Divider(height: 24, color: Color(0xFFE7EEF1)),
          _optionRow(
            icon: Icons.directions_walk_rounded,
            title: 'Less walking',
            subtitle: 'Reduce walking between stops',
            value: _lowWalking,
            color: teal,
            onChanged: (value) => setState(() => _lowWalking = value),
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

  Widget _buildTripPreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF0C3247), Color(0xFF0B2235)],
        ),
      ),
      child: const Row(
        children: [
          Icon(Icons.auto_awesome_rounded, color: cyan, size: 24),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart trip preview',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'MOVIRA will compare routes, fares and travel time before showing your trip summary.',
                  style: TextStyle(
                    color: Color(0xFFB8D8E8),
                    fontSize: 10.8,
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

  Widget _buildPlanTripButton() {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [teal, cyan]),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _planTrip,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.route_rounded, color: navy, size: 21),
              SizedBox(width: 10),
              Text(
                'Plan My Trip',
                style: TextStyle(
                  color: navy,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward_rounded, color: navy),
            ],
          ),
        ),
      ),
    );
  }
}

class _TripPlannerBackground extends StatelessWidget {
  const _TripPlannerBackground();

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
