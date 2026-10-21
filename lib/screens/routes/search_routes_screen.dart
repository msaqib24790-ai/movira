import 'package:flutter/material.dart';
import 'route_results_screen.dart';

class SearchRoutesScreen extends StatefulWidget {
  const SearchRoutesScreen({super.key});

  @override
  State<SearchRoutesScreen> createState() => _SearchRoutesScreenState();
}

class _SearchRoutesScreenState extends State<SearchRoutesScreen> {
  final TextEditingController _fromController =
  TextEditingController(text: 'Current Location');

  final TextEditingController _toController = TextEditingController();

  bool _fastestRoute = true;
  bool _fewerStops = false;
  bool _accessibleRoute = false;

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

  final List<Map<String, dynamic>> _recentSearches = [
    {
      'from': 'Central Station',
      'to': 'City Mall',
      'icon': Icons.shopping_bag_outlined,
    },
    {
      'from': 'University',
      'to': 'Railway Station',
      'icon': Icons.school_outlined,
    },
    {
      'from': 'City Center',
      'to': 'Airport',
      'icon': Icons.flight_outlined,
    },
  ];

  final List<Map<String, dynamic>> _suggestions = [
    {
      'title': 'University',
      'subtitle': 'Popular student destination',
      'icon': Icons.school_rounded,
      'color': const Color(0xFF8B5CF6),
    },
    {
      'title': 'Railway Station',
      'subtitle': 'Main transport hub',
      'icon': Icons.train_rounded,
      'color': cyan,
    },
    {
      'title': 'City Mall',
      'subtitle': 'Shopping & entertainment',
      'icon': Icons.shopping_bag_rounded,
      'color': teal,
    },
    {
      'title': 'Airport',
      'subtitle': 'Airport terminal',
      'icon': Icons.flight_rounded,
      'color': const Color(0xFFF59E0B),
    },
  ];

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _swapLocations() {
    final currentFrom = _fromController.text;

    setState(() {
      _fromController.text = _toController.text;
      _toController.text = currentFrom;
    });
  }

