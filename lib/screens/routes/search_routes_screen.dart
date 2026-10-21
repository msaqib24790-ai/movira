
import 'package:flutter/material.dart';

import '../../services/gtfs_service.dart';
import 'route_results_screen.dart';

class SearchRoutesScreen extends StatefulWidget {
  const SearchRoutesScreen({super.key});

  @override
  State<SearchRoutesScreen> createState() => _SearchRoutesScreenState();
}

class _SearchRoutesScreenState extends State<SearchRoutesScreen> {
  static const Color navy = Color(0xFF071B2C);
  static const Color teal = Color(0xFF00C7B7);
  static const Color cyan = Color(0xFF21D4FD);
  static const Color ice = Color(0xFFF4FBFD);
  static const Color textDark = Color(0xFF12212D);
  static const Color textMuted = Color(0xFF6B7C88);
  static const Color borderColor = Color(0xFFE1EDF1);

  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  List<Map<String, String>> _fromSuggestions = [];
  List<Map<String, String>> _toSuggestions = [];

  bool _showFromSuggestions = false;
  bool _showToSuggestions = false;
  bool _fastestRoute = true;
  bool _fewerStops = false;
  bool _accessibleRoute = false;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _updateSuggestions(String query, bool isOrigin) {
    final results = query.trim().isEmpty
        ? <Map<String, String>>[]
        : GtfsService.instance.searchStops(query, limit: 8);

    setState(() {
      if (isOrigin) {
        _fromSuggestions = results;
        _showFromSuggestions = results.isNotEmpty;
      } else {
        _toSuggestions = results;
        _showToSuggestions = results.isNotEmpty;
      }
    });
  }

  void _selectStop(Map<String, String> stop, bool isOrigin) {
    final name = stop['stop_name'] ?? '';

    setState(() {
      if (isOrigin) {
        _fromController.text = name;
        _showFromSuggestions = false;
        _fromSuggestions = [];
      } else {
        _toController.text = name;
        _showToSuggestions = false;
        _toSuggestions = [];
      }
    });
  }

  void _swapLocations() {
    setState(() {
      final previousFrom = _fromController.text;
      _fromController.text = _toController.text;
      _toController.text = previousFrom;
      _showFromSuggestions = false;
      _showToSuggestions = false;
    });
  }

