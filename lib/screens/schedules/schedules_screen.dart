import 'package:flutter/material.dart';

import '../../services/gtfs_service.dart';
import '../../services/schedule_utils.dart';

class SchedulesScreen extends StatefulWidget {
  const SchedulesScreen({super.key});

  @override
  State<SchedulesScreen> createState() => _SchedulesScreenState();
}

class _SchedulesScreenState extends State<SchedulesScreen> {
  static const Color navy = Color(0xFF071B2C);
  static const Color navySoft = Color(0xFF123247);
  static const Color teal = Color(0xFF00C7B7);
  static const Color cyan = Color(0xFF21D4FD);
  static const Color ice = Color(0xFFF4FBFD);
  static const Color white = Colors.white;
  static const Color softCyan = Color(0xFFDDFBFA);
  static const Color textDark = Color(0xFF12212D);
  static const Color textMuted = Color(0xFF6B7C88);
  static const Color lightBorder = Color(0xFFE1EDF1);

  int _selectedDay = 0;
  int _selectedFilter = 0;
  bool _loading = true;
  String? _error;
  List<Map<String, String>> _schedules = [];

  final List<String> _filters = ['All', 'Morning', 'Afternoon', 'Evening'];

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  Future<void> _loadSchedules() async {
    try {
      final service = GtfsService.instance;
      await service.loadData();

      final departures = service.scheduledDepartures.map((departure) {
        final route = departure['route'] as Map<String, String>? ?? {};
        final stop = departure['stop'] as Map<String, String>? ?? {};
        final pattern = departure['pattern'] as Map<String, String>? ?? {};

        return <String, String>{
          'pattern_id': departure['pattern_id']?.toString() ?? '',
          'stop_id': departure['stop_id']?.toString() ?? '',
          'departure_time': departure['departure_time']?.toString() ?? '',
          'days': departure['days']?.toString() ?? '',
          'checked_on': departure['checked_on']?.toString() ?? '',
          'route_short_name': route['route_short_name'] ?? '',
          'route_long_name': route['route_long_name'] ?? '',
          'pattern_name': pattern['pattern_name'] ?? '',
          'stop_name': stop['stop_name'] ?? '',
        };
      }).toList();

      if (!mounted) return;

      setState(() {
        _schedules = departures;
        _loading = false;
        _error = null;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = error.toString();
      });
    }
  }

