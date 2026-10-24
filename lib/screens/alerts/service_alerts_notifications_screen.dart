import 'package:flutter/material.dart';

import '../reminders/trip_reminder_settings_screen.dart';

class ServiceAlertsNotificationsScreen extends StatefulWidget {
  const ServiceAlertsNotificationsScreen({super.key});

  @override
  State<ServiceAlertsNotificationsScreen> createState() =>
      _ServiceAlertsNotificationsScreenState();
}

class _ServiceAlertsNotificationsScreenState
    extends State<ServiceAlertsNotificationsScreen> {
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
  static const Color error = Color(0xFFEF4444);

  int _selectedFilter = 0;

  final List<String> _filters = ['All', 'Delays', 'Route Changes', 'System'];

  final List<Map<String, dynamic>> _alerts = [];

  List<Map<String, dynamic>> get _visibleAlerts {
    if (_selectedFilter == 0) {
      return _alerts;
    }

    final selected = _filters[_selectedFilter];
    if (selected == 'Delays') {
      return _alerts.where((e) => e['type'] == 'Delay').toList();
    }
    if (selected == 'Route Changes') {
      return _alerts.where((e) => e['type'] == 'Route Change').toList();
    }
    return _alerts.where((e) => e['type'] == 'System').toList();
  }

  void _markAllRead() {
    setState(() {
      for (final alert in _alerts) {
        alert['unread'] = false;
      }
    });
  }

  void _openReminderSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TripReminderSettingsScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ice,
      body: Stack(
        children: [
          const _AlertsBackground(),
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
                  _buildStatusCard(),
                  const SizedBox(height: 14),
                  _buildReminderSettingsCard(),
                  const SizedBox(height: 24),
                  _sectionTitle(
                    'Service Alerts',
                    'Verified service updates will appear here when available.',
                  ),
                  const SizedBox(height: 14),
                  _buildFilterBar(),
                  const SizedBox(height: 16),
                  if (_visibleAlerts.isEmpty)
                    _buildEmptyAlertsState()
                  else
                    ..._visibleAlerts.map(
                      (alert) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _alertCard(alert),
                      ),
                    ),
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
                'ALERTS',
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Service alerts and notifications',
                style: TextStyle(
                  color: textMuted,
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: _markAllRead,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: softCyan,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(Icons.done_all_rounded, color: teal),
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
                  'Stay ahead of changes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Get important delay, reroute and service updates before you travel.',
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

  Widget _buildStatusCard() {
    final unread = _alerts.where((e) => e['unread'] == true).length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: lightBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: softCyan,
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.campaign_rounded, color: teal),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notification Center',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  unread == 0
                      ? 'You are all caught up'
                      : '$unread unread updates',
                  style: const TextStyle(color: textMuted, fontSize: 11),
                ),
              ],
            ),
          ),
          if (unread > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: error.withOpacity(0.10),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '$unread NEW',
                style: const TextStyle(
                  color: error,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildReminderSettingsCard() {
    return GestureDetector(
      onTap: _openReminderSettings,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF7FCFD),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: teal.withOpacity(0.18)),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: softCyan,
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Icon(Icons.alarm_rounded, color: teal),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trip Reminder Settings',
                    style: TextStyle(
                      color: textDark,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Choose when and how MOVIRA reminds you.',
                    style: TextStyle(color: textMuted, fontSize: 10.5),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_rounded, color: teal, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterBar() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final selected = _selectedFilter == index;

          return GestureDetector(
            onTap: () => setState(() => _selectedFilter = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? navy : white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: selected ? navy : lightBorder),
              ),
              child: Text(
                _filters[index],
                style: TextStyle(
                  color: selected ? Colors.white : textMuted,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyAlertsState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: lightBorder),
      ),
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(color: ice, shape: BoxShape.circle),
            child: const Icon(
              Icons.notifications_none_rounded,
              color: navySoft,
              size: 30,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'No current service alerts',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textDark,
              fontSize: 17,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'There are no verified service updates available right now. '
            'Alerts will appear here when a trusted source provides them.',
            textAlign: TextAlign.center,
            style: TextStyle(color: textMuted, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _alertCard(Map<String, dynamic> alert) {
    final Color accent = alert['color'] as Color;
    final bool unread = alert['unread'] as bool;

    return GestureDetector(
      onTap: () {
        setState(() {
          alert['unread'] = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          color: unread ? const Color(0xFFFAFEFF) : white,
          borderRadius: BorderRadius.circular(21),
          border: Border.all(
            color: unread ? accent.withOpacity(0.28) : lightBorder,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D071B2C),
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.11),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(alert['icon'] as IconData, color: accent, size: 23),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          alert['title'] as String,
                          style: const TextStyle(
                            color: textDark,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      if (unread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: teal,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    alert['message'] as String,
                    style: const TextStyle(
                      color: textMuted,
                      fontSize: 10.8,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 11),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: accent.withOpacity(0.10),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          alert['type'] as String,
                          style: TextStyle(
                            color: accent,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        alert['time'] as String,
                        style: const TextStyle(color: textMuted, fontSize: 9.8),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
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
          style: const TextStyle(color: textMuted, fontSize: 11.5),
        ),
      ],
    );
  }
}

class _AlertsBackground extends StatelessWidget {
  const _AlertsBackground();

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