  void _searchRoutes() {
    final from = _fromController.text.trim();
    final to = _toController.text.trim();

    if (from.isEmpty || to.isEmpty) {
      _showMessage('Please enter both your starting point and destination.');
      return;
    }

    if (from.toLowerCase() == to.toLowerCase()) {
      _showMessage('Your starting point and destination must be different.');
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RouteResultsScreen(from: from, to: to),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: navy,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ice,
      body: Stack(
        children: [
          const _SearchBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  const Text(
                    'Where would you like to go?',
                    style: TextStyle(
                      color: textDark,
                      fontSize: 28,
                      height: 1.2,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 9),
                  const Text(
                    'Search stops in the available transit dataset '
                        'to find matching bus routes.',
                    style: TextStyle(
                      color: textMuted,
                      fontSize: 14,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 25),
                  _buildJourneyCard(),
                  const SizedBox(height: 25),
                  _buildPreferences(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: _searchRoutes,
                      icon: const Icon(Icons.search_rounded),
                      label: const Text(
                        'Search bus routes',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: navy,
                        foregroundColor: cyan,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(17),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: borderColor),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: teal,
                          size: 21,
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Routes are matched against the available '
                                'GTFS dataset. Automatic current-location '
                                'detection, connecting journeys, live tracking, '
                                'fares, and journey-time estimates are not '
                                'provided by this search yet.',
                            style: TextStyle(
                              color: textMuted,
                              fontSize: 12,
                              height: 1.5,
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
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _iconButton(
          icon: Icons.arrow_back_rounded,
          onTap: () => Navigator.pop(context),
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
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'BUS ROUTE PLANNER',
                style: TextStyle(
                  color: textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: const Color(0xFFDDFBFA),
            borderRadius: BorderRadius.circular(15),
          ),
          child: const Icon(
            Icons.alt_route_rounded,
            color: teal,
          ),
        ),
      ],
    );
  }

  Widget _iconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor),
          ),
          child: Icon(icon, color: navy),
        ),
      ),
    );
  }

  Widget _buildJourneyCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10071B2C),
            blurRadius: 18,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildLocationField(
            label: 'FROM',
            hint: 'Enter starting stop',
            controller: _fromController,
            icon: Icons.trip_origin_rounded,
            isOrigin: true,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 13),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 2,
                height: 25,
                color: borderColor,
              ),
            ),
          ),
          _buildLocationField(
            label: 'TO',
            hint: 'Enter destination stop',
            controller: _toController,
            icon: Icons.location_on_rounded,
            isOrigin: false,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _swapLocations,
              icon: const Icon(Icons.swap_vert_rounded, size: 20),
              label: const Text('Swap locations'),
              style: TextButton.styleFrom(
                foregroundColor: teal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required IconData icon,
    required bool isOrigin,
  }) {
    final suggestions =
    isOrigin ? _fromSuggestions : _toSuggestions;
    final showSuggestions =
    isOrigin ? _showFromSuggestions : _showToSuggestions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: teal, size: 19),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: textMuted,
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          onChanged: (value) => _updateSuggestions(value, isOrigin),
          onTap: () {
            if (controller.text.isNotEmpty) {
              _updateSuggestions(controller.text, isOrigin);
            }
          },
          style: const TextStyle(
            color: textDark,
            fontSize: 15,
            fontWeight: FontWeight.w700,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF91A0AA),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: const Color(0xFFF7FBFC),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: const BorderSide(color: teal, width: 1.5),
            ),
          ),
        ),
        if (showSuggestions && suggestions.isNotEmpty) ...[
          const SizedBox(height: 7),
          Container(
            constraints: const BoxConstraints(maxHeight: 220),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: borderColor),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: suggestions.length,
              separatorBuilder: (_, __) =>
              const Divider(height: 1, color: borderColor),
              itemBuilder: (context, index) {
                final stop = suggestions[index];
                final name = stop['stop_name'] ?? 'Unnamed stop';

                return ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.location_on_outlined,
                    color: teal,
                    size: 20,
                  ),
                  title: Text(
                    name,
                    style: const TextStyle(
                      color: textDark,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () => _selectStop(stop, isOrigin),
                );
              },
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPreferences() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Route preferences',
            style: TextStyle(
              color: textDark,
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Preferences are saved on this screen only; '
                'they do not yet change route calculations.',
            style: TextStyle(
              color: textMuted,
              fontSize: 11,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          _preferenceTile(
            title: 'Fastest route',
            subtitle: 'Prioritize journey speed',
            icon: Icons.bolt_rounded,
            value: _fastestRoute,
            onChanged: (value) => setState(() {
              _fastestRoute = value;
              if (value) _fewerStops = false;
            }),
          ),
          _preferenceTile(
            title: 'Fewer stops',
            subtitle: 'Prefer routes with fewer stops',
            icon: Icons.route_rounded,
            value: _fewerStops,
            onChanged: (value) => setState(() {
              _fewerStops = value;
              if (value) _fastestRoute = false;
            }),
          ),
          _preferenceTile(
            title: 'Accessibility',
            subtitle: 'Prefer accessible travel options',
            icon: Icons.accessible_rounded,
            value: _accessibleRoute,
            onChanged: (value) {
              setState(() => _accessibleRoute = value);
            },
          ),
        ],
      ),
    );
  }

  Widget _preferenceTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return CheckboxListTile(
      value: value,
      onChanged: (checked) => onChanged(checked ?? false),
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.trailing,
      activeColor: teal,
      secondary: Icon(icon, color: teal, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          color: textDark,
          fontSize: 13,
          fontWeight: FontWeight.w800,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          color: textMuted,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _SearchBackground extends StatelessWidget {
  const _SearchBackground();

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
