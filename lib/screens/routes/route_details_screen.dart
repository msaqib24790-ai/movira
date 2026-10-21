
import 'package:flutter/material.dart';
import '../tracking/live_bus_tracking_screen.dart';

class RouteDetailsScreen extends StatefulWidget {
  final String busNumber;
  final String from;
  final String to;
  final String duration;
  final String fare;
  final String status;
  final Map<String, dynamic> routeResult;

  const RouteDetailsScreen({
    super.key,
    required this.busNumber,
    required this.from,
    required this.to,
    required this.duration,
    required this.fare,
    required this.status,
    required this.routeResult,
  });

  @override
  State<RouteDetailsScreen> createState() => _RouteDetailsScreenState();
}

class _RouteDetailsScreenState extends State<RouteDetailsScreen> {
  static const Color navy = Color(0xFF071B2C);
  static const Color darkNavy = Color(0xFF04101E);
  static const Color navySoft = Color(0xFF123247);
  static const Color teal = Color(0xFF00C7B7);
  static const Color cyan = Color(0xFF21D4FD);
  static const Color softText = Color(0xFFB8D8E8);

  static const Color ice = Color(0xFFF4FBFD);
  static const Color white = Color(0xFFFFFFFF);
  static const Color softCyan = Color(0xFFDDFBFA);
  static const Color textDark = Color(0xFF12212D);
  static const Color textMuted = Color(0xFF6B7C88);
  static const Color lightBorder = Color(0xFFE1EDF1);
  static const Color cardColor = Color(0xFFFFFFFF);

  bool _isFavorite = false;
  int _selectedTab = 0;

  // Read the actual stop segment returned by GtfsService.
  List<Map<String, dynamic>> get _stops {
    final rawStops = widget.routeResult['stops'];

    if (rawStops is! List) return [];

    return rawStops.whereType<Map>().map((stop) {
      return Map<String, dynamic>.from(stop);
    }).toList();
  }

  // These are departure records, not live arrivals or vehicle positions.
  List<Map<String, dynamic>> get _departures {
    final rawDepartures = widget.routeResult['departure_times'];

    if (rawDepartures is! List) return [];

    return rawDepartures.whereType<Map>().map((departure) {
      return Map<String, dynamic>.from(departure);
    }).where((departure) {
      return (departure['departure_time'] ?? '')
          .toString()
          .trim()
          .isNotEmpty;
    }).toList();
  }

  // UPDATED: Fall back to stop_id if the stop name is unavailable.
  String _stopName(Map<String, dynamic> stop) {
    final name = (stop['stop_name'] ??
        stop['name'] ??
        stop['stop_id'] ??
        'Unnamed stop')
        .toString()
        .trim();

    return name.isEmpty ? 'Unnamed stop' : name;
  }

  String _departureTime(Map<String, dynamic> departure) {
    final value = (departure['departure_time'] ?? '').toString().trim();
    return value.isEmpty ? 'Time unavailable' : value;
  }

  String _departureDays(Map<String, dynamic> departure) {
    final value = (departure['days'] ?? '').toString().trim();
    return value.isEmpty ? 'Operating days not provided' : value;
  }

