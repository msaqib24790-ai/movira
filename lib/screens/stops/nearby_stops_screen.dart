import 'package:flutter/material.dart';
import 'stop_details_screen.dart';

class NearbyStopsScreen extends StatefulWidget {
  const NearbyStopsScreen({super.key});

  @override
  State<NearbyStopsScreen> createState() => _NearbyStopsScreenState();
}

class _NearbyStopsScreenState extends State<NearbyStopsScreen> {
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

  int _selectedFilter = 0;

  final List<Map<String, dynamic>> _stops = [
    {
      'name': 'Central Station',
      'distance': '250 m',
      'walk': '3 min walk',
      'routes': ['M-12', 'M-03', 'M-08'],
      'eta': '2 min',
      'status': 'Open',
      'distanceMeters': 250,
      'etaMinutes': 2,
      'accessible': true,
    },
    {
      'name': 'Main Market Stop',
      'distance': '480 m',
      'walk': '6 min walk',
      'routes': ['M-12', 'M-21'],
      'eta': '5 min',
      'status': 'Open',
      'distanceMeters': 480,
      'etaMinutes': 5,
      'accessible': true,
    },
    {
      'name': 'College Road',
      'distance': '720 m',
      'walk': '9 min walk',
      'routes': ['M-08', 'M-16'],
      'eta': '7 min',
      'status': 'Busy',
      'distanceMeters': 720,
      'etaMinutes': 7,
      'accessible': false,
    },
    {
      'name': 'City Center',
      'distance': '1.1 km',
      'walk': '14 min walk',
      'routes': ['M-03', 'M-21', 'M-30'],
      'eta': '10 min',
      'status': 'Open',
      'distanceMeters': 1100,
      'etaMinutes': 10,
      'accessible': true,
    },
  ];

