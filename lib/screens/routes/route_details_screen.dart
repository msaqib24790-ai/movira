import 'package:flutter/material.dart';
import '../tracking/live_bus_tracking_screen.dart';

class RouteDetailsScreen extends StatefulWidget {
  final String busNumber;
  final String from;
  final String to;
  final String duration;
  final String fare;
  final String status;

  const RouteDetailsScreen({
    super.key,
    required this.busNumber,
    required this.from,
    required this.to,
    required this.duration,
    required this.fare,
    required this.status,
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

  final List<Map<String, dynamic>> _stops = [
    {
      'name': 'Central Station',
      'time': '11:10 PM',
      'type': 'start',
    },
    {
      'name': 'Main Market',
      'time': '11:14 PM',
      'type': 'middle',
    },
    {
      'name': 'College Road',
      'time': '11:17 PM',
      'type': 'middle',
    },
    {
      'name': 'Civil Hospital',
      'time': '11:20 PM',
      'type': 'middle',
    },
    {
      'name': 'City Center',
      'time': '11:24 PM',
      'type': 'middle',
    },
    {
      'name': 'Park Avenue',
      'time': '11:28 PM',
      'type': 'middle',
    },
    {
      'name': 'Metro Chowk',
      'time': '11:31 PM',
      'type': 'middle',
    },
    {
      'name': 'City Mall',
      'time': '11:34 PM',
      'type': 'end',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ice,
      body: Stack(
        children: [
          const _RouteDetailsBackground(),

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
              color: _isFavorite
                  ? const Color(0xFFFFF6DD)
                  : white,
              border: Border.all(
                color: _isFavorite
                    ? const Color(0xFFF59E0B).withOpacity(0.30)
                    : lightBorder,
              ),
            ),
            child: Icon(
              _isFavorite
                  ? Icons.star_rounded
                  : Icons.star_border_rounded,
              color: _isFavorite
                  ? const Color(0xFFF59E0B)
                  : navy,
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
          colors: [
            teal,
            cyan,
          ],
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
                  'MOVIRA City Service',
                  style: TextStyle(
                    color: Color(0xFF123B49),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: navy.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.circle,
                            color: Color(0xFF15803D),
                            size: 8,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            widget.status,
                            style: const TextStyle(
                              color: navy,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
        Icon(
          icon,
          color: color,
          size: 21,
        ),
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
            title: '8',
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
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color.withOpacity(0.18),
        ),
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
          Icon(
            icon,
            color: color,
            size: 22,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textDark,
              fontSize: 13,
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
    final tabs = [
      'Stops',
      'Fare',
      'Timetable',
    ];

    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: lightBorder),
      ),
      child: Row(
        children: List.generate(
          tabs.length,
              (index) {
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
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: selected
                        ? const LinearGradient(
                      colors: [teal, cyan],
                    )
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
          },
        ),
      ),
    );
  }

  Widget _buildStopsSection() {
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
          'Estimated arrival times at each stop',
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
            border: Border.all(
              color: lightBorder,
            ),
          ),
          child: Column(
            children: List.generate(
              _stops.length,
                  (index) {
                final stop = _stops[index];
                final bool first = index == 0;
                final bool last = index == _stops.length - 1;

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
                                    ? Colors.white
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
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    stop['name'],
                                    style: TextStyle(
                                      color: first || last
                                          ? Colors.white
                                          : const Color(0xFFD3E4EC),
                                      fontSize: 13,
                                      fontWeight: first || last
                                          ? FontWeight.w900
                                          : FontWeight.w700,
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    first
                                        ? 'Board bus'
                                        : last
                                        ? 'Destination'
                                        : 'Bus stop',
                                    style: const TextStyle(
                                      color: softText,
                                      fontSize: 10.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Text(
                              stop['time'],
                              style: TextStyle(
                                color: first || last ? teal : textMuted,
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
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
            border: Border.all(
              color: teal.withOpacity(0.18),
            ),
          ),
          child: Column(
            children: [
              _fareRow(
                title: 'Base Fare',
                value: 'Rs. 50',
              ),

              const Divider(
                height: 28,
                color: Color(0xFFE7EEF1),
              ),

              _fareRow(
                title: 'Distance Fare',
                value: 'Rs. 30',
              ),

              const Divider(
                height: 28,
                color: Color(0xFFE7EEF1),
              ),

              _fareRow(
                title: 'Total Fare',
                value: widget.fare,
                highlight: true,
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
              Icon(
                Icons.info_outline_rounded,
                color: cyan,
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Final production fares will come from the real transport database.',
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

  Widget _fareRow({
    required String title,
    required String value,
    bool highlight = false,
  }) {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            color: highlight ? textDark : textMuted,
            fontSize: highlight ? 14 : 13,
            fontWeight:
            highlight ? FontWeight.w900 : FontWeight.w600,
          ),
        ),

        const Spacer(),

        Text(
          value,
          style: TextStyle(
            color: highlight ? teal : textDark,
            fontSize: highlight ? 18 : 13.5,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildTimetableSection() {
    final times = [
      ['11:10 PM', '11:34 PM', 'On Time'],
      ['11:30 PM', '11:54 PM', 'On Time'],
      ['11:50 PM', '12:14 AM', 'On Time'],
      ['12:10 AM', '12:34 AM', 'Scheduled'],
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Trips',
          style: TextStyle(
            color: textDark,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),

        const SizedBox(height: 16),

        ...times.map(
              (trip) => Container(
            margin: const EdgeInsets.only(bottom: 11),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor.withOpacity(0.9),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: lightBorder,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.schedule_rounded,
                  color: cyan,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    '${trip[0]} → ${trip[1]}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),

                Text(
                  trip[2],
                  style: const TextStyle(
                    color: teal,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
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
        color: const Color(0xFFF1FBF4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF22C55E).withOpacity(0.22),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x1422C55E),
            ),
            child: const Icon(
              Icons.check_circle_outline_rounded,
              color: Color(0xFF22C55E),
            ),
          ),
          const SizedBox(width: 13),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Normal Service',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'No major disruptions currently reported on this route.',
                  style: TextStyle(
                    color: Color(0xFF4E7A5D),
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
        gradient: const LinearGradient(
          colors: [
            teal,
            cyan,
          ],
        ),
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