  String _checkedOn(Map<String, dynamic> departure) {
    return (departure['checked_on'] ?? '').toString().trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ice,
      body: Stack(
        children: [
          const _RouteDetailsBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 26),
                  _buildBusOverview(),
                  const SizedBox(height: 22),
                  _buildJourneyCard(),
                  const SizedBox(height: 24),
                  _buildInfoCards(),
                  const SizedBox(height: 28),
                  _buildTabs(),
                  const SizedBox(height: 20),
                  if (_selectedTab == 0) _buildStopsSection(),
                  if (_selectedTab == 1) _buildFareSection(),
                  if (_selectedTab == 2) _buildTimetableSection(),
                  const SizedBox(height: 26),
                  _buildServiceStatus(),
                  const SizedBox(height: 26),
                  _buildTrackButton(),
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
        const SizedBox(width: 14),
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: lightBorder),
            boxShadow: const [
              BoxShadow(
                color: Color(0x15071B2C),
                blurRadius: 12,
                offset: Offset(0, 5),
              ),
            ],
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
                'ROUTE DETAILS',
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Fare • Stops • Timetable',
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
          onTap: () {
            setState(() {
              _isFavorite = !_isFavorite;
            });
          },
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: _isFavorite ? const Color(0xFFFFF6DD) : white,
              border: Border.all(
                color: _isFavorite
                    ? const Color(0xFFF59E0B).withOpacity(0.30)
                    : lightBorder,
              ),
            ),
            child: Icon(
              _isFavorite ? Icons.star_rounded : Icons.star_border_rounded,
              color: _isFavorite ? const Color(0xFFF59E0B) : navy,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBusOverview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [teal, cyan],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3800C7B7),
            blurRadius: 28,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: navy,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.directions_bus_filled_rounded,
              color: cyan,
              size: 34,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bus ${widget.busNumber}',
                  style: const TextStyle(
                    color: navy,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'GTFS route information',
                  style: TextStyle(
                    color: Color(0xFF123B49),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: navy.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: navy,
                        size: 13,
                      ),
                      SizedBox(width: 5),
                      Flexible(
                        child: Text(
                          'Schedule data only',
                          style: TextStyle(
                            color: navy,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: navy,
            size: 30,
          ),
        ],
      ),
    );
  }

  Widget _buildJourneyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: lightBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10071B2C),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _journeyLocation(
            icon: Icons.trip_origin_rounded,
            color: teal,
            label: 'Starting Point',
            value: widget.from,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 2,
                height: 30,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [teal, cyan],
                  ),
                ),
              ),
            ),
          ),
          _journeyLocation(
            icon: Icons.location_on_rounded,
            color: cyan,
            label: 'Destination',
            value: widget.to,
          ),
        ],
      ),
    );
  }

  Widget _journeyLocation({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 21),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: textMuted,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: textDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCards() {
    return Row(
      children: [
        Expanded(
          child: _infoCard(
            icon: Icons.schedule_rounded,
            title: widget.duration,
            subtitle: 'Duration',
            color: cyan,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _infoCard(
            icon: Icons.payments_outlined,
            title: widget.fare,
            subtitle: 'Total Fare',
            color: teal,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _infoCard(
            icon: Icons.pin_drop_outlined,
            title: '${_stops.length}',
            subtitle: 'Stops',
            color: const Color(0xFF8B5CF6),
          ),
        ),
      ],
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.18)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D071B2C),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: textDark,
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textMuted,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    const tabs = ['Stops', 'Fare', 'Timetable'];

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: lightBorder),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final selected = _selectedTab == index;

          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedTab = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: selected
                      ? const LinearGradient(colors: [teal, cyan])
                      : null,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? navy : textMuted,
                    fontSize: 12.5,
                    fontWeight:
                    selected ? FontWeight.w900 : FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStopsSection() {
    final stops = _stops;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Route Stops',
          style: TextStyle(
            color: textDark,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        const Text(
          'Stops from the selected GTFS route. Arrival times are not provided.',
          style: TextStyle(
            color: textMuted,
            fontSize: 11.5,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: lightBorder),
          ),
          child: stops.isEmpty
              ? _emptyState(
            icon: Icons.location_off_outlined,
            title: 'No stop details available',
            message:
            'The dataset did not provide stops for this route.',
          )
              : Column(
            children: List.generate(stops.length, (index) {
              final stop = stops[index];
              final first = index == 0;
              final last = index == stops.length - 1;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 28,
                    child: Column(
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: first
                                ? teal
                                : last
                                ? cyan
                                : const Color(0xFF33586B),
                            border: Border.all(
                              color: first || last
                                  ? navy
                                  : const Color(0xFF638094),
                              width: 2,
                            ),
                          ),
                        ),
                        if (!last)
                          Container(
                            width: 2,
                            height: 54,
                            color: const Color(0xFF33586B),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _stopName(stop),
                                  style: TextStyle(
                                    color: first || last
                                        ? navy
                                        : textDark,
                                    fontSize: 13,
                                    fontWeight: first || last
                                        ? FontWeight.w900
                                        : FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  first
                                      ? 'Starting stop'
                                      : last
                                      ? 'Destination stop'
                                      : 'Route stop',
                                  style: const TextStyle(
                                    color: textMuted,
                                    fontSize: 10.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'No arrival time',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              color: textMuted,
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildFareSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fare Information',
          style: TextStyle(
            color: textDark,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: teal.withOpacity(0.18)),
          ),
          child: const Column(
            children: [
              Icon(
                Icons.receipt_long_outlined,
                color: teal,
                size: 34,
              ),
              SizedBox(height: 12),
              Text(
                'Fare information unavailable',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'The current GTFS route data does not provide a verified fare. Please confirm the fare with the transport operator.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: textMuted,
                  fontSize: 12,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: cyan.withOpacity(0.08),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline_rounded, color: cyan),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'No base fare, distance fare, or total fare is assumed.',
                  style: TextStyle(
                    color: textMuted,
                    fontSize: 11.5,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimetableSection() {
    final departures = _departures;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Recorded Departures',
          style: TextStyle(
            color: textDark,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Departure records supplied by the GTFS dataset. These are not live updates.',
          style: TextStyle(
            color: textMuted,
            fontSize: 11.5,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 16),
        if (departures.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: lightBorder),
            ),
            child: _emptyState(
              icon: Icons.schedule_outlined,
              title: 'No departure records available',
              message:
              'The dataset does not contain a departure time for this route and starting stop.',
            ),
          )
        else
          ...departures.map((departure) {
            final checkedOn = _checkedOn(departure);

            return Container(
              margin: const EdgeInsets.only(bottom: 11),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor.withOpacity(0.9),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: lightBorder),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    color: cyan,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _departureTime(departure),
                          style: const TextStyle(
                            color: textDark,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          _departureDays(departure),
                          style: const TextStyle(
                            color: textMuted,
                            fontSize: 11,
                          ),
                        ),
                        if (checkedOn.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Dataset checked: $checkedOn',
                            style: const TextStyle(
                              color: textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Schedule record',
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      color: navySoft,
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            );
          }),
      ],
    );
  }

  Widget _emptyState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: textMuted, size: 32),
        const SizedBox(height: 10),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: textDark,
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 7),
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
    );
  }

  Widget _buildServiceStatus() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FAFD),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: cyan.withOpacity(0.22)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x1421D4FD),
            ),
            child: const Icon(
              Icons.info_outline_rounded,
              color: navySoft,
            ),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Live service status unavailable',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'The available schedule data does not confirm current operations, delays, or disruptions.',
                  style: TextStyle(
                    color: textMuted,
                    fontSize: 11.5,
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

  Widget _buildTrackButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(colors: [teal, cyan]),
        boxShadow: const [
          BoxShadow(
            color: Color(0x4400C7B7),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LiveBusTrackingScreen(
                  busNumber: widget.busNumber,
                  from: widget.from,
                  to: widget.to,
                ),
              ),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.location_searching_rounded,
                color: navy,
              ),
              SizedBox(width: 10),
              Text(
                'Open Bus Tracking',
                style: TextStyle(
                  color: navy,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_rounded,
                color: navy,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RouteDetailsBackground extends StatelessWidget {
  const _RouteDetailsBackground();

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
              color: const Color(0xFF21D4FD).withOpacity(0.08),
            ),
          ),
        ),
        Positioned(
          bottom: -130,
          left: -100,
          child: Container(
            width: 330,
            height: 330,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00C7B7).withOpacity(0.06),
            ),
          ),
        ),
      ],
    );
  }
}
