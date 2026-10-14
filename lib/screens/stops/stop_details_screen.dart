import 'package:flutter/material.dart';
import '../buses/bus_details_screen.dart';

class StopDetailsScreen extends StatefulWidget {
  final String stopName;
  final String distance;
  final String walkingTime;

  const StopDetailsScreen({
    super.key,
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

  final List<Map<String, dynamic>> _upcomingBuses = [
    {
      'bus': 'M-12',
      'destination': 'City Mall',
      'eta': '2 min',
      'status': 'On Time',
      'statusColor': const Color(0xFF22C55E),
      'platform': 'Bay 2',
    },
    {
      'bus': 'M-03',
      'destination': 'University',
      'eta': '6 min',
      'status': 'On Time',
      'statusColor': const Color(0xFF22C55E),
      'platform': 'Bay 1',
    },
    {
      'bus': 'M-08',
      'destination': 'Airport',
      'eta': '11 min',
      'status': 'Delayed',
      'statusColor': const Color(0xFFF59E0B),
      'platform': 'Bay 3',
    },
  ];

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
                    'Upcoming Buses',
                    'Live arrivals for this stop',
                  ),
                  const SizedBox(height: 14),
                  ..._upcomingBuses.map(
                        (bus) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildBusArrivalCard(bus),
                    ),
                  ),
                  const SizedBox(height: 14),
                  _sectionTitle(
                    'Stop Facilities',
                    'Available services at this location',
                  ),
                  const SizedBox(height: 14),
                  _buildFacilitiesCard(),
                  const SizedBox(height: 24),
                  _sectionTitle(
                    'Route Information',
                    'Routes serving this stop',
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
                'Live arrivals • facilities • routes',
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
            Icons.pin_drop_rounded,
            color: teal,
          ),
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
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [teal, cyan],
              ),
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
                  widget.stopName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  '${widget.distance} • ${widget.walkingTime}',
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
                    color: const Color(0xFF22C55E).withOpacity(0.14),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'OPEN • ACTIVE STOP',
                    style: TextStyle(
                      color: Color(0xFF65E596),
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: cyan,
            size: 28,
          ),
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
            value: '3',
            label: 'Routes',
            color: cyan,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _quickInfo(
            icon: Icons.schedule_rounded,
            value: '2 min',
            label: 'Next Bus',
            color: teal,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _quickInfo(
            icon: Icons.accessible_rounded,
            value: 'Yes',
            label: 'Accessible',
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
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 8,
      ),
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
            style: const TextStyle(
              color: textDark,
              fontSize: 12.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: textMuted,
              fontSize: 9.5,
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
          style: const TextStyle(
            color: textMuted,
            fontSize: 11.5,
          ),
        ),
      ],
    );
  }

  Widget _buildBusArrivalCard(Map<String, dynamic> bus) {
    final Color statusColor = bus['statusColor'] as Color;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BusDetailsScreen(
              busNumber: bus['bus'] as String,
              destination: bus['destination'] as String,
              eta: bus['eta'] as String,
              status: bus['status'] as String,
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
                gradient: const LinearGradient(
                  colors: [teal, cyan],
                ),
              ),
              child: Center(
                child: Text(
                  bus['bus'] as String,
                  style: const TextStyle(
                    color: navy,
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
                    'To ${bus['destination']}',
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    bus['platform'] as String,
                    style: const TextStyle(
                      color: textMuted,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  bus['eta'] as String,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Icons.circle,
                      color: statusColor,
                      size: 7,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      bus['status'] as String,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 9.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFacilitiesCard() {
    final facilities = <Map<String, dynamic>>[
      {
        'icon': Icons.chair_alt_rounded,
        'label': 'Seating',
        'color': teal,
      },
      {
        'icon': Icons.light_rounded,
        'label': 'Lighting',
        'color': cyan,
      },
      {
        'icon': Icons.accessible_rounded,
        'label': 'Accessible',
        'color': const Color(0xFF8B5CF6),
      },
      {
        'icon': Icons.security_rounded,
        'label': 'CCTV',
        'color': const Color(0xFF22C55E),
      },
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: lightBorder),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: facilities.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.6,
        ),
        itemBuilder: (context, index) {
          final item = facilities[index];
          final Color color = item['color'] as Color;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                Icon(
                  item['icon'] as IconData,
                  color: color,
                  size: 20,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    item['label'] as String,
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildRoutesCard() {
    final routes = [
      ['M-12', 'City Mall', 'Every 10 min'],
      ['M-03', 'University', 'Every 15 min'],
      ['M-08', 'Airport', 'Every 20 min'],
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: lightBorder),
      ),
      child: Column(
        children: routes.asMap().entries.map((entry) {
          final int index = entry.key;
          final List<String> route = entry.value;

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
                      child: Text(
                        route[0],
                        style: const TextStyle(
                          color: teal,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
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
                          route[1],
                          style: const TextStyle(
                            color: textDark,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          route[2],
                          style: const TextStyle(
                            color: textMuted,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: textMuted,
                  ),
                ],
              ),
              if (index != routes.length - 1)
                const Divider(
                  height: 22,
                  color: Color(0xFFE7EEF1),
                ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDirectionsButton() {
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
                content: Text(
                  'Walking directions will be connected with Google Maps later.',
                ),
              ),
            );
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.directions_walk_rounded,
                color: navy,
                size: 21,
              ),
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
              colors: [
                Color(0xFFF9FDFF),
                Color(0xFFF0FAFD),
                Color(0xFFF7FCFD),
              ],
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
