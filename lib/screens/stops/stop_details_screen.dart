import 'package:flutter/material.dart';

import '../../services/gtfs_service.dart';
import '../buses/bus_details_screen.dart';

class StopDetailsScreen extends StatefulWidget {
  final String stopId;
  final String stopName;
  final String distance;
  final String walkingTime;

  const StopDetailsScreen({
    super.key,
    this.stopId = '',
    this.stopName = 'Central Station',
    this.distance = '250 m',
    this.walkingTime = '3 min walk',
  });

  @override
  State<StopDetailsScreen> createState() => _StopDetailsScreenState();
}

class _StopDetailsScreenState extends State<StopDetailsScreen> {
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

  bool _isLoading = true;
  String? _loadError;

  Map<String, String>? _stopRecord;

  List<Map<String, dynamic>> _allStopDepartures = [];
  List<Map<String, dynamic>> _todayDepartures = [];
  List<Map<String, dynamic>> _upcomingDepartures = [];
  List<Map<String, dynamic>> _servingRoutes = [];

  @override
  void initState() {
    super.initState();
    _loadStopData();
  }

  Future<void> _loadStopData() async {
    try {
      final service = GtfsService.instance;

      await service.loadData();

      if (widget.stopId.isEmpty) {
        if (!mounted) return;

        setState(() {
          _isLoading = false;
          _loadError = 'No stop ID was provided. Please select a stop from Nearby Stops.';
        });
        return;
      }

      final stop = service.getStopById(widget.stopId);

      final allDepartures = service.scheduledDepartures
          .where(
            (departure) => departure['stop_id']?.toString() == widget.stopId,
          )
          .toList();

      final now = DateTime.now();
      final currentTime =
          '${now.hour.toString().padLeft(2, '0')}:'
          '${now.minute.toString().padLeft(2, '0')}:00';

      final todayDepartures = allDepartures.where((departure) {
        final days = departure['days']?.toString() ?? '';

        if (days.length < 7) return false;

        // GTFS day flags: Monday through Sunday.
        return days[now.weekday - 1] == '1';
      }).toList();

      todayDepartures.sort((a, b) {
        final aTime = a['departure_time']?.toString() ?? '';
        final bTime = b['departure_time']?.toString() ?? '';
        return aTime.compareTo(bTime);
      });

      final upcoming = todayDepartures.where((departure) {
        final time = departure['departure_time']?.toString() ?? '';
        return time.compareTo(currentTime) >= 0;
      }).toList();

      // Build a unique list of routes with scheduled departures
      // at this stop. The route and pattern data come from GTFS.
      final routeMap = <String, Map<String, dynamic>>{};

      for (final departure in allDepartures) {
        final routeValue = departure['route'];
        final patternValue = departure['pattern'];

        final route = routeValue is Map
            ? Map<String, dynamic>.from(routeValue)
            : <String, dynamic>{};

        final pattern = patternValue is Map
            ? Map<String, dynamic>.from(patternValue)
            : <String, dynamic>{};

        final routeId = route['route_id']?.toString() ?? '';

        if (routeId.isEmpty) continue;

        final routeName = route['route_short_name']?.toString().trim() ?? '';

        final patternName = pattern['pattern_name']?.toString().trim() ?? '';

        routeMap.putIfAbsent(routeId, () {
          return {
            'route_id': routeId,
            'number': routeName.isNotEmpty ? routeName : routeId,
            'name': patternName.isNotEmpty
                ? patternName
                : (route['route_long_name']?.toString() ?? 'Transit route'),
            'url': route['route_url']?.toString() ?? '',
          };
        });
      }

      final routes = routeMap.values.toList()
        ..sort(
          (a, b) => (a['number'] as String).compareTo(b['number'] as String),
        );

      if (!mounted) return;

      setState(() {
        _stopRecord = stop;
        _allStopDepartures = allDepartures;
        _todayDepartures = todayDepartures;
        _upcomingDepartures = upcoming;
        _servingRoutes = routes;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _loadError = 'Unable to load stop timetable data.';
      });

      debugPrint('Stop details loading error: $error');
    }
  }

  String _formatTime(String rawTime) {
    final parts = rawTime.split(':');

    if (parts.length < 2) return rawTime;

    final hour = int.tryParse(parts[0]);
    final minute = int.tryParse(parts[1]);

    if (hour == null || minute == null || hour < 0 || hour > 23) {
      return rawTime;
    }

    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour % 12 == 0 ? 12 : hour % 12;

    return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
  }

