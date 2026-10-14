import 'package:flutter/material.dart';

class TripSummaryScreen extends StatefulWidget {
  final String from;
  final String to;

  const TripSummaryScreen({
    super.key,
    this.from = 'Central Station',
    this.to = 'City Mall',
  });

  @override
  State<TripSummaryScreen> createState() => _TripSummaryScreenState();
}

class _TripSummaryScreenState extends State<TripSummaryScreen> {
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

  bool _saved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ice,
      body: Stack(
        children: [
          const _TripSummaryBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildHero(),
                  const SizedBox(height: 22),
                  _buildJourneyCard(),
                  const SizedBox(height: 22),
                  _buildStatsRow(),
                  const SizedBox(height: 26),
                  _sectionTitle(
                    'Recommended Journey',
                    'Best route based on your preferences',
                  ),
                  const SizedBox(height: 14),
                  _buildRecommendedRoute(),
                  const SizedBox(height: 26),
                  _sectionTitle(
                    'Trip Timeline',
                    'Step-by-step journey overview',
                  ),
                  const SizedBox(height: 14),
                  _buildTimeline(),
                  const SizedBox(height: 26),
                  _sectionTitle(
                    'Fare Summary',
                    'Estimated travel cost',
                  ),
                  const SizedBox(height: 14),
                  _buildFareCard(),
                  const SizedBox(height: 24),
                  _buildActions(),
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
                'TRIP SUMMARY',
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Review your planned journey',
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
            Icons.route_rounded,
            color: teal,
          ),
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
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [teal, cyan],
              ),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
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
                  'Your trip is ready',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'MOVIRA found the best journey for your selected route.',
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
          const Icon(
            Icons.chevron_right_rounded,
            color: cyan,
            size: 28,
          ),
        ],
      ),
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
            label: 'Starting Point',
            value: widget.from,
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
            value: widget.to,
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

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            icon: Icons.schedule_rounded,
            value: '24 min',
            label: 'Duration',
            color: cyan,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            icon: Icons.payments_outlined,
            value: 'Rs. 80',
            label: 'Fare',
            color: teal,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _statCard(
            icon: Icons.pin_drop_outlined,
            value: '8',
            label: 'Stops',
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

  Widget _buildRecommendedRoute() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: navySoft,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: teal.withOpacity(0.22),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [teal, cyan],
                  ),
                ),
                child: const Center(
                  child: Text(
                    'M-12',
                    style: TextStyle(
                      color: navy,
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 13),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MOVIRA City Service',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      '11:10 AM → 11:34 AM',
                      style: TextStyle(
                        color: Color(0xFFB8D8E8),
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
                  color: success.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Text(
                  'ON TIME',
                  style: TextStyle(
                    color: success,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              Expanded(
                child: _RouteMetric(
                  icon: Icons.bolt_rounded,
                  label: 'Fastest',
                ),
              ),
              Expanded(
                child: _RouteMetric(
                  icon: Icons.directions_walk_rounded,
                  label: 'Low walking',
                ),
              ),
              Expanded(
                child: _RouteMetric(
                  icon: Icons.accessible_rounded,
                  label: 'Accessible',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    final steps = [
      ['Walk', 'Walk 3 min to Central Station'],
      ['Board M-12', 'Board bus from Bay 2'],
      ['Ride', 'Travel through 8 stops'],
      ['Arrive', 'Reach City Mall at 11:34 AM'],
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: lightBorder),
      ),
      child: Column(
        children: List.generate(steps.length, (index) {
          final bool last = index == steps.length - 1;

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
                        color: index == 0
                            ? teal
                            : last
                            ? cyan
                            : navySoft,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                    if (!last)
                      Container(
                        width: 2,
                        height: 54,
                        color: const Color(0xFFD9E7EC),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        steps[index][0],
                        style: const TextStyle(
                          color: textDark,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        steps[index][1],
                        style: const TextStyle(
                          color: textMuted,
                          fontSize: 10.8,
                          height: 1.4,
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
    );
  }

  Widget _buildFareCard() {
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
          _fareRow('Base Fare', 'Rs. 50'),
          const Divider(height: 24, color: Color(0xFFE7EEF1)),
          _fareRow('Distance Fare', 'Rs. 30'),
          const Divider(height: 24, color: Color(0xFFE7EEF1)),
          _fareRow('Total Fare', 'Rs. 80', highlight: true),
        ],
      ),
    );
  }

  Widget _fareRow(
      String label,
      String value, {
        bool highlight = false,
      }) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            color: highlight ? textDark : textMuted,
            fontSize: highlight ? 14 : 12.5,
            fontWeight:
            highlight ? FontWeight.w900 : FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: highlight ? teal : textDark,
            fontSize: highlight ? 17 : 13,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              setState(() {
                _saved = !_saved;
              });
            },
            icon: Icon(
              _saved
                  ? Icons.bookmark_rounded
                  : Icons.bookmark_border_rounded,
            ),
            label: Text(_saved ? 'Saved' : 'Save Trip'),
            style: OutlinedButton.styleFrom(
              foregroundColor: navy,
              side: const BorderSide(color: lightBorder),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Trip start flow will connect with live journey screens later.',
                  ),
                ),
              );
            },
            icon: const Icon(Icons.navigation_rounded),
            label: const Text('Start Trip'),
            style: ElevatedButton.styleFrom(
              backgroundColor: navy,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(17),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _RouteMetric extends StatelessWidget {
  final IconData icon;
  final String label;

  const _RouteMetric({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 2),
        Icon(
          icon,
          color: Color(0xFF21D4FD),
          size: 19,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color(0xFFB8D8E8),
            fontSize: 9.8,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _TripSummaryBackground extends StatelessWidget {
  const _TripSummaryBackground();

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
