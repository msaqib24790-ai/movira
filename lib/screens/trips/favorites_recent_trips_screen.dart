import 'package:flutter/material.dart';

class FavoritesRecentTripsScreen extends StatefulWidget {
  const FavoritesRecentTripsScreen({super.key});

  @override
  State<FavoritesRecentTripsScreen> createState() =>
      _FavoritesRecentTripsScreenState();
}

class _FavoritesRecentTripsScreenState
    extends State<FavoritesRecentTripsScreen> {
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
  static const Color warning = Color(0xFFF59E0B);

  int _selectedTab = 0;

  final List<Map<String, dynamic>> _favorites = [
    {
      'route': 'M-03',
      'from': 'Railway Station',
      'to': 'University',
      'time': '22 min',
      'fare': 'Rs. 70',
      'next': '6 min',
      'color': const Color(0xFF21D4FD),
    },
    {
      'route': 'M-08',
      'from': 'City Center',
      'to': 'Airport',
      'time': '31 min',
      'fare': 'Rs. 120',
      'next': '11 min',
      'color': const Color(0xFF8B5CF6),
    },
    {
      'route': 'M-12',
      'from': 'Central Station',
      'to': 'City Mall',
      'time': '24 min',
      'fare': 'Rs. 80',
      'next': '3 min',
      'color': const Color(0xFF00C7B7),
    },
  ];

  final List<Map<String, String>> _recentTrips = [
    {
      'route': 'M-12',
      'from': 'Central Station',
      'to': 'City Mall',
      'date': 'Yesterday',
      'time': '11:10 AM',
      'duration': '24 min',
    },
    {
      'route': 'M-03',
      'from': 'Railway Station',
      'to': 'University',
      'date': '12 Oct',
      'time': '08:40 AM',
      'duration': '22 min',
    },
    {
      'route': 'M-21',
      'from': 'Main Market',
      'to': 'Civil Hospital',
      'date': '10 Oct',
      'time': '02:15 PM',
      'duration': '28 min',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ice,
      body: Stack(
        children: [
          const _FavoritesBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 34),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildHero(),
                  const SizedBox(height: 24),
                  _buildTabs(),
                  const SizedBox(height: 22),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: _selectedTab == 0
                        ? _buildFavoritesSection()
                        : _buildRecentTripsSection(),
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
                'MY TRIPS',
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.0,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Favorites and recent journeys',
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
            Icons.bookmark_rounded,
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
          colors: [navy, navySoft, Color(0xFF15516A)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22071B2C),
            blurRadius: 20,
            offset: Offset(0, 9),
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
              Icons.history_rounded,
              color: navy,
              size: 31,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your journeys in one place',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Quickly revisit saved routes or repeat a recent trip.',
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
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: lightBorder),
      ),
      child: Row(
        children: [
          Expanded(
            child: _tabButton(
              label: 'Favorites',
              icon: Icons.star_rounded,
              index: 0,
            ),
          ),
          Expanded(
            child: _tabButton(
              label: 'Recent Trips',
              icon: Icons.history_rounded,
              index: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabButton({
    required String label,
    required IconData icon,
    required int index,
  }) {
    final selected = _selectedTab == index;

    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 190),
        padding: const EdgeInsets.symmetric(vertical: 13),
        decoration: BoxDecoration(
          color: selected ? navy : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? cyan : textMuted,
              size: 19,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                color: selected ? Colors.white : textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFavoritesSection() {
    return Column(
      key: const ValueKey('favorites'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          'Favorite Routes',
          '${_favorites.length} saved routes',
        ),
        const SizedBox(height: 14),
        ...List.generate(
          _favorites.length,
              (index) => Padding(
            padding: EdgeInsets.only(
              bottom: index == _favorites.length - 1 ? 0 : 12,
            ),
            child: _favoriteCard(_favorites[index]),
          ),
        ),
      ],
    );
  }

  Widget _favoriteCard(Map<String, dynamic> trip) {
    final Color accent = trip['color'] as Color;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(21),
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
                  borderRadius: BorderRadius.circular(16),
                  color: accent.withOpacity(0.12),
                ),
                child: Center(
                  child: Text(
                    trip['route'] as String,
                    style: TextStyle(
                      color: accent,
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
                      '${trip['from']} → ${trip['to']}',
                      style: const TextStyle(
                        color: textDark,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${trip['time']} • ${trip['fare']}',
                      style: const TextStyle(
                        color: textMuted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _favorites.remove(trip);
                  });
                },
                icon: const Icon(
                  Icons.star_rounded,
                  color: warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: softCyan,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.schedule_rounded,
                      color: teal,
                      size: 15,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      'Next in ${trip['next']}',
                      style: const TextStyle(
                        color: teal,
                        fontSize: 10.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Opening route ${trip['route']} will be connected later.',
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.arrow_forward_rounded,
                  size: 18,
                ),
                label: const Text('View Route'),
                style: TextButton.styleFrom(
                  foregroundColor: navy,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTripsSection() {
    return Column(
      key: const ValueKey('recent'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          'Recent Trips',
          'Your latest completed journeys',
        ),
        const SizedBox(height: 14),
        ...List.generate(
          _recentTrips.length,
              (index) => Padding(
            padding: EdgeInsets.only(
              bottom: index == _recentTrips.length - 1 ? 0 : 12,
            ),
            child: _recentTripCard(_recentTrips[index]),
          ),
        ),
      ],
    );
  }

  Widget _recentTripCard(Map<String, String> trip) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: lightBorder),
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
                  Icons.history_rounded,
                  color: teal,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${trip['from']} → ${trip['to']}',
                      style: const TextStyle(
                        color: textDark,
                        fontSize: 13.2,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${trip['date']} • ${trip['time']}',
                      style: const TextStyle(
                        color: textMuted,
                        fontSize: 10.8,
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
                  color: const Color(0xFFF3F7F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  trip['route']!,
                  style: const TextStyle(
                    color: navy,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.schedule_rounded,
                    size: 16,
                    color: textMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    trip['duration']!,
                    style: const TextStyle(
                      color: textMuted,
                      fontSize: 10.8,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Repeat Trip will open Trip Planner later.',
                      ),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.refresh_rounded,
                  size: 17,
                ),
                label: const Text('Repeat'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: navy,
                  side: const BorderSide(color: lightBorder),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 9,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ],
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
}

class _FavoritesBackground extends StatelessWidget {
  const _FavoritesBackground();

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
