
import 'package:flutter/material.dart';

import '../../services/gtfs_service.dart';
import 'route_details_screen.dart';

class RouteResultsScreen extends StatefulWidget {
  final String from;
  final String to;

  const RouteResultsScreen({
    super.key,
    required this.from,
    required this.to,
  });

  @override
  State<RouteResultsScreen> createState() => _RouteResultsScreenState();
}

class _RouteResultsScreenState extends State<RouteResultsScreen> {
  static const Color navy = Color(0xFF071B2C);
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

  int _selectedSort = 0;
  List<Map<String, dynamic>> _routes = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadRoutes();
  }

  void _loadRoutes() {
    try {
      final results = GtfsService.instance.searchRoutes(
        from: widget.from,
        to: widget.to,
      );

      _routes = results
          .map((route) => Map<String, dynamic>.from(route))
          .toList();

      _sortRoutes();
    } catch (_) {
      _routes = [];
      _errorMessage =
      'Unable to load routes from the transit dataset.';
    }
  }

  Map<String, dynamic> _asMap(dynamic value) {
    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }
    return <String, dynamic>{};
  }

  String _text(dynamic value, {String fallback = ''}) {
    if (value == null) return fallback;

    final result = value.toString().trim();

    if (result.isEmpty || result.toLowerCase() == 'null') {
      return fallback;
    }

    return result;
  }

  Map<String, dynamic> _routeData(Map<String, dynamic> result) {
    return _asMap(result['route']);
  }

  String _routeName(Map<String, dynamic> result) {
    final route = _routeData(result);

    final shortName = _text(
      route['route_short_name'] ??
          route['short_name'] ??
          route['route_name'] ??
          route['name'],
    );

    if (shortName.isNotEmpty) return shortName;

    final longName = _text(
      route['route_long_name'] ?? route['long_name'],
    );

    if (longName.isNotEmpty) return longName;

    return _text(
      route['route_id'] ?? route['id'],
      fallback: 'Unknown route',
    );
  }

  List<dynamic> _stops(Map<String, dynamic> result) {
    final value = result['stops'];
    return value is List ? value : [];
  }

  String _stopName(dynamic stop) {
    if (stop is String) return stop;

    final data = _asMap(stop);

    return _text(
      data['stop_name'] ??
          data['name'] ??
          data['stopName'] ??
          data['stop_id'],
      fallback: 'Unnamed stop',
    );
  }

  int _stopCount(Map<String, dynamic> result) {
    final stops = _stops(result);

    // The returned stop segment is the source of truth.
    if (stops.isNotEmpty) return stops.length;

    final suppliedCount = result['stop_count'];

    if (suppliedCount is num) {
      return suppliedCount.toInt();
    }

    return 0;
  }

  List<dynamic> _departureTimes(Map<String, dynamic> result) {
    final value = result['departure_times'];
    return value is List ? value : [];
  }

  String _departureLabel(Map<String, dynamic> result) {
    final times = _departureTimes(result);

    if (times.isEmpty) {
      return 'Departure time unavailable';
    }

    final first = times.first;

    if (first is String || first is num) {
      return _text(
        first,
        fallback: 'Departure time unavailable',
      );
    }

    final data = _asMap(first);

    return _text(
      data['departure_time'] ??
          data['departure'] ??
          data['time'] ??
          data['departureTime'],
      fallback: 'Departure time unavailable',
    );
  }

  String _networkLabel(Map<String, dynamic> result) {
    final networks = result['networks'];

    if (networks is List && networks.isNotEmpty) {
      final names = networks.map((network) {
        if (network is String) return network;

        final data = _asMap(network);

        return _text(
          data['network_name'] ??
              data['name'] ??
              data['network_id'] ??
              data['id'],
        );
      }).where((name) => name.isNotEmpty).toList();

      if (names.isNotEmpty) return names.join(', ');
    }

    return 'Transit network not specified';
  }

  void _sortRoutes() {
    if (_selectedSort == 1) {
      _routes.sort(
            (a, b) => _stopCount(a).compareTo(_stopCount(b)),
      );
    } else if (_selectedSort == 2) {
      _routes.sort(
            (a, b) => _routeName(a)
            .toLowerCase()
            .compareTo(_routeName(b).toLowerCase()),
      );
    }
  }

  void _selectSort(int index) {
    setState(() {
      _selectedSort = index;
      _sortRoutes();
    });
  }

  void _openRouteDetails(Map<String, dynamic> result) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RouteDetailsScreen(
          busNumber: _routeName(result),
          from: widget.from,
          to: widget.to,
          duration: 'Not provided by dataset',
          fare: 'Not provided by dataset',
          status: 'Service status unverified',
          routeResult: result,
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
          const _RouteResultsBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 26),
                  const Text(
                    'Best routes for you',
                    style: TextStyle(
                      color: textDark,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Compare matching routes found in the available '
                        'transit dataset.',
                    style: TextStyle(
                      color: textMuted,
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildJourneySummary(),
                  const SizedBox(height: 26),
                  _buildSortRow(),
                  const SizedBox(height: 18),
                  if (_errorMessage != null)
                    _buildMessageCard(
                      icon: Icons.error_outline_rounded,
                      title: 'Unable to load routes',
                      message: _errorMessage!,
                    )
                  else if (_routes.isEmpty)
                    _buildMessageCard(
                      icon: Icons.route_outlined,
                      title: 'No matching direct routes found',
                      message:
                      'The available dataset did not return a direct '
                          'route matching these stop names. Check the '
                          'spelling or try another stop.',
                    )
                  else ...[
                      _buildTopRecommendation(),
                      if (_routes.length > 1) ...[
                        const SizedBox(height: 24),
                        const Text(
                          'Other route options',
                          style: TextStyle(
                            color: textDark,
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ..._routes.skip(1).map(
                              (route) => Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _buildRouteCard(route),
                          ),
                        ),
                      ],
                    ],
                  const SizedBox(height: 18),
                  _buildDatasetNotice(),
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
            child: const Icon(
              Icons.arrow_back_rounded,
              color: navy,
            ),
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
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.directions_bus_rounded,
                  color: teal,
                );
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
                'ROUTE RESULTS',
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Compare your journey options',
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
            Icons.alt_route_rounded,
            color: teal,
          ),
        ),
      ],
    );
  }

  Widget _buildJourneySummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [teal, cyan],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3500C7B7),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.trip_origin_rounded,
                color: navy,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.from,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 9),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 2,
                height: 24,
                color: navy.withOpacity(0.35),
              ),
            ),
          ),
          Row(
            children: [
              const Icon(
                Icons.location_on_rounded,
                color: navy,
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.to,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: navy.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'Edit',
                    style: TextStyle(
                      color: navy,
                      fontSize: 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortRow() {
    const sorts = [
      'Recommended',
      'Fewest stops',
      'Route name',
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: sorts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final selected = _selectedSort == index;

          return GestureDetector(
            onTap: () => _selectSort(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: selected ? navy : white,
                border: Border.all(
                  color: selected ? navy : lightBorder,
                ),
                boxShadow: selected
                    ? const [
                  BoxShadow(
                    color: Color(0x1F071B2C),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ]
                    : null,
              ),
              child: Text(
                sorts[index],
                style: TextStyle(
                  color: selected ? cyan : textMuted,
                  fontSize: 12,
                  fontWeight:
                  selected ? FontWeight.w900 : FontWeight.w700,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopRecommendation() {
    final result = _routes.first;
    final routeName = _routeName(result);
    final stopCount = _stopCount(result);
    final departure = _departureLabel(result);
    final network = _networkLabel(result);
    final stops = _stops(result);

    final stopSummary = stopCount > 0
        ? '$stopCount stops recorded'
        : 'Stop count unavailable';

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
            color: Color(0x26071B2C),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: cyan.withOpacity(0.13),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'GTFS MATCH',
                  style: TextStyle(
                    color: cyan,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.route_outlined,
                color: teal,
                size: 21,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [teal, cyan]),
                  borderRadius: BorderRadius.all(Radius.circular(18)),
                ),
                child: const Icon(
                  Icons.directions_bus_rounded,
                  color: navy,
                  size: 29,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routeName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      stopSummary,
                      style: const TextStyle(
                        color: softText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _infoItem(
                icon: Icons.schedule_rounded,
                label: 'Departure',
                value: departure,
              ),
              _divider(),
              _infoItem(
                icon: Icons.pin_drop_outlined,
                label: 'Stops',
                value: stopCount > 0 ? '$stopCount' : 'N/A',
              ),
              _divider(),
              _infoItem(
                icon: Icons.account_tree_outlined,
                label: 'Networks',
                value: _text(
                  result['networks'] is List
                      ? (result['networks'] as List).length
                      : null,
                  fallback: 'N/A',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.07),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              network,
              style: const TextStyle(
                color: softText,
                fontSize: 11,
                height: 1.5,
              ),
            ),
          ),
          if (stops.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Stops in this route',
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 10),
            ...stops.take(4).toList().asMap().entries.map((entry) {
              final isLast = entry.key == stops.take(4).length - 1;

              return Padding(
                padding: const EdgeInsets.only(bottom: 9),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Icon(
                          entry.key == 0
                              ? Icons.trip_origin_rounded
                              : Icons.circle,
                          size: entry.key == 0 ? 17 : 9,
                          color: entry.key == 0 ? cyan : teal,
                        ),
                        if (!isLast)
                          Container(
                            width: 1,
                            height: 13,
                            color: Colors.white24,
                          ),
                      ],
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _stopName(entry.value),
                        style: const TextStyle(
                          color: softText,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            if (stops.length > 4)
              Text(
                '+ ${stops.length - 4} more stops',
                style: const TextStyle(
                  color: cyan,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
          ],
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [teal, cyan]),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => _openRouteDetails(result),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'View Route Details',
                        style: TextStyle(
                          color: navy,
                          fontSize: 15,
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteCard(Map<String, dynamic> result) {
    final routeName = _routeName(result);
    final stopCount = _stopCount(result);
    final departure = _departureLabel(result);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: cardColor,
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
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: softCyan,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.directions_bus_rounded,
                  color: teal,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      routeName,
                      style: const TextStyle(
                        color: textDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      stopCount > 0
                          ? '$stopCount stops recorded'
                          : 'Stop count unavailable',
                      style: const TextStyle(
                        color: textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.dataset_outlined,
                color: teal,
                size: 22,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              const Icon(
                Icons.schedule_rounded,
                color: textMuted,
                size: 17,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  departure,
                  style: const TextStyle(
                    color: textMuted,
                    fontSize: 11.5,
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _openRouteDetails(result),
                child: const Text(
                  'Details',
                  style: TextStyle(
                    color: teal,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: lightBorder),
      ),
      child: Column(
        children: [
          Icon(icon, color: teal, size: 42),
          const SizedBox(height: 14),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textDark,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textMuted,
              fontSize: 12,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatasetNotice() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: lightBorder),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline_rounded,
            color: teal,
            size: 21,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'These results are based on the available GTFS dataset. '
                  'Live bus positions, verified current service status, '
                  'fares, and journey durations are not confirmed here. '
                  'Departure entries are shown only when supplied by the dataset.',
              style: TextStyle(
                color: textMuted,
                fontSize: 11,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: cyan, size: 21),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: softText,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1,
      height: 42,
      margin: const EdgeInsets.symmetric(horizontal: 7),
      color: Colors.white.withOpacity(0.16),
    );
  }
}

class _RouteResultsBackground extends StatelessWidget {
  const _RouteResultsBackground();

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
          top: -120,
          right: -90,
          child: Container(
            width: 300,
            height: 300,
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
            width: 320,
            height: 320,
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
