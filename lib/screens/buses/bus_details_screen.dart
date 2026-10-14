import 'package:flutter/material.dart';

class BusDetailsScreen extends StatefulWidget {
  final String busNumber;
  final String destination;
  final String eta;
  final String status;

  const BusDetailsScreen({
    super.key,
    this.busNumber = 'M-12',
    this.destination = 'City Mall',
    this.eta = '2 min',
    this.status = 'On Time',
  });

  @override
  State<BusDetailsScreen> createState() => _BusDetailsScreenState();
}

class _BusDetailsScreenState extends State<BusDetailsScreen> {
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
  static const Color success = Color(0xFF22C55E);

  final List<Map<String, String>> _nextStops = [
    {'name': 'Main Market', 'time': '3 min'},
    {'name': 'College Road', 'time': '6 min'},
    {'name': 'Civil Hospital', 'time': '9 min'},
    {'name': 'City Center', 'time': '13 min'},
  ];

  @override
  Widget build(BuildContext context) {
    final bool delayed = widget.status.toLowerCase().contains('delay');

    return Scaffold(
      backgroundColor: ice,
      body: Stack(
        children: [
          const _BusDetailsBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildBusHero(delayed),
                  const SizedBox(height: 20),
                  _buildQuickStats(),
                  const SizedBox(height: 26),
                  _sectionTitle(
                    'Current Journey',
                    'Live trip details for this vehicle',
                  ),
                  const SizedBox(height: 14),
                  _buildJourneyCard(),
                  const SizedBox(height: 26),
                  _sectionTitle(
                    'Next Stops',
                    'Upcoming stops on this route',
                  ),
                  const SizedBox(height: 14),
                  _buildNextStopsCard(),
                  const SizedBox(height: 26),
                  _sectionTitle(
                    'Bus Features',
                    'Facilities available on this vehicle',
                  ),
                  const SizedBox(height: 14),
                  _buildFeaturesGrid(),
                  const SizedBox(height: 26),
                  _sectionTitle(
                    'Vehicle Information',
                    'Operational details for this bus',
                  ),
                  const SizedBox(height: 14),
                  _buildVehicleInfoCard(),
                  const SizedBox(height: 24),
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
                'BUS DETAILS',
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Vehicle • route • live status',
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
            Icons.directions_bus_filled_rounded,
            color: teal,
          ),
        ),
      ],
    );
  }

  Widget _buildBusHero(bool delayed) {
    final Color statusColor =
    delayed ? const Color(0xFFF59E0B) : success;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
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
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: const LinearGradient(
                    colors: [teal, cyan],
                  ),
                ),
                child: const Icon(
                  Icons.directions_bus_filled_rounded,
                  color: navy,
                  size: 38,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bus ${widget.busNumber}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'To ${widget.destination}',
                      style: const TextStyle(
                        color: Color(0xFFC7E3EF),
                        fontSize: 12,
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
                        color: statusColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.circle,
                            color: statusColor,
                            size: 7,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            widget.status.toUpperCase(),
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
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
                color: cyan,
                size: 28,
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.location_searching_rounded,
                  color: teal,
                  size: 20,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'Live GPS tracking is active for this bus',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  widget.eta,
                  style: const TextStyle(
                    color: cyan,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.schedule_rounded,
            value: widget.eta,
            label: 'Arrival',
            color: cyan,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            icon: Icons.speed_rounded,
            value: '32 km/h',
            label: 'Speed',
            color: teal,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            icon: Icons.people_alt_outlined,
            value: 'Medium',
            label: 'Crowd',
            color: const Color(0xFF8B5CF6),
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
      padding: const EdgeInsets.symmetric(
        vertical: 14,
        horizontal: 7,
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
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textDark,
              fontSize: 12,
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

  Widget _buildJourneyCard() {
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
          _journeyPoint(
            icon: Icons.trip_origin_rounded,
            label: 'Current Stop',
            value: 'Central Station',
            color: teal,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 2,
                height: 28,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [teal, cyan],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),
          _journeyPoint(
            icon: Icons.location_on_rounded,
            label: 'Destination',
            value: widget.destination,
            color: cyan,
          ),
        ],
      ),
    );
  }

  Widget _journeyPoint({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
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

  Widget _buildNextStopsCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: lightBorder),
      ),
      child: Column(
        children: _nextStops.asMap().entries.map((entry) {
          final int index = entry.key;
          final stop = entry.value;

          return Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: index == 0 ? softCyan : const Color(0xFFF3F7F9),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: index == 0 ? teal : textMuted,
                          fontSize: 10.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      stop['name']!,
                      style: const TextStyle(
                        color: textDark,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    stop['time']!,
                    style: TextStyle(
                      color: index == 0 ? teal : textMuted,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              if (index != _nextStops.length - 1)
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

  Widget _buildFeaturesGrid() {
    final features = <Map<String, dynamic>>[
      {
        'icon': Icons.ac_unit_rounded,
        'label': 'Air Conditioned',
        'color': cyan,
      },
      {
        'icon': Icons.wifi_rounded,
        'label': 'Wi-Fi',
        'color': teal,
      },
      {
        'icon': Icons.accessible_rounded,
        'label': 'Accessible',
        'color': const Color(0xFF8B5CF6),
      },
      {
        'icon': Icons.security_rounded,
        'label': 'CCTV',
        'color': success,
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
        itemCount: features.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.5,
        ),
        itemBuilder: (context, index) {
          final item = features[index];
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
                      fontSize: 11,
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

  Widget _buildVehicleInfoCard() {
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
            icon: Icons.confirmation_number_outlined,
            label: 'Vehicle ID',
            value: 'MV-${widget.busNumber.replaceAll('-', '')}-24',
          ),
          const Divider(height: 22, color: Color(0xFFE7EEF1)),
          _infoRow(
            icon: Icons.event_seat_outlined,
            label: 'Capacity',
            value: '42 seats',
          ),
          const Divider(height: 22, color: Color(0xFFE7EEF1)),
          _infoRow(
            icon: Icons.badge_outlined,
            label: 'Driver',
            value: 'Verified',
          ),
          const Divider(height: 22, color: Color(0xFFE7EEF1)),
          _infoRow(
            icon: Icons.miscellaneous_services_rounded,
            label: 'Service Type',
            value: 'City Express',
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
          child: Icon(
            icon,
            color: teal,
            size: 19,
          ),
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
        Text(
          value,
          style: const TextStyle(
            color: textDark,
            fontSize: 12.5,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildTrackButton() {
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
                  'Live tracking connection will be linked with Screen 11.',
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
                size: 21,
              ),
              SizedBox(width: 10),
              Text(
                'Track This Bus Live',
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

class _BusDetailsBackground extends StatelessWidget {
  const _BusDetailsBackground();

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
