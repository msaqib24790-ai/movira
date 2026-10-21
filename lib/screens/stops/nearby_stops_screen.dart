import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../../services/gtfs_service.dart';
import 'stop_details_screen.dart';

class NearbyStopsScreen extends StatefulWidget {
  const NearbyStopsScreen({super.key});

  @override
  State<NearbyStopsScreen> createState() => _NearbyStopsScreenState();
}

class _NearbyStopsScreenState extends State<NearbyStopsScreen> {
  static const Color navy = Color(0xFF071B2C);
  static const Color teal = Color(0xFF00C7B7);
  static const Color ice = Color(0xFFF4FBFD);
  static const Color textMuted = Color(0xFF6B7C88);
  static const Color lightBorder = Color(0xFFE1EDF1);

  // Fallback map location when GPS has not been obtained.
  static const LatLng initialCenter = LatLng(31.5204, 74.3587);

  final MapController _mapController = MapController();

  List<Map<String, String>> _allStops = [];

  Position? _position;

  bool _loading = true;
  bool _locating = false;

  String? _error;
  String? _selectedStopId;

  @override
  void initState() {
    super.initState();
    _loadStops();
  }

  Future<void> _loadStops() async {
    try {
      await GtfsService.instance.loadData();

      final stops = GtfsService.instance.allStops;

      if (!mounted) return;

      setState(() {
        _allStops = stops;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
        _error = 'Could not load transit stops. Please try again.';
      });

      debugPrint('Nearby stops loading error: $e');
    }
  }