  DateTime get _selectedDate {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + _selectedDay);
  }

  List<String> get _days {
    return List.generate(4, (index) {
      if (index == 0) return 'Today';
      if (index == 1) return 'Tomorrow';

      const weekdays = [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];

      return weekdays[_selectedDateForIndex(index).weekday - 1];
    });
  }

  DateTime _selectedDateForIndex(int index) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day + index);
  }

  List<Map<String, String>> get _visibleSchedules {
    return ScheduleUtils.filterSchedules(
      _schedules,
      _selectedDate,
      _selectedFilter,
    );
  }

  Map<String, String>? get _nextDeparture {
    final schedules = _visibleSchedules;

    if (schedules.isEmpty) return null;

    if (_selectedDay != 0) {
      return schedules.first;
    }

    final now = TimeOfDay.now();
    final currentMinutes = now.hour * 60 + now.minute;

    for (final schedule in schedules) {
      final parts = (schedule['departure_time'] ?? '').split(':');

      if (parts.length != 3) continue;

      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);

      if (hour == null ||
          minute == null ||
          hour < 0 ||
          hour > 23 ||
          minute < 0 ||
          minute > 59) {
        continue;
      }

      if (hour * 60 + minute >= currentMinutes) {
        return schedule;
      }
    }

    return null;
  }

  String _formatTime(String raw) {
    return ScheduleUtils.formatTime(raw);
  }

  String _serviceDays(String flags) {
    if (flags.length != 7) return 'Not specified';
    if (flags == '1111111') return 'Daily';
    if (flags == '0000000') return 'No service days';

    const labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final active = <String>[];

    for (var i = 0; i < 7; i++) {
      if (flags[i] == '1') {
        active.add(labels[i]);
      }
    }

    return active.isEmpty ? 'Not specified' : active.join(', ');
  }

  String _formatCheckedDate(String raw) {
    if (raw.length != 8) return 'Not available';

    return '${raw.substring(6, 8)}/'
        '${raw.substring(4, 6)}/'
        '${raw.substring(0, 4)}';
  }

  @override
  Widget build(BuildContext context) {
    final visible = _visibleSchedules;

    return Scaffold(
      backgroundColor: ice,
      body: Stack(
        children: [
          const _SchedulesBackground(),
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
                    'Bus Schedules',
                    style: TextStyle(
                      color: textDark,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'Explore scheduled departures from the transport dataset.',
                    style: TextStyle(
                      color: textMuted,
                      fontSize: 13.5,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDaySelector(),
                  const SizedBox(height: 18),
                  _buildFilterRow(),
                  const SizedBox(height: 22),
                  _buildNextDepartureCard(),
                  const SizedBox(height: 26),
                  _sectionTitle(
                    'Upcoming Services',
                    'Published departures for the selected day',
                  ),
                  const SizedBox(height: 14),
                  if (_loading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(32),
                        child: CircularProgressIndicator(color: teal),
                      ),
                    )
                  else if (_error != null)
                    _buildMessage(
                      icon: Icons.error_outline_rounded,
                      title: 'Could not load schedules',
                      message: 'Check the GTFS assets and try again.',
                      action: true,
                    )
                  else if (visible.isEmpty)
                    _buildMessage(
                      icon: Icons.directions_bus_outlined,
                      title: 'No scheduled departures found',
                      message: 'There are no matching departures for this day and time filter.',
                    )
                  else
                    ...visible.map(
                      (schedule) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: _buildScheduleCard(schedule),
                      ),
                    ),
                  const SizedBox(height: 12),
                  const Text(
                    'Schedule information is timetable data, not live bus tracking. '
                    'Arrival times, delays and journey durations are not provided here.',
                    style: TextStyle(
                      color: textMuted,
                      fontSize: 11,
                      height: 1.5,
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
                'SCHEDULES',
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Scheduled departure times',
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
          child: const Icon(Icons.schedule_rounded, color: teal),
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
            color: Color(0x25071B2C),
            blurRadius: 22,
            offset: Offset(0, 10),
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
              gradient: const LinearGradient(colors: [teal, cyan]),
            ),
            child: const Icon(
              Icons.calendar_month_rounded,
              color: navy,
              size: 32,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Plan your journey',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Browse scheduled departures and route information.',
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

  Widget _buildDaySelector() {
    final days = _days;

    return Row(
      children: List.generate(days.length, (index) {
        final selected = _selectedDay == index;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == days.length - 1 ? 0 : 7),
            child: GestureDetector(
              onTap: () => setState(() => _selectedDay = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 11),
                decoration: BoxDecoration(
                  color: selected ? navy : white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: selected ? navy : lightBorder),
                ),
                child: Text(
                  days[index],
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? cyan : textMuted,
                    fontSize: 10.2,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildFilterRow() {
    return Row(
      children: List.generate(_filters.length, (index) {
        final selected = _selectedFilter == index;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: index == _filters.length - 1 ? 0 : 7,
            ),
            child: GestureDetector(
              onTap: () => setState(() => _selectedFilter = index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? softCyan : white,
                  borderRadius: BorderRadius.circular(13),
                  border: Border.all(
                    color: selected
                        ? teal.withValues(alpha: 0.28)
                        : lightBorder,
                  ),
                ),
                child: Text(
                  _filters[index],
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? teal : textMuted,
                    fontSize: 9.8,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildNextDepartureCard() {
    final next = _nextDeparture;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(colors: [teal, cyan]),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3000C7B7),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: navy,
              borderRadius: BorderRadius.circular(17),
            ),
            child: const Icon(
              Icons.directions_bus_filled_rounded,
              color: cyan,
              size: 28,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Next Scheduled Departure',
                  style: TextStyle(
                    color: Color(0xFF123B49),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  next == null
                      ? 'No remaining departure'
                      : (next['route_short_name'] ?? 'Bus service'),
                  style: const TextStyle(
                    color: navy,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  next == null
                      ? 'Try another day or time filter.'
                      : '${_formatTime(next['departure_time'] ?? '')} · '
                            '${next['stop_name'] ?? 'Stop unavailable'}',
                  style: const TextStyle(
                    color: Color(0xFF123B49),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
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
          style: const TextStyle(color: textMuted, fontSize: 11.5),
        ),
      ],
    );
  }

  Widget _buildScheduleCard(Map<String, String> schedule) {
    final routeName = (schedule['pattern_name'] ?? '').trim();
    final routeShortName = (schedule['route_short_name'] ?? '').trim();
    final stopName = (schedule['stop_name'] ?? '').trim();
    final checkedDate = _formatCheckedDate(schedule['checked_on'] ?? '');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: lightBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F071B2C),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(colors: [teal, cyan]),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Text(
                      routeShortName.isEmpty ? 'BUS' : routeShortName,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: navy,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routeName.isEmpty ? 'Scheduled bus route' : routeName,
                      style: const TextStyle(
                        color: textDark,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Departure stop: '
                      '${stopName.isEmpty ? 'Not available' : stopName}',
                      style: const TextStyle(color: textMuted, fontSize: 10.5),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
                decoration: BoxDecoration(
                  color: softCyan,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'SCHEDULED',
                  style: TextStyle(
                    color: teal,
                    fontSize: 8.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 13),
            decoration: BoxDecoration(
              color: const Color(0xFFF6FAFB),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _timeBlock(
                    label: 'Departure',
                    value: _formatTime(schedule['departure_time'] ?? ''),
                  ),
                ),
                Container(width: 1, height: 34, color: lightBorder),
                Expanded(
                  child: _timeBlock(
                    label: 'Service days',
                    value: _serviceDays(schedule['days'] ?? ''),
                  ),
                ),
                Container(width: 1, height: 34, color: lightBorder),
                Expanded(
                  child: _timeBlock(label: 'Data checked', value: checkedDate),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timeBlock({required String label, required String value}) {
    return Column(
      children: [
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(color: textMuted, fontSize: 9),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: textDark,
            fontSize: 10.5,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildMessage({
    required IconData icon,
    required String title,
    required String message,
    bool action = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: lightBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: teal, size: 36),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textDark,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: textMuted, fontSize: 12, height: 1.5),
          ),
          if (action) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _loading = true;
                  _error = null;
                });
                _loadSchedules();
              },
              child: const Text('Try again'),
            ),
          ],
        ],
      ),
    );
  }
}

class _SchedulesBackground extends StatelessWidget {
  const _SchedulesBackground();

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
