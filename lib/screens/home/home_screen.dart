import 'package:flutter/material.dart';
import '../routes/search_routes_screen.dart';
import '../stops/nearby_stops_screen.dart';
import '../schedules/schedules_screen.dart';
import '../trips/trip_planner_screen.dart';
import '../trips/favorites_recent_trips_screen.dart';
import '../alerts/service_alerts_notifications_screen.dart';
import '../support center/support_center_screen.dart';
import '../tracking/live_bus_tracking_screen.dart';
import '../profile/profile_travel_preferences_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

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

  void _openSearchRoutes() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SearchRoutesScreen(),
      ),
    );
  }

  void _openNearbyStops() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NearbyStopsScreen(),
      ),
    );
  }

  void _openSchedules() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SchedulesScreen(),
      ),
    );
  }

  void _openTripPlanner() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TripPlannerScreen(),
      ),
    );
  }

  void _openFavoritesRecentTrips() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const FavoritesRecentTripsScreen(),
      ),
    );
  }

  void _openServiceAlerts() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ServiceAlertsNotificationsScreen(),
      ),
    );
  }

  void _openSupportCenter() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SupportCenterScreen(),
      ),
    );
  }

  void _openLiveTracking() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const LiveBusTrackingScreen(),
      ),
    );
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfileTravelPreferencesScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ice,
      body: Stack(
        children: [
          const _HomeBackground(),

          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      18,
                      20,
                      180,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTopHeader(),

                        const SizedBox(height: 26),

                        _buildLocationCard(),

                        const SizedBox(height: 22),

                        _buildSearchCard(),

                        const SizedBox(height: 28),

                        _sectionHeader(
                          title: 'Quick Actions',
                          subtitle: 'Everything you need for your journey',
                        ),

                        const SizedBox(height: 16),

                        _buildQuickActions(),

                        const SizedBox(height: 18),

                        _buildTripPlannerCard(),

                        const SizedBox(height: 30),

                        _sectionHeader(
                          title: 'Live Journey',
                          subtitle: 'Your active bus at a glance',
                        ),

                        const SizedBox(height: 16),

                        _buildLiveJourneyCard(),

                        const SizedBox(height: 30),

                        _sectionHeader(
                          title: 'Favorite Routes',
                          subtitle: 'Your most-used routes',
                          action: 'View All',
                          onActionTap: _openFavoritesRecentTrips,
                        ),

                        const SizedBox(height: 16),

                        _buildFavoriteRoutes(),

                        const SizedBox(height: 30),

                        _sectionHeader(
                          title: 'Service Alerts',
                          subtitle: 'Important updates around you',
                          action: 'See All',
                          onActionTap: _openServiceAlerts,
                        ),

                        const SizedBox(height: 16),

                        _buildServiceAlert(),

                        const SizedBox(height: 30),

                        _sectionHeader(
                          title: 'Recent Trip',
                          subtitle: 'Continue where you left off',
                        ),

                        const SizedBox(height: 16),

                        _buildRecentTrip(),

                        const SizedBox(height: 24),

                        _buildSupportCenterCard(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildTopHeader() {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: lightBorder),
            boxShadow: const [
              BoxShadow(
                color: Color(0x16071B2C),
                blurRadius: 14,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              'assets/branding/movira_icon.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good evening',
                style: TextStyle(
                  color: textMuted,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 3),
              Text(
                'Welcome to MOVIRA',
                style: TextStyle(
                  color: textDark,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        _roundIconButton(
          icon: Icons.notifications_none_rounded,
          onTap: _openServiceAlerts,
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: _openProfile,
          child: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [teal, cyan],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x2600C7B7),
                  blurRadius: 14,
                  offset: Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.person_rounded,
              color: navy,
              size: 25,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0C3247),
            Color(0xFF0B2235),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.08),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: cyan.withOpacity(0.13),
            ),
            child: const Icon(
              Icons.my_location_rounded,
              color: cyan,
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
                    color: softText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Detecting your location',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
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
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard() {
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
            color: Color(0x3800C7B7),
            blurRadius: 28,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.alt_route_rounded,
                color: navy,
                size: 25,
              ),
              SizedBox(width: 10),
              Text(
                'Where are you going?',
                style: TextStyle(
                  color: navy,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          GestureDetector(
            onTap: _openSearchRoutes,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color: navy.withOpacity(0.92),
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Row(
                children: [
                  Icon(
                    Icons.search_rounded,
                    color: cyan,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Search destination or route',
                      style: TextStyle(
                        color: Color(0xFF8DAAB9),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.mic_none_rounded,
                    color: Colors.white,
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 14,
      mainAxisSpacing: 14,
      childAspectRatio: 1.28,
      children: [
        _AdvancedQuickActionCard(
          icon: Icons.alt_route_rounded,
          title: 'Search Routes',
          accent: cyan,
          secondaryAccent: const Color(0xFF7DE8FF),
          onTap: _openSearchRoutes,
        ),
        _AdvancedQuickActionCard(
          icon: Icons.directions_bus_filled_rounded,
          title: 'Live Tracking',
          accent: teal,
          secondaryAccent: const Color(0xFF6FFFE8),
          onTap: _openLiveTracking,
        ),
        _AdvancedQuickActionCard(
          icon: Icons.location_on_rounded,
          title: 'Nearby Stops',
          accent: const Color(0xFF8B5CF6),
          secondaryAccent: const Color(0xFFC4B5FD),
          onTap: _openNearbyStops,
        ),
        _AdvancedQuickActionCard(
          icon: Icons.schedule_rounded,
          title: 'Schedules',
          accent: const Color(0xFFF59E0B),
          secondaryAccent: const Color(0xFFFCD34D),
          onTap: _openSchedules,
        ),
      ],
    );
  }

  Widget _buildTripPlannerCard() {
    return GestureDetector(
      onTap: _openTripPlanner,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0C3247),
              Color(0xFF123F55),
            ],
          ),
          border: Border.all(
            color: cyan.withOpacity(0.16),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x18071B2C),
              blurRadius: 16,
              offset: Offset(0, 7),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(17),
                gradient: const LinearGradient(
                  colors: [teal, cyan],
                ),
              ),
              child: const Icon(
                Icons.alt_route_rounded,
                color: navy,
                size: 27,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trip Planner',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Plan a complete journey with time, fare and route preferences.',
                    style: TextStyle(
                      color: softText,
                      fontSize: 10.8,
                      height: 1.35,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            const Icon(
              Icons.arrow_forward_rounded,
              color: cyan,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveJourneyCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: navySoft,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: teal.withOpacity(0.22),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: teal.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(20),
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
                      'LIVE',
                      style: TextStyle(
                        color: teal,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              const Text(
                'Bus M-12',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              _journeyPoint(
                icon: Icons.trip_origin_rounded,
                label: 'From',
                value: 'Central Station',
                color: teal,
              ),

              Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 2,
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            teal,
                            cyan,
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 7),
                    const Text(
                      '18 min',
                      style: TextStyle(
                        color: softText,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

              _journeyPoint(
                icon: Icons.location_on_rounded,
                label: 'To',
                value: 'City Mall',
                color: cyan,
                alignRight: true,
              ),
            ],
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              _statChip(
                icon: Icons.directions_bus_outlined,
                text: '2 stops away',
              ),
              const SizedBox(width: 10),
              _statChip(
                icon: Icons.speed_rounded,
                text: 'On time',
              ),
              const Spacer(),
              GestureDetector(
                onTap: _openLiveTracking,
                child: const Row(
                  children: [
                    Text(
                      'Track',
                      style: TextStyle(
                        color: cyan,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: cyan,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ],
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
    bool alignRight = false,
  }) {
    return Expanded(
      flex: 2,
      child: Column(
        crossAxisAlignment:
        alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 19,
          ),
          const SizedBox(height: 7),
          Text(
            label,
            style: const TextStyle(
              color: softText,
              fontSize: 10.5,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            textAlign: alignRight ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip({
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: softText,
            size: 15,
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: softText,
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteRoutes() {
    return Column(
      children: [
        _favoriteRouteTile(
          number: 'M-03',
          from: 'Railway Station',
          to: 'University',
          time: '22 min',
        ),
        const SizedBox(height: 12),
        _favoriteRouteTile(
          number: 'M-08',
          from: 'City Center',
          to: 'Airport',
          time: '31 min',
        ),
      ],
    );
  }

  Widget _favoriteRouteTile({
    required String number,
    required String from,
    required String to,
    required String time,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: lightBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F071B2C),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: const LinearGradient(
                colors: [teal, cyan],
              ),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: navy,
                  fontSize: 13,
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
                  '$from → $to',
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  time,
                  style: const TextStyle(
                    color: textMuted,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.star_rounded,
            color: Color(0xFFFBBF24),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceAlert() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7E8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFFF59E0B).withOpacity(0.24),
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFF59E0B),
            size: 24,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Route M-05 delayed',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Expect approximately 10 minutes delay due to road congestion.',
                  style: TextStyle(
                    color: Color(0xFF8A5A12),
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

  Widget _buildRecentTrip() {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: lightBorder),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F071B2C),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
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
            child: const Icon(
              Icons.history_rounded,
              color: teal,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Central Station → City Mall',
                  style: TextStyle(
                    color: textDark,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Yesterday • Bus M-12',
                  style: TextStyle(
                    color: textMuted,
                    fontSize: 11.5,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _openFavoritesRecentTrips,
            icon: const Icon(
              Icons.refresh_rounded,
              color: teal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportCenterCard() {
    return GestureDetector(
      onTap: _openSupportCenter,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(17),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0C3247),
              Color(0xFF123F55),
            ],
          ),
          border: Border.all(
            color: cyan.withOpacity(0.16),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [teal, cyan],
                ),
              ),
              child: const Icon(
                Icons.support_agent_rounded,
                color: navy,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Support Center',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Helpline, WhatsApp, live chat and support tickets.',
                    style: TextStyle(
                      color: softText,
                      fontSize: 10.8,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_rounded,
              color: cyan,
              size: 21,
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader({
    required String title,
    required String subtitle,
    String? action,
    VoidCallback? onActionTap,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
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
          ),
        ),
        if (action != null)
          TextButton(
            onPressed: onActionTap,
            child: Text(
              action,
              style: const TextStyle(
                color: teal,
                fontWeight: FontWeight.w900,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  Widget _roundIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: white,
          border: Border.all(color: lightBorder),
          boxShadow: const [
            BoxShadow(
              color: Color(0x10071B2C),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: navy,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    final items = [
      const _NavItem(
        icon: Icons.home_rounded,
        label: 'Home',
      ),
      const _NavItem(
        icon: Icons.alt_route_rounded,
        label: 'Routes',
      ),
      const _NavItem(
        icon: Icons.directions_bus_filled_rounded,
        label: 'Track',
      ),
      const _NavItem(
        icon: Icons.notifications_rounded,
        label: 'Alerts',
      ),
      const _NavItem(
        icon: Icons.person_rounded,
        label: 'Profile',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF071B2C),
        border: Border(
          top: BorderSide(
            color: Colors.white.withOpacity(0.06),
          ),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66000000),
            blurRadius: 24,
            offset: Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 76,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              items.length,
                  (index) {
                final selected = _selectedIndex == index;
                final item = items[index];

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      if (index == 1) {
                        _openSearchRoutes();
                        return;
                      }

                      if (index == 2) {
                        _openLiveTracking();
                        return;
                      }

                      if (index == 3) {
                        _openServiceAlerts();
                        return;
                      }

                      if (index == 4) {
                        _openProfile();
                        return;
                      }

                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: selected
                                ? cyan.withOpacity(0.13)
                                : Colors.transparent,
                          ),
                          child: Icon(
                            item.icon,
                            color: selected
                                ? cyan
                                : const Color(0xFF7794A3),
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item.label,
                          style: TextStyle(
                            color: selected
                                ? cyan
                                : const Color(0xFF7794A3),
                            fontSize: 10,
                            fontWeight:
                            selected ? FontWeight.w900 : FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.label,
  });
}

class _HomeBackground extends StatelessWidget {
  const _HomeBackground();

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
              color: const Color(0xFF21D4FD).withOpacity(0.09),
            ),
          ),
        ),

        Positioned(
          bottom: 100,
          left: -120,
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

class _AdvancedQuickActionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color accent;
  final Color secondaryAccent;
  final VoidCallback onTap;

  const _AdvancedQuickActionCard({
    required this.icon,
    required this.title,
    required this.accent,
    required this.secondaryAccent,
    required this.onTap,
  });

  @override
  State<_AdvancedQuickActionCard> createState() =>
      _AdvancedQuickActionCardState();
}

class _AdvancedQuickActionCardState extends State<_AdvancedQuickActionCard> {
  bool _pressed = false;
  bool _hovered = false;

  void _setPressed(bool value) {
    if (_pressed != value) {
      setState(() => _pressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final active = _pressed || _hovered;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _pressed ? 0.965 : (_hovered ? 1.025 : 1.0),
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: active
                  ? [
                widget.accent.withOpacity(0.20),
                const Color(0xFFFFFFFF),
                widget.secondaryAccent.withOpacity(0.16),
              ]
                  : [
                const Color(0xFFFFFFFF),
                const Color(0xFFF7FCFD),
              ],
            ),
            border: Border.all(
              color: active
                  ? widget.accent.withOpacity(0.55)
                  : widget.accent.withOpacity(0.18),
              width: active ? 1.5 : 1.0,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.accent.withOpacity(active ? 0.24 : 0.13),
                blurRadius: active ? 24 : 18,
                spreadRadius: active ? 1 : 0,
                offset: Offset(0, active ? 10 : 8),
              ),
              const BoxShadow(
                color: Color(0x0A071B2C),
                blurRadius: 7,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              splashColor: widget.accent.withOpacity(0.10),
              highlightColor: Colors.transparent,
              onTap: widget.onTap,
              onTapDown: (_) => _setPressed(true),
              onTapCancel: () => _setPressed(false),
              onTapUp: (_) => _setPressed(false),
              child: Stack(
                children: [
                  Positioned(
                    top: -24,
                    right: -20,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      width: active ? 92 : 82,
                      height: active ? 92 : 82,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: widget.accent.withOpacity(
                          active ? 0.12 : 0.07,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    widget.accent,
                                    widget.secondaryAccent,
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: widget.accent.withOpacity(0.30),
                                    blurRadius: 12,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Icon(
                                widget.icon,
                                color: const Color(0xFF071B2C),
                                size: 27,
                                weight: 700,
                              ),
                            ),
                            const Spacer(),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: active
                                    ? widget.accent.withOpacity(0.16)
                                    : const Color(0xFFF1F7F9),
                              ),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: active
                                    ? widget.accent
                                    : const Color(0xFF6B7C88),
                                size: 17,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Text(
                          widget.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF12212D),
                            fontSize: 14.2,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.15,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Container(
                          width: 34,
                          height: 3,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: LinearGradient(
                              colors: [
                                widget.accent,
                                widget.secondaryAccent,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