  Future<void> _findMyLocation() async {
    if (_locating) return;

    setState(() {
      _locating = true;
      _error = null;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        throw Exception(
          'Location is turned off. Enable GPS/location and try again.',
        );
      }

      var permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        throw Exception(
          'Location permission was denied. Allow it in app settings.',
        );
      }

      if (permission == LocationPermission.deniedForever) {
        throw Exception(
          'Location permission is permanently denied. '
          'Enable it in Android app settings.',
        );
      }

      Position? position;

      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.medium,
            timeLimit: Duration(seconds: 60),
          ),
        );
      } on TimeoutException {
        position = await Geolocator.getLastKnownPosition();

        if (position == null) {
          rethrow;
        }
      }

      if (!mounted) return;

      setState(() {
        _position = position;
        _selectedStopId = null;
        _error = null;
      });

      _mapController.move(LatLng(position.latitude, position.longitude), 14);
    } on TimeoutException {
      if (!mounted) return;

      setState(() {
        _error =
            'Location took too long. Check GPS or set a location '
            'in the Android emulator controls.';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _locating = false);
      }
    }
  }

  double? _latitude(Map<String, String> stop) {
    final value = double.tryParse(stop['stop_lat'] ?? '');

    if (value == null || !value.isFinite || value < -90 || value > 90) {
      return null;
    }

    return value;
  }

  double? _longitude(Map<String, String> stop) {
    final value = double.tryParse(stop['stop_lon'] ?? '');

    if (value == null || !value.isFinite || value < -180 || value > 180) {
      return null;
    }

    return value;
  }

  double? _distanceTo(Map<String, String> stop) {
    final position = _position;
    final lat = _latitude(stop);
    final lon = _longitude(stop);

    if (position == null || lat == null || lon == null) {
      return null;
    }

    return Geolocator.distanceBetween(
      position.latitude,
      position.longitude,
      lat,
      lon,
    );
  }

  List<Map<String, String>> get _nearbyStops {
    if (_position == null) return [];

    final stops = _allStops.where((stop) {
      final distance = _distanceTo(stop);
      return distance != null && distance <= 10000;
    }).toList();

    stops.sort((a, b) {
      return _distanceTo(a)!.compareTo(_distanceTo(b)!);
    });

    return stops.take(50).toList();
  }

  List<Map<String, String>> get _mapStops {
    final center = _position == null
        ? initialCenter
        : LatLng(_position!.latitude, _position!.longitude);

    final stops = _allStops.where((stop) {
      final lat = _latitude(stop);
      final lon = _longitude(stop);

      if (lat == null || lon == null) return false;

      final distance = Geolocator.distanceBetween(
        center.latitude,
        center.longitude,
        lat,
        lon,
      );

      return distance <= 15000;
    }).toList();

    return stops.take(300).toList();
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.round()} m';
    }

    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  String _walkingTime(double meters) {
    final minutes = (meters / 80).ceil();
    return 'about $minutes min walk';
  }

  void _showStopOnMap(Map<String, String> stop) {
    final lat = _latitude(stop);
    final lon = _longitude(stop);

    if (lat == null || lon == null) return;

    setState(() {
      _selectedStopId = stop['stop_id'];
    });

    _mapController.move(LatLng(lat, lon), 16);
  }

  // Pass the real GTFS stop ID into the details screen.
  void _openStop(Map<String, String> stop) {
    final distance = _distanceTo(stop);

    final stopId = stop['stop_id'] ?? '';

    if (stopId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This stop has no valid GTFS stop ID.')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StopDetailsScreen(
          stopId: stopId,
          stopName: stop['stop_name'] ?? 'Transit stop',
          distance: distance == null
              ? 'Distance unavailable'
              : _formatDistance(distance),
          walkingTime: distance == null
              ? 'Find your location first'
              : _walkingTime(distance),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final nearby = _nearbyStops;

    return Scaffold(
      backgroundColor: ice,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: navy,
                  ),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'NEARBY STOPS',
                          style: TextStyle(
                            color: navy,
                            fontWeight: FontWeight.w900,
                            fontSize: 17,
                          ),
                        ),
                        Text(
                          'Real transit stop coordinates',
                          style: TextStyle(color: textMuted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Find my location',
                    onPressed: _locating ? null : _findMyLocation,
                    icon: const Icon(Icons.my_location_rounded),
                    color: teal,
                  ),
                ],
              ),
            ),

            // Map
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
              child: Container(
                height: 300,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: lightBorder),
                ),
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: _mapController,
                      options: const MapOptions(
                        initialCenter: initialCenter,
                        initialZoom: 11,
                        minZoom: 4,
                        maxZoom: 18,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.example.movira',
                        ),
                        MarkerLayer(
                          markers: [
                            ..._mapStops.map((stop) {
                              final lat = _latitude(stop)!;
                              final lon = _longitude(stop)!;
                              final selected =
                                  stop['stop_id'] == _selectedStopId;

                              return Marker(
                                point: LatLng(lat, lon),
                                width: 42,
                                height: 48,
                                child: GestureDetector(
                                  onTap: () => _showStopOnMap(stop),
                                  child: Icon(
                                    Icons.location_on,
                                    size: selected ? 42 : 34,
                                    color: selected ? navy : teal,
                                  ),
                                ),
                              );
                            }),
                            if (_position != null)
                              Marker(
                                point: LatLng(
                                  _position!.latitude,
                                  _position!.longitude,
                                ),
                                width: 44,
                                height: 44,
                                child: const Icon(
                                  Icons.my_location,
                                  size: 30,
                                  color: Colors.blue,
                                ),
                              ),
                          ],
                        ),
                        RichAttributionWidget(
                          attributions: [
                            TextSourceAttribution('OpenStreetMap contributors'),
                          ],
                        ),
                      ],
                    ),

                    Positioned(
                      top: 12,
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          _position == null
                              ? '${_mapStops.length} stops in map area'
                              : '${nearby.length} stops within 10 km',
                          style: const TextStyle(
                            color: navy,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),

                    Positioned(
                      right: 12,
                      bottom: 12,
                      child: FloatingActionButton.small(
                        heroTag: 'nearbyMapLocationButton',
                        onPressed: _locating ? null : _findMyLocation,
                        backgroundColor: navy,
                        foregroundColor: Colors.white,
                        child: _locating
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.my_location),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            if (_error != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Text(
                  _error!,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
              ),

            Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 10),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Stops near you',
                      style: TextStyle(
                        color: navy,
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Text(
                    _position == null ? 'Location not set' : 'Nearest first',
                    style: const TextStyle(color: textMuted, fontSize: 11),
                  ),
                ],
              ),
            ),

            // Nearby stops list
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : _error != null && _allStops.isEmpty
                  ? Center(
                      child: Text(
                        _error!,
                        style: const TextStyle(color: textMuted),
                      ),
                    )
                  : _position == null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.location_searching,
                              color: teal,
                              size: 42,
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Find stops near your real location',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: navy,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Allow location access to calculate '
                              'actual distances to GTFS stops.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: textMuted, height: 1.4),
                            ),
                            const SizedBox(height: 14),
                            ElevatedButton.icon(
                              onPressed: _locating ? null : _findMyLocation,
                              icon: const Icon(Icons.my_location),
                              label: const Text('Use my location'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: navy,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : nearby.isEmpty
                  ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'No GTFS stops were found within '
                          '10 km of your current location.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: textMuted),
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: nearby.length,
                      itemBuilder: (context, index) {
                        final stop = nearby[index];
                        final distance = _distanceTo(stop)!;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          color: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                            side: const BorderSide(color: lightBorder),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              children: [
                                const CircleAvatar(
                                  backgroundColor: Color(0xFFDDFBFA),
                                  child: Icon(
                                    Icons.directions_bus,
                                    color: teal,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        stop['stop_name'] ?? 'Unnamed stop',
                                        style: const TextStyle(
                                          color: navy,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        '${_formatDistance(distance)}'
                                        ' • ${_walkingTime(distance)}',
                                        style: const TextStyle(
                                          color: textMuted,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Stop ID: '
                                        '${stop['stop_id'] ?? 'Unknown'}',
                                        style: const TextStyle(
                                          color: textMuted,
                                          fontSize: 10,
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      const Text(
                                        'Walking time is an estimate',
                                        style: TextStyle(
                                          color: textMuted,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuButton<String>(
                                  tooltip: 'Stop actions',
                                  onSelected: (action) {
                                    if (action == 'map') {
                                      _showStopOnMap(stop);
                                    } else if (action == 'details') {
                                      _openStop(stop);
                                    }
                                  },
                                  itemBuilder: (context) => const [
                                    PopupMenuItem(
                                      value: 'map',
                                      child: Text('Show on map'),
                                    ),
                                    PopupMenuItem(
                                      value: 'details',
                                      child: Text('View stop details'),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
