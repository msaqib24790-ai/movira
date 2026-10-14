import 'package:flutter/material.dart';

class TripReminderSettingsScreen extends StatefulWidget {
  const TripReminderSettingsScreen({super.key});

  @override
  State<TripReminderSettingsScreen> createState() =>
      _TripReminderSettingsScreenState();
}

class _TripReminderSettingsScreenState
    extends State<TripReminderSettingsScreen> {
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
  static const Color warning = Color(0xFFF59E0B);
  static const Color success = Color(0xFF22C55E);

  bool _tripReminders = true;
  bool _departureAlerts = true;
  bool _delayAlerts = true;
  bool _stopAlerts = false;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  int _selectedLeadTime = 1;
  int _selectedRepeat = 0;

  final List<String> _leadTimes = [
    '5 min',
    '10 min',
    '15 min',
    '30 min',
  ];

  final List<String> _repeatOptions = [
    'Once',
    'Daily',
    'Weekdays',
    'Custom',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ice,
      body: Stack(
        children: [
          const _ReminderBackground(),
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
                  _buildMasterToggle(),
                  const SizedBox(height: 24),
                  _sectionTitle(
                    'Reminder Timing',
                    'Choose how early MOVIRA should remind you',
                  ),
                  const SizedBox(height: 14),
                  _buildLeadTimeSelector(),
                  const SizedBox(height: 24),
                  _sectionTitle(
                    'Trip Alerts',
                    'Choose which travel updates you want',
                  ),
                  const SizedBox(height: 14),
                  _buildTripAlertsCard(),
                  const SizedBox(height: 24),
                  _sectionTitle(
                    'Repeat Reminder',
                    'Set how often the reminder should repeat',
                  ),
                  const SizedBox(height: 14),
                  _buildRepeatSelector(),
                  const SizedBox(height: 24),
                  _sectionTitle(
                    'Notification Style',
                    'Control sound and vibration',
                  ),
                  const SizedBox(height: 14),
                  _buildNotificationStyleCard(),
                  const SizedBox(height: 24),
                  _buildNextReminderPreview(),
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
                'TRIP REMINDERS',
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Stay ready for every journey',
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
            Icons.alarm_rounded,
            color: teal,
          ),
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
        boxShadow: const [
          BoxShadow(
            color: Color(0x22071B2C),
            blurRadius: 20,
            offset: Offset(0, 9),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [teal, cyan],
              ),
            ),
            child: const Icon(
              Icons.notifications_active_rounded,
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
                  'Never miss your bus',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Set smart reminders for departures, delays and important stops.',
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

  Widget _buildMasterToggle() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: _tripReminders
              ? teal.withOpacity(0.28)
              : lightBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: _tripReminders ? softCyan : const Color(0xFFF3F7F9),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              _tripReminders
                  ? Icons.alarm_on_rounded
                  : Icons.alarm_off_rounded,
              color: _tripReminders ? teal : textMuted,
            ),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Trip Reminders',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Enable reminders for your planned journeys',
                  style: TextStyle(
                    color: textMuted,
                    fontSize: 10.8,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _tripReminders,
            onChanged: (value) {
              setState(() {
                _tripReminders = value;
              });
            },
            activeColor: teal,
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

  Widget _buildLeadTimeSelector() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: List.generate(_leadTimes.length, (index) {
        final selected = _selectedLeadTime == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedLeadTime = index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 13,
            ),
            decoration: BoxDecoration(
              color: selected ? navy : white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: selected ? navy : lightBorder,
              ),
            ),
            child: Text(
              _leadTimes[index],
              style: TextStyle(
                color: selected ? Colors.white : textDark,
                fontSize: 11.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTripAlertsCard() {
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
          _settingRow(
            icon: Icons.directions_bus_rounded,
            title: 'Departure alerts',
            subtitle: 'Notify before your bus leaves',
            value: _departureAlerts,
            color: cyan,
            onChanged: (value) {
              setState(() {
                _departureAlerts = value;
              });
            },
          ),
          const Divider(height: 24, color: Color(0xFFE7EEF1)),
          _settingRow(
            icon: Icons.warning_amber_rounded,
            title: 'Delay alerts',
            subtitle: 'Notify if your selected route is delayed',
            value: _delayAlerts,
            color: warning,
            onChanged: (value) {
              setState(() {
                _delayAlerts = value;
              });
            },
          ),
          const Divider(height: 24, color: Color(0xFFE7EEF1)),
          _settingRow(
            icon: Icons.pin_drop_rounded,
            title: 'Stop alerts',
            subtitle: 'Remind before reaching your destination',
            value: _stopAlerts,
            color: success,
            onChanged: (value) {
              setState(() {
                _stopAlerts = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildRepeatSelector() {
    return Column(
      children: List.generate(_repeatOptions.length, (index) {
        final selected = _selectedRepeat == index;

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == _repeatOptions.length - 1 ? 0 : 10,
          ),
          child: GestureDetector(
            onTap: () => setState(() => _selectedRepeat = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: selected ? softCyan : white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: selected
                      ? teal.withOpacity(0.30)
                      : lightBorder,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    selected
                        ? Icons.radio_button_checked_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: selected ? teal : textMuted,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _repeatOptions[index],
                    style: TextStyle(
                      color: selected ? textDark : textMuted,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const Spacer(),
                  if (index == 3)
                    const Icon(
                      Icons.chevron_right_rounded,
                      color: textMuted,
                    ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNotificationStyleCard() {
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
          _settingRow(
            icon: Icons.volume_up_rounded,
            title: 'Sound',
            subtitle: 'Play sound with reminder',
            value: _soundEnabled,
            color: teal,
            onChanged: (value) {
              setState(() {
                _soundEnabled = value;
              });
            },
          ),
          const Divider(height: 24, color: Color(0xFFE7EEF1)),
          _settingRow(
            icon: Icons.vibration_rounded,
            title: 'Vibration',
            subtitle: 'Vibrate when reminder arrives',
            value: _vibrationEnabled,
            color: const Color(0xFF8B5CF6),
            onChanged: (value) {
              setState(() {
                _vibrationEnabled = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _settingRow({
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
          child: Icon(
            icon,
            color: color,
            size: 21,
          ),
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

  Widget _buildNextReminderPreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0C3247),
            Color(0xFF0B2235),
          ],
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: cyan.withOpacity(0.12),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(
              Icons.schedule_send_rounded,
              color: cyan,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Next Reminder',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _tripReminders
                      ? '${_leadTimes[_selectedLeadTime]} before departure • ${_repeatOptions[_selectedRepeat]}'
                      : 'Trip reminders are currently disabled',
                  style: const TextStyle(
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

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [teal, cyan],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3000C7B7),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Trip reminder settings saved.'),
              ),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: navy,
                size: 21,
              ),
              SizedBox(width: 10),
              Text(
                'Save Reminder Settings',
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
}

class _ReminderBackground extends StatelessWidget {
  const _ReminderBackground();

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
