import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LiveBusTrackingScreen extends StatefulWidget {
  final String busNumber;
  final String from;
  final String to;
  final List<Map<String, dynamic>> routeStops;

  const LiveBusTrackingScreen({
    super.key,
    this.busNumber = 'M-12',
    this.from = 'Central Station',
    this.to = 'City Mall',
    this.routeStops = const [],
  });

  @override
  State<LiveBusTrackingScreen> createState() => _LiveBusTrackingScreenState();
}

class _LiveBusTrackingScreenState extends State<LiveBusTrackingScreen> {
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
  static const Color warning = Color(0xFFB7791F);

  /// Extract readable names from the selected GTFS route stops.
  List<String> get _routeStopNames {
    return widget.routeStops
        .map((stop) {
          final value =
              stop['stop_name'] ??
              stop['name'] ??
              stop['stopName'] ??
              stop['stop_id'];

          return value?.toString().trim() ?? '';
        })
        .where((name) => name.isNotEmpty)
        .toList();
  }

  /// Use actual route endpoints when available.
  String get _routeStart {
    final stops = _routeStopNames;

    if (stops.isNotEmpty) {
      return stops.first;
    }

    return widget.from.trim().isNotEmpty ? widget.from : 'Not available';
  }

  String get _routeEnd {
    final stops = _routeStopNames;

    if (stops.isNotEmpty) {
      return stops.last;
    }

    return widget.to.trim().isNotEmpty ? widget.to : 'Not available';
  }

  /// This is the next stop in the route sequence, not the bus's
  /// actual current next stop.
  String get _nextRouteStop {
    final stops = _routeStopNames;

    if (stops.length < 2) {
      return 'Not available';
    }

    final originIndex = stops.indexWhere(
      (stop) => stop.toLowerCase() == widget.from.trim().toLowerCase(),
    );

    if (originIndex >= 0 && originIndex + 1 < stops.length) {
      return stops[originIndex + 1];
    }

    return stops[1];
  }

  int get _routeStopCount => _routeStopNames.length;

