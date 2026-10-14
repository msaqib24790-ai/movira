import 'package:flutter/material.dart';
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

  int _selectedSort = 0;

  final List<Map<String, dynamic>> _routes = [
    {
      'bus': 'M-12',
      'time': '24 min',
      'fare': 'Rs. 80',
      'stops': '8 stops',
      'next': '3 min',
      'status': 'On Time',
      'statusColor': const Color(0xFF22C55E),
      'badge': 'FASTEST',
      'badgeColor': cyan,
      'departure': '11:10 PM',
      'arrival': '11:34 PM',
    },
    {
      'bus': 'M-08',
      'time': '31 min',
      'fare': 'Rs. 60',
      'stops': '11 stops',
      'next': '6 min',
      'status': 'On Time',
      'statusColor': const Color(0xFF22C55E),
      'badge': 'CHEAPEST',
      'badgeColor': teal,
      'departure': '11:13 PM',
      'arrival': '11:44 PM',
    },
    {
      'bus': 'M-21',
      'time': '28 min',
      'fare': 'Rs. 90',
      'stops': '6 stops',
      'next': '9 min',
      'status': 'Delayed',
      'statusColor': const Color(0xFFF59E0B),
      'badge': 'FEWER STOPS',
      'badgeColor': const Color(0xFF8B5CF6),
      'departure': '11:16 PM',
      'arrival': '11:44 PM',
    },
  ];

  void _openRouteDetails(Map<String, dynamic> route) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RouteDetailsScreen(
          busNumber: route['bus'],
          from: widget.from,
          to: widget.to,
          duration: route['time'],
          fare: route['fare'],
          status: route['status'],
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
              padding: const EdgeInsets.fromLTRB(
                20,
                18,
                20,
                40,
              ),
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
                    'Compare route options and choose the journey that works best.',
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

                  _buildTopRecommendation(),

                  const SizedBox(height: 22),

                  const Text(
                    'Other route options',
                    style: TextStyle(
                      color: Colors.white,
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
          onTap: () {
            Navigator.pop(context);
          },
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
          colors: [
            teal,
            cyan,
          ],
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
                onTap: () {
                  Navigator.pop(context);
                },
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
    final sorts = [
      'Recommended',
      'Fastest',
      'Cheapest',
    ];

    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: sorts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final selected = _selectedSort == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedSort = index;
              });
            },
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
    final route = _routes.first;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            navy,
            navySoft,
            Color(0xFF15516A),
          ],
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
                  'BEST MATCH',
                  style: TextStyle(
                    color: cyan,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.7,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: (route['statusColor'] as Color).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: route['statusColor'],
                      size: 8,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      route['status'],
                      style: TextStyle(
                        color: route['statusColor'],
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
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
                  gradient: LinearGradient(
                    colors: [teal, cyan],
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(18),
                  ),
                ),
                child: Center(
                  child: Text(
                    route['bus'],
                    style: const TextStyle(
                      color: navy,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${route['departure']} → ${route['arrival']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${route['time']} • ${route['stops']}',
                      style: const TextStyle(
                        color: softText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: (route['badgeColor'] as Color).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  route['badge'],
                  style: TextStyle(
                    color: route['badgeColor'],
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              _infoItem(
                icon: Icons.schedule_rounded,
                label: 'Next Bus',
                value: route['next'],
              ),
              _divider(),
              _infoItem(
                icon: Icons.payments_outlined,
                label: 'Fare',
                value: route['fare'],
              ),
              _divider(),
              _infoItem(
                icon: Icons.pin_drop_outlined,
                label: 'Stops',
                value: route['stops'],
              ),
            ],
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 54,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [teal, cyan],
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () {
                    _openRouteDetails(route);
                  },
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

  Widget _buildRouteCard(Map<String, dynamic> route) {
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
                child: Center(
                  child: Text(
                    route['bus'],
                    style: const TextStyle(
                      color: teal,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
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
                      '${route['departure']} → ${route['arrival']}',
                      style: const TextStyle(
                        color: textDark,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${route['time']} • ${route['stops']} • ${route['fare']}',
                      style: const TextStyle(
                        color: textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    route['badge'],
                    style: TextStyle(
                      color: route['badgeColor'],
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    route['status'],
                    style: TextStyle(
                      color: route['statusColor'],
                      fontSize: 10.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
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
              Text(
                'Next bus in ${route['next']}',
                style: const TextStyle(
                  color: textMuted,
                  fontSize: 11.5,
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  _openRouteDetails(route);
                },
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

  Widget _infoItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(
            icon,
            color: cyan,
            size: 21,
          ),

          const SizedBox(height: 6),

          Text(
            label,
            style: const TextStyle(
              color: softText,
              fontSize: 10,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11.5,
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
      color: Colors.white.withOpacity(0.08),
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