  List<Map<String, dynamic>> get _visibleStops {
    final items = _stops.map((stop) => Map<String, dynamic>.from(stop)).toList();

    if (_selectedFilter == 0) {
      items.sort(
            (a, b) => (a['distanceMeters'] as int)
            .compareTo(b['distanceMeters'] as int),
      );
    } else if (_selectedFilter == 1) {
      items.sort(
            (a, b) =>
            (a['etaMinutes'] as int).compareTo(b['etaMinutes'] as int),
      );
    } else {
      items.removeWhere((stop) => stop['accessible'] != true);
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ice,
      body: Stack(
        children: [
          const _NearbyStopsBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildLocationHero(),
                  const SizedBox(height: 24),
                  const Text(
                    'Stops near you',
                    style: TextStyle(
                      color: textDark,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    'Nearby boarding points sorted by walking distance.',
                    style: TextStyle(
                      color: textMuted,
                      fontSize: 13.5,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildMapPreview(),
                  const SizedBox(height: 24),
                  _buildFilterRow(),
                  const SizedBox(height: 18),
                  ..._visibleStops.map(
                        (stop) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _buildStopCard(stop),
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
                'NEARBY STOPS',
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Stops around your location',
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
            Icons.near_me_rounded,
            color: teal,
          ),
        ),
      ],
    );
  }

  Widget _buildLocationHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
            color: Color(0x25071B2C),
            blurRadius: 22,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [teal, cyan],
              ),
            ),
            child: const Icon(
              Icons.my_location_rounded,
              color: navy,
              size: 29,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Location',
                  style: TextStyle(
                    color: Color(0xFFC7E3EF),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Detecting your location',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Showing the closest transit stops',
                  style: TextStyle(
                    color: cyan,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Change',
              style: TextStyle(
                color: cyan,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMapPreview() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: lightBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10071B2C),
            blurRadius: 16,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: Stack(
          children: [
            const Positioned.fill(
              child: CustomPaint(
                painter: _NearbyMapPainter(),
              ),
            ),
            Positioned(
              top: 14,
              left: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: lightBorder),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: teal,
                      size: 8,
                    ),
                    SizedBox(width: 6),
                    Text(
                      '4 STOPS FOUND',
                      style: TextStyle(
                        color: navy,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: const Alignment(-0.05, 0.02),
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: cyan.withOpacity(0.17),
                ),
                child: Center(
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: navy,
                    ),
                    child: const Icon(
                      Icons.person_pin_circle_rounded,
                      color: cyan,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ),
            const Positioned(
              left: 44,
              top: 94,
              child: _MiniStopMarker(label: 'A'),
            ),
            const Positioned(
              right: 54,
              top: 62,
              child: _MiniStopMarker(label: 'B'),
            ),
            const Positioned(
              left: 84,
              bottom: 34,
              child: _MiniStopMarker(label: 'C'),
            ),
            const Positioned(
              right: 88,
              bottom: 42,
              child: _MiniStopMarker(label: 'D'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow() {
    const filters = ['Nearest', 'Fastest Bus', 'Accessible'];

    return Row(
      children: List.generate(filters.length, (index) {
        final selected = _selectedFilter == index;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index == filters.length - 1 ? 0 : 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 11,
                ),
                decoration: BoxDecoration(
                  color: selected ? navy : white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: selected ? navy : lightBorder,
                  ),
                ),
                child: Text(
                  filters[index],
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? cyan : textMuted,
                    fontSize: 10.5,
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

  Widget _buildStopCard(Map<String, dynamic> stop) {
    final bool busy = stop['status'] == 'Busy';

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
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: softCyan,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.directions_bus_rounded,
                  color: teal,
                  size: 25,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      stop['name'],
                      style: const TextStyle(
                        color: textDark,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${stop['distance']} • ${stop['walk']}',
                      style: const TextStyle(
                        color: textMuted,
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: busy
                      ? const Color(0xFFFFF3E5)
                      : const Color(0xFFEAF9EF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  stop['status'],
                  style: TextStyle(
                    color: busy
                        ? const Color(0xFFB86A00)
                        : const Color(0xFF16834D),
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              const Icon(
                Icons.alt_route_rounded,
                color: cyan,
                size: 18,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: (stop['routes'] as List<String>)
                      .map(
                        (route) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F9FB),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        route,
                        style: const TextStyle(
                          color: navy,
                          fontSize: 9.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  )
                      .toList(),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: softCyan,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Next ${stop['eta']}',
                  style: const TextStyle(
                    color: teal,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.directions_walk_rounded,
                    size: 18,
                  ),
                  label: const Text('Directions'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: navy,
                    side: const BorderSide(color: lightBorder),
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StopDetailsScreen(
                          stopName: stop['name'] as String,
                          distance: stop['distance'] as String,
                          walkingTime: stop['walk'] as String,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.arrow_forward_rounded,
                    size: 18,
                  ),
                  label: const Text('View Stop'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navy,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 13),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
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
}

class _NearbyStopsBackground extends StatelessWidget {
  const _NearbyStopsBackground();

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

class _MiniStopMarker extends StatelessWidget {
  final String label;

  const _MiniStopMarker({
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF071B2C),
      ),
      child: Center(
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF21D4FD),
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}

class _NearbyMapPainter extends CustomPainter {
  const _NearbyMapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFE7F0F3)
      ..strokeWidth = 1;

    const spacing = 34.0;

    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    final roadPaint = Paint()
      ..color = const Color(0xFFD4E7EC)
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final roadPaint2 = Paint()
      ..color = const Color(0xFFB8F4F0)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path1 = Path()
      ..moveTo(-20, size.height * 0.72)
      ..cubicTo(
        size.width * 0.25,
        size.height * 0.56,
        size.width * 0.48,
        size.height * 0.70,
        size.width + 20,
        size.height * 0.28,
      );

    final path2 = Path()
      ..moveTo(size.width * 0.10, -10)
      ..cubicTo(
        size.width * 0.30,
        size.height * 0.34,
        size.width * 0.56,
        size.height * 0.22,
        size.width * 0.86,
        size.height + 10,
      );

    canvas.drawPath(path1, roadPaint);
    canvas.drawPath(path2, roadPaint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