  /// Valid geographic stops from the selected GTFS journey.
  List<MapEntry<String, LatLng>> get _routeMapStops {
    return widget.routeStops
        .map((stop) {
          final latitude = double.tryParse((stop['stop_lat'] ?? '').toString());
          final longitude = double.tryParse(
            (stop['stop_lon'] ?? '').toString(),
          );

          final name =
              (stop['stop_name'] ??
                      stop['name'] ??
                      stop['stop_id'] ??
                      'Route stop')
                  .toString()
                  .trim();

          if (latitude == null ||
              longitude == null ||
              latitude < -90 ||
              latitude > 90 ||
              longitude < -180 ||
              longitude > 180 ||
              (latitude == 0 && longitude == 0)) {
            return null;
          }

          return MapEntry(
            name.isEmpty ? 'Route stop' : name,
            LatLng(latitude, longitude),
          );
        })
        .whereType<MapEntry<String, LatLng>>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ice,
      body: Stack(
        children: [
          const _TrackingBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildBusSummary(),
                  const SizedBox(height: 18),
                  _buildTrackingMap(),
                  const SizedBox(height: 22),
                  _buildNextStopCard(),
                  const SizedBox(height: 18),
                  _buildStatsRow(),
                  const SizedBox(height: 26),
                  _buildSectionTitle(
                    'Journey Route',
                    'Stops from the selected GTFS route',
                  ),
                  const SizedBox(height: 14),
                  _buildJourneyProgress(),
                  const SizedBox(height: 26),
                  _buildSectionTitle(
                    'Route Information',
                    'Live vehicle information is not available',
                  ),
                  const SizedBox(height: 14),
                  _buildBusInfoCard(),
                  const SizedBox(height: 22),
                  _buildFullRouteButton(),
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
                'ROUTE TRACKING',
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'GTFS route preview',
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
          child: const Icon(Icons.route_rounded, color: teal),
        ),
      ],
    );
  }

  Widget _buildBusSummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(19),
              gradient: const LinearGradient(colors: [teal, cyan]),
            ),
            child: const Icon(
              Icons.directions_bus_filled_rounded,
              color: navy,
              size: 32,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bus ${widget.busNumber}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${widget.from} → ${widget.to}',
                  style: const TextStyle(
                    color: Color(0xFFC7E3EF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: cyan, size: 15),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        'No live vehicle feed connected',
                        style: TextStyle(
                          color: cyan,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w800,
                        ),
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

  Widget _buildTrackingMap() {
    final routeStops = _routeMapStops;
    final coordinates = routeStops.map((stop) => stop.value).toList();
    final hasCoordinates = coordinates.isNotEmpty;
    final hasRouteLine = coordinates.length > 1;

    return Container(
      width: double.infinity,
      height: 330,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: lightBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x13071B2C),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: hasCoordinates
                    ? coordinates.first
                    : const LatLng(30.3753, 69.3451),
                initialZoom: hasRouteLine ? 7 : 5,
                initialCameraFit: hasRouteLine
                    ? CameraFit.bounds(
                        bounds: LatLngBounds.fromPoints(coordinates),
                        padding: const EdgeInsets.fromLTRB(44, 65, 44, 90),
                      )
                    : null,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                ),
                if (hasRouteLine)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: coordinates,
                        color: teal,
                        strokeWidth: 5,
                      ),
                    ],
                  ),
                if (hasCoordinates)
                  MarkerLayer(
                    markers: routeStops.asMap().entries.map((item) {
                      final index = item.key;
                      final stop = item.value;
                      final isStart = index == 0;
                      final isEnd = index == routeStops.length - 1;

                      return Marker(
                        point: stop.value,
                        width: 34,
                        height: 42,
                        child: Tooltip(
                          message: stop.key,
                          child: Icon(
                            isStart
                                ? Icons.trip_origin_rounded
                                : isEnd
                                ? Icons.flag_rounded
                                : Icons.location_on_rounded,
                            color: isStart || isEnd ? navy : teal,
                            size: isStart || isEnd ? 30 : 25,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                const RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution('OpenStreetMap contributors'),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: lightBorder),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.route_rounded, color: teal, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      hasRouteLine
                          ? 'GTFS ROUTE MAP'
                          : hasCoordinates
                          ? 'ONE STOP LOCATION'
                          : 'ROUTE MAP',
                      style: const TextStyle(
                        color: navy,
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 14,
              right: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 8),
                decoration: BoxDecoration(
                  color: navy,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_off_outlined, color: cyan, size: 15),
                    SizedBox(width: 5),
                    Text(
                      'GPS UNAVAILABLE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: navy.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Row(
                  children: [
                    Icon(
                      hasCoordinates
                          ? Icons.info_outline_rounded
                          : Icons.warning_amber_rounded,
                      color: cyan,
                      size: 20,
                    ),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        hasCoordinates
                            ? 'Route stops shown. Live bus position is unavailable.'
                            : 'No valid coordinates are available for this journey.',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextStopCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
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
            child: const Icon(Icons.location_on_rounded, color: teal),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Next Route Stop',
                  style: TextStyle(
                    color: textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _nextRouteStop,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Route sequence only, not live tracking',
                  style: TextStyle(color: textMuted, fontSize: 10),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF4DF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Text(
              'Not live',
              style: TextStyle(
                color: warning,
                fontSize: 10.5,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.schedule_rounded,
            value: 'N/A',
            label: 'Live ETA',
            color: cyan,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            icon: Icons.straighten_rounded,
            value: 'N/A',
            label: 'Distance',
            color: teal,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            icon: Icons.sensors_off_rounded,
            value: 'Offline',
            label: 'Live Feed',
            color: warning,
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.18)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(height: 7),
          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textDark,
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: textMuted, fontSize: 9.5),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, String subtitle) {
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

  Widget _buildJourneyProgress() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: lightBorder),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _progressPoint(
                label: _routeStart,
                icon: Icons.trip_origin_rounded,
                color: teal,
              ),
              Expanded(
                child: Container(
                  height: 4,
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4EDF1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              _progressPoint(
                label: _routeEnd,
                icon: Icons.location_on_rounded,
                color: cyan,
                alignRight: true,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.info_outline_rounded, color: warning, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _routeStopCount > 0
                      ? '$_routeStopCount stops found in the selected route. '
                            'Actual vehicle progress is unavailable.'
                      : 'Route stop details are unavailable. '
                            'Vehicle progress is not being reported.',
                  style: const TextStyle(
                    color: textMuted,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _progressPoint({
    required String label,
    required IconData icon,
    required Color color,
    bool alignRight = false,
  }) {
    return SizedBox(
      width: 88,
      child: Column(
        crossAxisAlignment: alignRight
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: alignRight ? TextAlign.right : TextAlign.left,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: textDark,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBusInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: lightBorder),
      ),
      child: Column(
        children: [
          _infoRow(
            icon: Icons.directions_bus_rounded,
            label: 'Route / Bus',
            value: widget.busNumber,
          ),
          const Divider(height: 22, color: Color(0xFFE7EEF1)),
          _infoRow(
            icon: Icons.location_on_outlined,
            label: 'Next Route Stop',
            value: _nextRouteStop,
          ),
          const Divider(height: 22, color: Color(0xFFE7EEF1)),
          _infoRow(
            icon: Icons.pin_drop_outlined,
            label: 'Stops in Route',
            value: _routeStopCount > 0 ? '$_routeStopCount' : 'N/A',
          ),
          const Divider(height: 22, color: Color(0xFFE7EEF1)),
          _infoRow(
            icon: Icons.payments_outlined,
            label: 'Fare',
            value: 'Not provided',
          ),
          const Divider(height: 22, color: Color(0xFFE7EEF1)),
          _infoRow(
            icon: Icons.timer_off_outlined,
            label: 'Live ETA',
            value: 'Unavailable',
          ),
        ],
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: softCyan,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: teal, size: 19),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(
              color: textMuted,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: textDark,
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }

  void _showRoutePreview() {
    final routeStops = _routeStopNames;
    final stops = routeStops.isNotEmpty
        ? routeStops
        : <String>[
            if (widget.from.trim().isNotEmpty) widget.from.trim(),
            if (widget.to.trim().isNotEmpty) widget.to.trim(),
          ];

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 24),
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(28),
          ),
          child: SafeArea(
            top: false,
            child: SizedBox(
              height: MediaQuery.of(sheetContext).size.height * 0.65,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Full Route Preview',
                    style: TextStyle(
                      color: textDark,
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Bus ${widget.busNumber} • '
                    '${widget.from} → ${widget.to}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: textMuted, fontSize: 11),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Stops shown in the GTFS route sequence. '
                    'This is not live vehicle tracking.',
                    style: TextStyle(color: textMuted, fontSize: 10.5),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: stops.isEmpty
                        ? const Center(
                            child: Text(
                              'No route stops are available.',
                              style: TextStyle(color: textMuted, fontSize: 13),
                            ),
                          )
                        : ListView.builder(
                            itemCount: stops.length,
                            itemBuilder: (context, index) {
                              final isFirst = index == 0;
                              final isLast = index == stops.length - 1;

                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    children: [
                                      Container(
                                        width: 14,
                                        height: 14,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: isFirst
                                              ? teal
                                              : isLast
                                              ? cyan
                                              : navySoft,
                                        ),
                                      ),
                                      if (!isLast)
                                        Container(
                                          width: 2,
                                          height: 30,
                                          color: lightBorder,
                                        ),
                                    ],
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 14,
                                      ),
                                      child: Text(
                                        stops[index],
                                        style: const TextStyle(
                                          color: textDark,
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (isFirst || isLast)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Text(
                                        isFirst ? 'START' : 'END',
                                        style: const TextStyle(
                                          color: textMuted,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFullRouteButton() {
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
          onTap: _showRoutePreview,
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.route_rounded, color: navy, size: 21),
              SizedBox(width: 10),
              Text(
                'View Full Route',
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

class _TrackingBackground extends StatelessWidget {
  const _TrackingBackground();

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
              color: const Color(0xFF21D4FD).withOpacity(0.09),
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
              color: const Color(0xFF00C7B7).withOpacity(0.07),
            ),
          ),
        ),
      ],
    );
  }
}
