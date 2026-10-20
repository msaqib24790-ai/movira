
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/saved_trip_service.dart';

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

  int _selectedTab = 0;
  int _loadRequestId = 0;

  String? _currentUserId;
  String? _errorMessage;

  bool _isLoading = false;

  final List<Map<String, dynamic>> _savedTrips = [];
  final Set<String> _removingTripIds = {};

  StreamSubscription<User?>? _authSubscription;

  @override
  void initState() {
    super.initState();

    final currentUser = FirebaseAuth.instance.currentUser;
    _currentUserId = currentUser?.uid;

    if (currentUser != null) {
      _loadSavedTrips();
    }

    _authSubscription =
        FirebaseAuth.instance.authStateChanges().listen(
              (user) {
            if (!mounted || user?.uid == _currentUserId) {
              return;
            }

            _currentUserId = user?.uid;
            _loadRequestId++;

            if (user == null) {
              setState(() {
                _savedTrips.clear();
                _removingTripIds.clear();
                _errorMessage = null;
                _isLoading = false;
              });
            } else {
              _loadSavedTrips();
            }
          },
        );
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  // ------------------------------------------------------------
  // LOAD SAVED TRIPS FROM FIRESTORE
  // ------------------------------------------------------------

  Future<void> _loadSavedTrips() async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      if (!mounted) return;

      _loadRequestId++;

      setState(() {
        _savedTrips.clear();
        _errorMessage = null;
        _isLoading = false;
      });

      return;
    }

    final requestId = ++_loadRequestId;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // SavedTripService methods are static.
      final dynamic result = await SavedTripService.getSavedTrips();

      if (!mounted ||
          requestId != _loadRequestId ||
          FirebaseAuth.instance.currentUser?.uid != userId) {
        return;
      }

      final trips = _normaliseTrips(result);

      trips.sort((a, b) {
        final dateA = _readDate(
          a['createdAt'] ?? a['updatedAt'],
        );

        final dateB = _readDate(
          b['createdAt'] ?? b['updatedAt'],
        );

        if (dateA == null && dateB == null) return 0;
        if (dateA == null) return 1;
        if (dateB == null) return -1;

        return dateB.compareTo(dateA);
      });

      setState(() {
        _savedTrips
          ..clear()
          ..addAll(trips);

        _isLoading = false;
        _errorMessage = null;
      });
    } catch (error) {
      if (!mounted ||
          requestId != _loadRequestId ||
          FirebaseAuth.instance.currentUser?.uid != userId) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage =
        'Could not load saved trips. Please check your connection and try again.';
      });
    }
  }

  // Supports the expected list of maps and document-style results.
  List<Map<String, dynamic>> _normaliseTrips(dynamic result) {
    Iterable<dynamic>? items;

    if (result is Iterable) {
      items = result;
    } else if (result != null) {
      try {
        final dynamic docs = (result as dynamic).docs;

        if (docs is Iterable) {
          items = docs;
        }
      } catch (_) {
        items = null;
      }
    }

    if (items == null) {
      return [];
    }

    final trips = <Map<String, dynamic>>[];

    for (final item in items) {
      try {
        Map<String, dynamic>? trip;

        if (item is Map) {
          trip = Map<String, dynamic>.from(item);
        } else {
          final dynamic data = (item as dynamic).data();

          if (data is Map) {
            trip = Map<String, dynamic>.from(data);

            final dynamic documentId = (item as dynamic).id;

            trip['tripId'] ??= documentId?.toString();
          }
        }

        if (trip == null) {
          continue;
        }

        final tripId = (
            trip['tripId'] ??
                trip['id'] ??
                trip['documentId'] ??
                ''
        ).toString();

        trip['tripId'] = tripId;

        trips.add(trip);
      } catch (_) {
        // Ignore malformed individual records without crashing the screen.
      }
    }

    return trips;
  }

  // ------------------------------------------------------------
  // DATE HELPERS
  // ------------------------------------------------------------

  DateTime? _readDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is int) {
      try {
        final milliseconds = value > 9999999999
            ? value
            : value * 1000;

        return DateTime.fromMillisecondsSinceEpoch(milliseconds);
      } catch (_) {
        return null;
      }
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  String _formatSavedDate(dynamic value) {
    final date = _readDate(value);

    if (date == null) {
      return 'Date unavailable';
    }

    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  // ------------------------------------------------------------
  // REMOVE A SAVED TRIP
  // ------------------------------------------------------------

  Future<void> _removeSavedTrip(
      Map<String, dynamic> trip,
      ) async {
    final tripId = (
        trip['tripId'] ??
            trip['id'] ??
            ''
    ).toString();

    if (tripId.isEmpty) {
      _showMessage(
        'This trip cannot be removed because its ID is missing.',
      );
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: const Text(
            'Remove saved trip?',
            style: TextStyle(
              color: textDark,
              fontWeight: FontWeight.w900,
            ),
          ),
          content: const Text(
            'This trip will be removed from your saved trips.',
            style: TextStyle(
              color: textMuted,
              height: 1.5,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: white,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !mounted) {
      return;
    }

    setState(() {
      _removingTripIds.add(tripId);
    });

    try {
      // Correct static method access.
      await SavedTripService.removeSavedTrip(
        tripId: tripId,
      );

      if (!mounted) return;

      setState(() {
        _savedTrips.removeWhere(
              (savedTrip) =>
          (savedTrip['tripId'] ?? savedTrip['id'] ?? '')
              .toString() ==
              tripId,
        );
      });

      _showMessage('Saved trip removed.');
    } catch (error) {
      if (!mounted) return;

      _showMessage(
        'Could not remove this trip. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          _removingTripIds.remove(tripId);
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  // ------------------------------------------------------------
  // MAIN SCREEN
  // ------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ice,
      body: Stack(
        children: [
          const _FavoritesBackground(),
          SafeArea(
            child: RefreshIndicator(
              color: teal,
              onRefresh: _loadSavedTrips,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  16,
                  20,
                  34,
                ),
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
                          ? _buildSavedTripsSection()
                          : _buildRecentTripsSection(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------

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
                'Saved trips and journey history',
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
          child: IconButton(
            tooltip: 'Refresh saved trips',
            onPressed: _isLoading ? null : _loadSavedTrips,
            icon: const Icon(
              Icons.refresh_rounded,
              color: teal,
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // HERO
  // ------------------------------------------------------------

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
              Icons.directions_bus_rounded,
              color: navy,
              size: 31,
            ),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Text(
              'Your journeys in one place',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // TABS
  // ------------------------------------------------------------

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
              label: 'Saved Trips',
              icon: Icons.bookmark_rounded,
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
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
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

  // ------------------------------------------------------------
  // SAVED TRIPS SECTION
  // ------------------------------------------------------------

  Widget _buildSavedTripsSection() {
    if (FirebaseAuth.instance.currentUser == null) {
      return _buildStatusPanel(
        key: const ValueKey('signed-out'),
        icon: Icons.lock_outline_rounded,
        title: 'Sign in to view saved trips',
      );
    }

    if (_isLoading) {
      return const Padding(
        key: ValueKey('loading'),
        padding: EdgeInsets.symmetric(vertical: 45),
        child: Center(
          child: CircularProgressIndicator(
            color: teal,
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return _buildStatusPanel(
        key: const ValueKey('error'),
        icon: Icons.cloud_off_rounded,
        title: 'Could not load saved trips',
        actionLabel: 'Retry',
        onAction: _loadSavedTrips,
      );
    }

    if (_savedTrips.isEmpty) {
      return _buildStatusPanel(
        key: const ValueKey('empty-saved'),
        icon: Icons.bookmark_border_rounded,
        title: 'No saved trips yet',
      );
    }

    return Column(
      key: const ValueKey('saved-trips'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          'Saved Trips',
          '${_savedTrips.length} saved trips',
        ),
        const SizedBox(height: 14),
        ...List.generate(
          _savedTrips.length,
              (index) {
            final trip = _savedTrips[index];

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == _savedTrips.length - 1 ? 0 : 12,
              ),
              child: _savedTripCard(trip),
            );
          },
        ),
      ],
    );
  }

  Widget _savedTripCard(Map<String, dynamic> trip) {
    final tripId = (
        trip['tripId'] ??
            trip['id'] ??
            ''
    ).toString();

    final from = (trip['from'] ?? '').toString().trim();
    final to = (trip['to'] ?? '').toString().trim();

    final savedDate = _formatSavedDate(
      trip['createdAt'] ?? trip['updatedAt'],
    );

    final isRemoving = _removingTripIds.contains(tripId);

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
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: softCyan,
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.route_rounded,
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
                  '${from.isEmpty ? 'Departure not set' : from} → '
                      '${to.isEmpty ? 'Destination not set' : to}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: textDark,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 7),
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      color: textMuted,
                      size: 13,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        savedDate,
                        style: const TextStyle(
                          color: textMuted,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 5),
          IconButton(
            tooltip: 'Remove saved trip',
            onPressed: isRemoving
                ? null
                : () => _removeSavedTrip(trip),
            icon: isRemoving
                ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: teal,
              ),
            )
                : const Icon(
              Icons.delete_outline_rounded,
              color: Color(0xFFE05252),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // RECENT TRIPS SECTION
  // ------------------------------------------------------------

  Widget _buildRecentTripsSection() {
    return Column(
      key: const ValueKey('recent-trips'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(
          'Recent Trips',
          'Completed journey history is not connected yet',
        ),
        const SizedBox(height: 14),
        _buildStatusPanel(
          key: const ValueKey('empty-recent'),
          icon: Icons.history_rounded,
          title: 'No trip history available',
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // SHARED UI
  // ------------------------------------------------------------

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

  Widget _buildStatusPanel({
    required Key key,
    required IconData icon,
    required String title,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Container(
      key: key,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 22,
        vertical: 30,
      ),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: lightBorder),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: softCyan,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: teal,
              size: 30,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: textDark,
              fontSize: 15,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (actionLabel != null && onAction != null) ...[
            const SizedBox(height: 15),
            FilledButton.icon(
              onPressed: onAction,
              style: FilledButton.styleFrom(
                backgroundColor: navy,
                foregroundColor: white,
              ),
              icon: const Icon(
                Icons.refresh_rounded,
                size: 18,
              ),
              label: Text(actionLabel),
            ),
          ],
        ],
      ),
    );
  }
}

// --------------------------------------------------------------
// BACKGROUND
// --------------------------------------------------------------

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
              color: const Color(0xFF21D4FD).withValues(alpha: 0.09),
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
              color: const Color(0xFF00C7B7).withValues(alpha: 0.07),
            ),
          ),
        ),
      ],
    );
  }
}
