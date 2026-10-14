import 'package:flutter/material.dart';
import 'auth/auth_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const Color navy = Color(0xFF071B2C);
  static const Color teal = Color(0xFF00C7B7);
  static const Color cyan = Color(0xFF21D4FD);
  static const Color ice = Color(0xFFF4FBFD);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color textDark = Color(0xFF12212D);
  static const Color textMuted = Color(0xFF6B7C88);

  final List<_OnboardingItem> _items = const [
    _OnboardingItem(
      title: 'Live Bus Tracking',
      description:
      'See your bus move in real time, follow its position, and know exactly when it will reach you.',
      tag: 'LIVE',
      icon: Icons.directions_bus_filled_rounded,
      accent1: Color(0xFF00C7B7),
      accent2: Color(0xFF21D4FD),
      accent3: Color(0xFF1E90FF),
      stat1Value: '2 min',
      stat1Label: 'Live ETA',
      stat2Value: '1.2 km',
      stat2Label: 'Bus distance',
      routeLabel: 'Central Station  →  City Mall',
    ),
    _OnboardingItem(
      title: 'Smart Route Planning',
      description:
      'Compare useful routes, travel times, stops, and fares so every journey feels clear before you leave.',
      tag: 'SMART ROUTES',
      icon: Icons.alt_route_rounded,
      accent1: Color(0xFF5A67F2),
      accent2: Color(0xFF21D4FD),
      accent3: Color(0xFF00C7B7),
      stat1Value: '3',
      stat1Label: 'Best options',
      stat2Value: '24 min',
      stat2Label: 'Fastest route',
      routeLabel: 'University  →  Railway Station',
    ),
    _OnboardingItem(
      title: 'Instant Support',
      description:
      'Reach support quickly through WhatsApp, helpline, or in-app assistance whenever your trip needs help.',
      tag: '24/7 SUPPORT',
      icon: Icons.support_agent_rounded,
      accent1: Color(0xFFFF8A00),
      accent2: Color(0xFFFF4D6D),
      accent3: Color(0xFFFFC837),
      stat1Value: '< 2 min',
      stat1Label: 'Avg. response',
      stat2Value: '24/7',
      stat2Label: 'Availability',
      routeLabel: 'Fast help, wherever you are',
    ),
  ];

  void _nextPage() {
    if (_currentPage < _items.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 360),
        curve: Curves.easeInOutCubic,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AuthScreen()),
      );
    }
  }

  void _skip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = _items[_currentPage];

    return Scaffold(
      backgroundColor: ice,
      body: Stack(
        children: [
          const _PremiumBackground(),
          SafeArea(
            child: Column(
              children: [
                _buildTopBar(),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _items.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return _buildPage(_items[index]);
                    },
                  ),
                ),
                _buildBottomArea(item),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 8),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: surface,
              border: Border.all(color: const Color(0xFFE2EEF2)),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x18071B2C),
                  blurRadius: 16,
                  offset: Offset(0, 6),
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
                  'MOVIRA',
                  style: TextStyle(
                    color: navy,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Move Smarter. Travel Better.',
                  style: TextStyle(
                    color: textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _skip,
            style: TextButton.styleFrom(
              foregroundColor: navy,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            ),
            child: const Text(
              'Skip',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(_OnboardingItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Expanded(
            flex: 5,
            child: _buildHeroCard(item),
          ),
          const SizedBox(height: 24),
          Text(
            item.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textDark,
              fontSize: 31,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.6,
              height: 1.08,
            ),
          ),
          const SizedBox(height: 11),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              item.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: textMuted,
                fontSize: 15,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  item.stat1Value,
                  item.stat1Label,
                  item.accent1,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  item.stat2Value,
                  item.stat2Label,
                  item.accent2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeroCard(_OnboardingItem item) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFF6FCFE),
          ],
        ),
        border: Border.all(
          color: const Color(0xFFDCEBF0),
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A071B2C),
            blurRadius: 30,
            offset: Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(34),
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _PremiumTransitPainter(
                  color1: item.accent1,
                  color2: item.accent2,
                  color3: item.accent3,
                ),
              ),
            ),
            Positioned(
              top: 18,
              left: 18,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                decoration: BoxDecoration(
                  color: surface,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: const Color(0xFFE1EDF1)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x15071B2C),
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item.accent1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      item.tag,
                      style: const TextStyle(
                        color: navy,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 18,
              right: 18,
              child: Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: navy,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x26071B2C),
                      blurRadius: 14,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.navigation_rounded,
                  color: item.accent2,
                  size: 22,
                ),
              ),
            ),
            Align(
              alignment: const Alignment(0, -0.02),
              child: _buildCentralVisual(item),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
                decoration: BoxDecoration(
                  color: navy.withOpacity(0.94),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x28071B2C),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: item.accent1.withOpacity(0.16),
                      ),
                      child: Icon(
                        Icons.trip_origin_rounded,
                        color: item.accent1,
                        size: 18,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.routeLabel,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_rounded,
                      color: item.accent2,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCentralVisual(_OnboardingItem item) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 190,
          height: 190,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: item.accent1.withOpacity(0.08),
          ),
        ),
        Container(
          width: 152,
          height: 152,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                item.accent1,
                item.accent2,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: item.accent1.withOpacity(0.28),
                blurRadius: 28,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Icon(
            item.icon,
            color: Colors.white,
            size: 76,
          ),
        ),
        Positioned(
          right: 6,
          top: 20,
          child: _miniTransitChip(
            icon: Icons.schedule_rounded,
            label: 'On time',
            color: item.accent1,
          ),
        ),
        Positioned(
          left: 2,
          bottom: 26,
          child: _miniTransitChip(
            icon: Icons.bolt_rounded,
            label: 'Smart',
            color: item.accent2,
          ),
        ),
      ],
    );
  }

  Widget _miniTransitChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE1EDF1)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x17071B2C),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: 15,
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              color: navy,
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String value,
      String label,
      Color color,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2EEF2)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10071B2C),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(
              Icons.insights_rounded,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  label,
                  style: const TextStyle(
                    color: textMuted,
                    fontSize: 11.5,
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

  Widget _buildBottomArea(_OnboardingItem item) {
    final bool isLast = _currentPage == _items.length - 1;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _items.length,
                  (index) {
                final bool active = index == _currentPage;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 28 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: active
                        ? item.accent1
                        : const Color(0xFFC7D8DF),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 17),
          Container(
            width: double.infinity,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [
                  item.accent1,
                  item.accent2,
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: item.accent1.withOpacity(0.28),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: _nextPage,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLast ? 'Continue to MOVIRA' : 'Next',
                        style: const TextStyle(
                          color: navy,
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: navy,
                        size: 23,
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
}

class _OnboardingItem {
  final String title;
  final String description;
  final String tag;
  final IconData icon;
  final Color accent1;
  final Color accent2;
  final Color accent3;
  final String stat1Value;
  final String stat1Label;
  final String stat2Value;
  final String stat2Label;
  final String routeLabel;

  const _OnboardingItem({
    required this.title,
    required this.description,
    required this.tag,
    required this.icon,
    required this.accent1,
    required this.accent2,
    required this.accent3,
    required this.stat1Value,
    required this.stat1Label,
    required this.stat2Value,
    required this.stat2Label,
    required this.routeLabel,
  });
}

class _PremiumBackground extends StatelessWidget {
  const _PremiumBackground();

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
                Color(0xFFF8FDFF),
                Color(0xFFF0FAFD),
                Color(0xFFF7FCFD),
              ],
            ),
          ),
        ),
        Positioned(
          top: -100,
          right: -90,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF21D4FD).withOpacity(0.10),
            ),
          ),
        ),
        Positioned(
          top: 240,
          left: -120,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF00C7B7).withOpacity(0.07),
            ),
          ),
        ),
        Positioned(
          bottom: -140,
          right: -60,
          child: Container(
            width: 320,
            height: 320,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF7B61FF).withOpacity(0.05),
            ),
          ),
        ),
      ],
    );
  }
}