  void _searchRoutes() {
    final from = _fromController.text.trim();
    final to = _toController.text.trim();

    if (from.isEmpty || to.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter both starting point and destination.',
          ),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RouteResultsScreen(
          from: from,
          to: to,
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
          const _RoutesBackground(),

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

                  const SizedBox(height: 28),

                  const Text(
                    'Find your best route',
                    style: TextStyle(
                      color: textDark,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.4,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Choose where you are and where you want to go.',
                    style: TextStyle(
                      color: textMuted,
                      fontSize: 14,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 28),

                  _buildRouteSearchCard(),

                  const SizedBox(height: 30),

                  _buildSectionHeader(
                    title: 'Route Preferences',
                    subtitle: 'Customize how MOVIRA finds your journey',
                  ),

                  const SizedBox(height: 16),

                  _buildPreferencesCard(),

                  const SizedBox(height: 30),

                  _buildSectionHeader(
                    title: 'Recent Searches',
                    subtitle: 'Quickly repeat a previous journey',
                    action: 'Clear',
                  ),

                  const SizedBox(height: 14),

                  _buildRecentSearches(),

                  const SizedBox(height: 30),

                  _buildSectionHeader(
                    title: 'Popular Destinations',
                    subtitle: 'Frequently searched places',
                  ),

                  const SizedBox(height: 14),

                  _buildSuggestions(),
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
                'SEARCH ROUTES',
                style: TextStyle(
                  color: navy,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Move Smarter. Travel Better.',
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

  Widget _buildRouteSearchCard() {
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
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildLocationField(
            controller: _fromController,
            label: 'From',
            hint: 'Enter starting location',
            icon: Icons.trip_origin_rounded,
            iconColor: teal,
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.white.withOpacity(0.12),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _swapLocations,
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
                        color: Color(0x3300C7B7),
                        blurRadius: 14,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.swap_vert_rounded,
                    color: navy,
                    size: 25,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  height: 1,
                  color: Colors.white.withOpacity(0.12),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _buildLocationField(
            controller: _toController,
            label: 'To',
            hint: 'Enter destination',
            icon: Icons.location_on_rounded,
            iconColor: cyan,
          ),

          const SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            height: 58,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [teal, cyan],
                ),
                borderRadius: BorderRadius.circular(19),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x4200C7B7),
                    blurRadius: 20,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(19),
                  onTap: _searchRoutes,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_rounded,
                        color: navy,
                      ),
                      SizedBox(width: 9),
                      Text(
                        'Search Routes',
                        style: TextStyle(
                          color: navy,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
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

  Widget _buildLocationField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: Colors.white.withOpacity(0.12),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.14),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 21,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                labelText: label,
                hintText: hint,
                labelStyle: const TextStyle(
                  color: Color(0xFFB8D8E8),
                  fontSize: 12,
                ),
                hintStyle: const TextStyle(
                  color: Color(0xFF8FAAB7),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.my_location_rounded,
              color: cyan,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreferencesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
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
          _preferenceTile(
            icon: Icons.bolt_rounded,
            title: 'Fastest Route',
            subtitle: 'Prioritize shortest travel time',
            value: _fastestRoute,
            onChanged: (value) {
              setState(() {
                _fastestRoute = value;
              });
            },
            color: cyan,
          ),

          const Divider(
            height: 24,
            color: Color(0xFFE8EEF1),
          ),

          _preferenceTile(
            icon: Icons.linear_scale_rounded,
            title: 'Fewer Stops',
            subtitle: 'Prefer routes with fewer stops',
            value: _fewerStops,
            onChanged: (value) {
              setState(() {
                _fewerStops = value;
              });
            },
            color: teal,
          ),

          const Divider(
            height: 24,
            color: Color(0xFFE8EEF1),
          ),

          _preferenceTile(
            icon: Icons.accessible_rounded,
            title: 'Accessible Route',
            subtitle: 'Show accessible transport options',
            value: _accessibleRoute,
            onChanged: (value) {
              setState(() {
                _accessibleRoute = value;
              });
            },
            color: const Color(0xFF8B5CF6),
          ),
        ],
      ),
    );
  }

  Widget _preferenceTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: color,
            size: 22,
          ),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: textDark,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: navy,
          activeTrackColor: cyan,
          inactiveThumbColor: const Color(0xFFB3C2C9),
          inactiveTrackColor: const Color(0xFFE1EAEE),
        ),
      ],
    );
  }

  Widget _buildRecentSearches() {
    return Column(
      children: _recentSearches.map((search) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 11),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _fromController.text = search['from'];
                _toController.text = search['to'];
              });
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(19),
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
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: softCyan,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      search['icon'],
                      color: teal,
                      size: 21,
                    ),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${search['from']} → ${search['to']}',
                          style: const TextStyle(
                            color: textDark,
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Tap to search again',
                          style: TextStyle(
                            color: textMuted,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.north_east_rounded,
                    color: teal,
                    size: 19,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSuggestions() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _suggestions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.18,
      ),
      itemBuilder: (context, index) {
        final item = _suggestions[index];
        final Color color = item['color'];

        return GestureDetector(
          onTap: () {
            setState(() {
              _toController.text = item['title'];
            });
          },
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: white,
              borderRadius: BorderRadius.circular(21),
              border: Border.all(
                color: color.withOpacity(0.18),
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0F071B2C),
                  blurRadius: 12,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.13),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    item['icon'],
                    color: color,
                    size: 22,
                  ),
                ),
                const Spacer(),
                Text(
                  item['title'],
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  item['subtitle'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: textMuted,
                    fontSize: 10.2,
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader({
    required String title,
    required String subtitle,
    String? action,
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
            onPressed: () {},
            child: Text(
              action,
              style: const TextStyle(
                color: teal,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
      ],
    );
  }
}

class _RoutesBackground extends StatelessWidget {
  const _RoutesBackground();

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
          left: -90,
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