  String _nextDepartureLabel() {
    if (_isLoading) return 'Loading';

    if (_upcomingDepartures.isEmpty) {
      return 'None left';
    }

    final time = _upcomingDepartures.first['departure_time']?.toString() ?? '';

    return _formatTime(time);
  }

  String get _displayStopName {
    final name = _stopRecord?['stop_name']?.trim();

    if (name != null && name.isNotEmpty) return name;

    return widget.stopName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ice,
      body: Stack(
        children: [
          const _StopDetailsBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildStopHero(),
                  const SizedBox(height: 22),
                  _buildQuickInfoRow(),
                  const SizedBox(height: 26),
                  _sectionTitle(
                    'Scheduled Departures',
                    'Timetable information, not live vehicle ETAs',
                  ),
                  const SizedBox(height: 14),
                  _buildDeparturesSection(),
                  const SizedBox(height: 24),
                  _sectionTitle(
                    'Stop Facilities',
                    'Facility information is not available in this dataset',
                  ),
                  const SizedBox(height: 14),
                  _buildFacilitiesCard(),
                  const SizedBox(height: 24),
                  _sectionTitle(
                    'Route Information',
                    'Routes with scheduled departures at this stop',
                  ),
                  const SizedBox(height: 14),
                  _buildRoutesCard(),
                  const SizedBox(height: 24),
                  _buildDirectionsButton(),
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
              boxShadow: const [
                BoxShadow(
                  color: Color(0x12071B2C),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
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
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.directions_bus_rounded, color: teal);
              },
            ),
          ),
        ),
        const SizedBox(width: 11),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'STOP DETAILS',
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Schedules â€¢ facilities â€¢ routes',
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
          child: const Icon(Icons.pin_drop_rounded, color: teal),
        ),
      ],
    );
  }

  Widget _buildStopHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
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
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(colors: [teal, cyan]),
            ),
            child: const Icon(
              Icons.directions_bus_rounded,
              color: navy,
              size: 34,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _displayStopName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${widget.distance} â€¢ ${widget.walkingTime}',
                  style: const TextStyle(
                    color: Color(0xFFC7E3EF),
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 7),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: cyan.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    widget.stopId.isEmpty
                        ? 'STOP DETAILS'
                        : 'GTFS STOP â€¢ ${widget.stopId}',
                    style: const TextStyle(
                      color: Color(0xFF8CE9F8),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                    ),
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

  Widget _buildQuickInfoRow() {
    return Row(
      children: [
        Expanded(
          child: _quickInfo(
            icon: Icons.alt_route_rounded,
            value: _isLoading ? '...' : '${_servingRoutes.length}',
            label: 'Routes',
            color: cyan,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _quickInfo(
            icon: Icons.schedule_rounded,
            value: _nextDepartureLabel(),
            label: 'Next Departure',
            color: teal,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _quickInfo(
            icon: Icons.info_outline_rounded,
            value: 'Unknown',
            label: 'Facilities',
            color: const Color(0xFF8B5CF6),
          ),
        ),
      ],
    );
  }

  Widget _quickInfo({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 6),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(height: 7),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: textDark,
              fontSize: 11.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: textMuted, fontSize: 9),
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

  Widget _buildDeparturesSection() {
    if (_isLoading) {
      return _messageCard(
        icon: Icons.hourglass_top_rounded,
        title: 'Loading timetable',
        message: 'Reading the scheduled departures for this stop.',
      );
    }

    if (_loadError != null) {
      return _messageCard(
        icon: Icons.error_outline_rounded,
        title: 'Timetable unavailable',
        message: _loadError!,
      );
    }

    if (_allStopDepartures.isEmpty) {
      return _messageCard(
        icon: Icons.directions_bus_outlined,
        title: 'No timetable records found',
        message:
            'The current dataset has no scheduled departures linked '
            'to this stop ID.',
      );
    }

    if (_todayDepartures.isEmpty) {
      return _messageCard(
        icon: Icons.event_busy_rounded,
        title: 'No departures listed for today',
        message:
            'The timetable contains departures for this stop, but '
            'none are marked as operating today.',
      );
    }

    if (_upcomingDepartures.isEmpty) {
      return _messageCard(
        icon: Icons.schedule_rounded,
        title: 'No remaining departures today',
        message:
            'The timetable has no later departures for today. '
            'Earlier scheduled times are not shown as upcoming.',
      );
    }

    return Column(
      children: [
        ..._upcomingDepartures.take(10).map((departure) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildDepartureCard(departure),
          );
        }),
        if (_upcomingDepartures.length > 10)
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              'Showing the next 10 of '
              '${_upcomingDepartures.length} scheduled departures.',
              style: const TextStyle(color: textMuted, fontSize: 11),
            ),
          ),
        const SizedBox(height: 5),
        _noticeRow(
          Icons.info_outline_rounded,
          'Times are from the timetable. Actual arrival times may differ.',
        ),
      ],
    );
  }

  Widget _buildDepartureCard(Map<String, dynamic> departure) {
    final rawTime = departure['departure_time']?.toString() ?? '--:--:--';

    final routeValue = departure['route'];
    final patternValue = departure['pattern'];

    final route = routeValue is Map
        ? Map<String, dynamic>.from(routeValue)
        : <String, dynamic>{};

    final pattern = patternValue is Map
        ? Map<String, dynamic>.from(patternValue)
        : <String, dynamic>{};

    final routeNumber = route['route_short_name']?.toString().trim() ?? '';

    final patternName = pattern['pattern_name']?.toString().trim() ?? '';

    final routeName = route['route_long_name']?.toString().trim() ?? '';

    final destination = patternName.isNotEmpty
        ? patternName
        : routeName.isNotEmpty
        ? routeName
        : 'Scheduled route';

    final number = routeNumber.isNotEmpty
        ? routeNumber
        : (route['route_id']?.toString() ?? 'Route');

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BusDetailsScreen(
              busNumber: number,
              destination: destination,
              eta: _formatTime(rawTime),
              status: 'Scheduled',
            ),
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
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F071B2C),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
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
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: Text(
                    number,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
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
                    destination,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 12.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Row(
                    children: [
                      Icon(
                        Icons.event_available_rounded,
                        color: teal,
                        size: 13,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Scheduled departure',
                        style: TextStyle(color: textMuted, fontSize: 10),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _formatTime(rawTime),
                  style: const TextStyle(
                    color: navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Timetable',
                  style: TextStyle(
                    color: teal,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilitiesCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: lightBorder),
      ),
      child: const Column(
        children: [
          Icon(Icons.info_outline_rounded, color: teal, size: 32),
          SizedBox(height: 10),
          Text(
            'Facility information unavailable',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textDark,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 7),
          Text(
            'The current GTFS files identify stops and timetables, '
            'but do not confirm seating, lighting, CCTV, or '
            'accessibility facilities at this location.',
            textAlign: TextAlign.center,
            style: TextStyle(color: textMuted, fontSize: 11.5, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildRoutesCard() {
    if (_isLoading) {
      return _messageCard(
        icon: Icons.hourglass_top_rounded,
        title: 'Loading routes',
        message: 'Finding routes linked to this stop.',
      );
    }

    if (_servingRoutes.isEmpty) {
      return _messageCard(
        icon: Icons.alt_route_rounded,
        title: 'No route records found',
        message:
            'No route could be identified from the scheduled '
            'departures associated with this stop.',
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: lightBorder),
      ),
      child: Column(
        children: _servingRoutes.asMap().entries.map((entry) {
          final index = entry.key;
          final route = entry.value;

          final number = route['number']?.toString() ?? 'Route';
          final name = route['name']?.toString() ?? 'Transit route';

          return Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: softCyan,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3),
                        child: Text(
                          number,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: teal,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          number,
                          style: const TextStyle(
                            color: textDark,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: textMuted,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: teal,
                    size: 20,
                  ),
                ],
              ),
              if (index != _servingRoutes.length - 1)
                const Divider(height: 22, color: Color(0xFFE7EEF1)),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _messageCard({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: lightBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: teal, size: 30),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textDark,
              fontSize: 13,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textMuted,
              fontSize: 11.5,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _noticeRow(IconData icon, String message) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: softCyan.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: teal, size: 18),
          const SizedBox(width: 9),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: textDark,
                fontSize: 10.5,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDirectionsButton() {
    return Container(
      width: double.infinity,
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [teal, cyan]),
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
                content: Text('Walking directions are not connected yet.'),
              ),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.directions_walk_rounded, color: navy, size: 21),
              SizedBox(width: 10),
              Text(
                'Get Directions to Stop',
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

class _StopDetailsBackground extends StatelessWidget {
  const _StopDetailsBackground();

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
          top: -100,
          right: -70,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF21D4FD).withValues(alpha: 0.09),
            ),
          ),
        ),
        Positioned(
          bottom: -120,
          left: -90,
          child: Container(
            width: 300,
            height: 300,
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