class _PremiumTransitPainter extends CustomPainter {
  final Color color1;
  final Color color2;
  final Color color3;

  _PremiumTransitPainter({
    required this.color1,
    required this.color2,
    required this.color3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = const Color(0xFFE8F0F3)
      ..strokeWidth = 1;

    for (double x = 26; x < size.width; x += 52) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        gridPaint,
      );
    }

    for (double y = 32; y < size.height; y += 52) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    final routePath = Path()
      ..moveTo(-30, size.height * 0.72)
      ..cubicTo(
        size.width * 0.18,
        size.height * 0.50,
        size.width * 0.38,
        size.height * 0.85,
        size.width * 0.58,
        size.height * 0.56,
      )
      ..cubicTo(
        size.width * 0.72,
        size.height * 0.36,
        size.width * 0.86,
        size.height * 0.48,
        size.width + 30,
        size.height * 0.26,
      );

    final roadPaint = Paint()
      ..color = const Color(0xFFE4EEF2)
      ..strokeWidth = 24
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final routePaint = Paint()
      ..shader = LinearGradient(
        colors: [
          color1,
          color2,
          color3,
        ],
      ).createShader(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ),
      )
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(routePath, roadPaint);
    canvas.drawPath(routePath, routePaint);

    final stopPaint = Paint()..color = color1;
    canvas.drawCircle(
      Offset(size.width * 0.18, size.height * 0.68),
      7,
      stopPaint,
    );

    stopPaint.color = color2;
    canvas.drawCircle(
      Offset(size.width * 0.80, size.height * 0.42),
      7,
      stopPaint,
    );
  }

  @override
  bool shouldRepaint(
      covariant _PremiumTransitPainter oldDelegate,
      ) {
    return oldDelegate.color1 != color1 ||
        oldDelegate.color2 != color2 ||
        oldDelegate.color3 != color3;
  }
}
