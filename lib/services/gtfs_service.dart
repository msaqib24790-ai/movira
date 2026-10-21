import 'package:csv/csv.dart';
import 'package:flutter/services.dart';

class GtfsService {
  GtfsService._();

  static final GtfsService instance = GtfsService._();

  bool _isLoaded = false;

  List<Map<String, String>> _routes = [];
  List<Map<String, String>> _stops = [];
  List<Map<String, String>> _patterns = [];
  List<Map<String, String>> _patternStops = [];
  List<Map<String, String>> _departures = [];
  List<Map<String, String>> _networks = [];
  List<Map<String, String>> _routeNetworks = [];

  Future<void> loadData() async {
    if (_isLoaded) return;

    try {
      _routes = await _loadCsv('assets/gtfs/routes.txt');
      _stops = await _loadCsv('assets/gtfs/stops.txt');
      _patterns = await _loadCsv('assets/gtfs/pakbus_patterns.txt');
      _patternStops = await _loadCsv('assets/gtfs/pakbus_pattern_stops.txt');
      _departures = await _loadCsv('assets/gtfs/pakbus_departures.txt');
      _networks = await _loadCsv('assets/gtfs/networks.txt');
      _routeNetworks = await _loadCsv('assets/gtfs/route_networks.txt');

      _isLoaded = true;
    } catch (error) {
      throw Exception('Could not load GTFS transport data: $error');
    }
  }

  Future<List<Map<String, String>>> _loadCsv(String assetPath) async {
    final content = await rootBundle.loadString(assetPath);

    final rows = const CsvToListConverter(
      eol: '\n',
      shouldParseNumbers: false,
    ).convert(content);

    if (rows.isEmpty) return [];

    final headers = rows.first.map((value) => value.toString().trim()).toList();

    return rows
        .skip(1)
        .where((row) => row.any((value) => value.toString().trim().isNotEmpty))
        .map((row) {
          final record = <String, String>{};

          for (var i = 0; i < headers.length; i++) {
            record[headers[i]] = i < row.length ? row[i].toString().trim() : '';
          }

          return record;
        })
        .toList();
  }

  void _ensureLoaded() {
    if (!_isLoaded) {
      throw StateError('GTFS data is not loaded. Call loadData() first.');
    }
  }

  String _normalise(String value) {
    return value.trim().toLowerCase();
  }

  /// Returns stops whose names contain the search query.
  List<Map<String, String>> searchStops(String query, {int limit = 15}) {
    _ensureLoaded();

    final search = _normalise(query);

    if (search.isEmpty || limit <= 0) return [];

    return _stops
        .where((stop) {
          final name = _normalise(stop['stop_name'] ?? '');
          return name.contains(search);
        })
        .take(limit)
        .toList();
  }

  /// Returns all loaded stops for map and nearby-stop features.
  List<Map<String, String>> get allStops {
    _ensureLoaded();
    return List.unmodifiable(_stops);
  }

  /// Gets a stop using its GTFS stop ID.
  Map<String, String>? getStopById(String stopId) {
    _ensureLoaded();

    for (final stop in _stops) {
      if (stop['stop_id'] == stopId) {
        return stop;
      }
    }

    return null;
  }

  /// Gets a route using its GTFS route ID.
  Map<String, String>? getRouteById(String routeId) {
    _ensureLoaded();

    for (final route in _routes) {
      if (route['route_id'] == routeId) {
        return route;
      }
    }

    return null;
  }

  /// Returns timetable departures joined with their route, pattern,
  /// and departure stop.
  ///
  /// Each result contains:
  /// pattern_id, stop_id, departure_time, days, checked_on,
  /// pattern, route, and stop.
  ///
  /// These are scheduled departures, not live vehicle predictions.
  List<Map<String, dynamic>> get scheduledDepartures {
    _ensureLoaded();

    final patternsById = <String, Map<String, String>>{};
    final routesById = <String, Map<String, String>>{};
    final stopsById = <String, Map<String, String>>{};

    for (final pattern in _patterns) {
      final id = pattern['pattern_id'] ?? '';
      if (id.isNotEmpty) {
        patternsById[id] = pattern;
      }
    }

    for (final route in _routes) {
      final id = route['route_id'] ?? '';
      if (id.isNotEmpty) {
        routesById[id] = route;
      }
    }

    for (final stop in _stops) {
      final id = stop['stop_id'] ?? '';
      if (id.isNotEmpty) {
        stopsById[id] = stop;
      }
    }

    final results = <Map<String, dynamic>>[];

    for (final departure in _departures) {
      final patternId = departure['pattern_id'] ?? '';
      final stopId = departure['stop_id'] ?? '';

      final pattern = patternsById[patternId];
      final stop = stopsById[stopId];

      if (pattern == null || stop == null) continue;

      final routeId = pattern['route_id'] ?? '';
      final route = routesById[routeId];

      if (route == null) continue;

      final departureTime = departure['departure_time'] ?? '';

      // Only include records with a valid HH:mm:ss time.
      if (!_isValidTime(departureTime)) continue;

      results.add({
        'pattern_id': patternId,
        'stop_id': stopId,
        'departure_time': departureTime,
        'days': departure['days'] ?? '',
        'checked_on': departure['checked_on'] ?? '',
        'pattern': pattern,
        'route': route,
        'stop': stop,
      });
    }

    results.sort((a, b) {
      final timeA = a['departure_time'] as String;
      final timeB = b['departure_time'] as String;
      return timeA.compareTo(timeB);
    });

    return List.unmodifiable(results);
  }

  bool _isValidTime(String value) {
    final match = RegExp(r'^(\d{2}):(\d{2}):(\d{2})$').firstMatch(value);

    if (match == null) return false;

    final hour = int.parse(match.group(1)!);
    final minute = int.parse(match.group(2)!);
    final second = int.parse(match.group(3)!);

    return hour <= 23 && minute <= 59 && second <= 59;
  }

  /// Finds direct routes from origin to destination in the correct
  /// stop sequence. This does not calculate transfers.
  List<Map<String, dynamic>> searchRoutes({
    required String from,
    required String to,
  }) {
    _ensureLoaded();

    final origin = _normalise(from);
    final destination = _normalise(to);

    if (origin.isEmpty || destination.isEmpty || origin == destination) {
      return [];
    }

    final originStops = _stops.where((stop) {
      return _normalise(stop['stop_name'] ?? '') == origin;
    }).toList();

    final destinationStops = _stops.where((stop) {
      return _normalise(stop['stop_name'] ?? '') == destination;
    }).toList();

    if (originStops.isEmpty || destinationStops.isEmpty) {
      return [];
    }

    final originIds = originStops.map((stop) => stop['stop_id']!).toSet();

    final destinationIds = destinationStops
        .map((stop) => stop['stop_id']!)
        .toSet();

    final results = <Map<String, dynamic>>[];

    for (final pattern in _patterns) {
      final patternId = pattern['pattern_id'] ?? '';
      final routeId = pattern['route_id'] ?? '';

      if (patternId.isEmpty || routeId.isEmpty) continue;

      final orderedStops =
          _patternStops
              .where((item) => item['pattern_id'] == patternId)
              .toList()
            ..sort((a, b) {
              final aSequence = int.tryParse(a['stop_sequence'] ?? '') ?? 0;
              final bSequence = int.tryParse(b['stop_sequence'] ?? '') ?? 0;

              return aSequence.compareTo(bSequence);
            });

      final startIndex = orderedStops.indexWhere(
        (item) => originIds.contains(item['stop_id']),
      );

      final endIndex = orderedStops.indexWhere(
        (item) => destinationIds.contains(item['stop_id']),
      );

      if (startIndex < 0 || endIndex < 0 || startIndex >= endIndex) {
        continue;
      }

      final route = getRouteById(routeId);

      if (route == null) continue;

      final journeyStops = orderedStops
          .sublist(startIndex, endIndex + 1)
          .map((item) => getStopById(item['stop_id'] ?? ''))
          .whereType<Map<String, String>>()
          .toList();

      final originStopId = orderedStops[startIndex]['stop_id'] ?? '';

      final departureTimes = _departures
          .where((item) {
            return item['pattern_id'] == patternId &&
                item['stop_id'] == originStopId;
          })
          .map(
            (item) => {
              'departure_time': item['departure_time'] ?? '',
              'days': item['days'] ?? '',
              'checked_on': item['checked_on'] ?? '',
            },
          )
          .toList();

      final networkIds = _routeNetworks
          .where((item) => item['route_id'] == routeId)
          .map((item) => item['network_id'])
          .whereType<String>()
          .toSet();

      final networkNames = _networks
          .where((item) => networkIds.contains(item['network_id']))
          .map((item) => item['network_name'] ?? '')
          .where((name) => name.isNotEmpty)
          .toList();

      results.add({
        'route': route,
        'pattern': pattern,
        'stops': journeyStops,
        'stop_count': journeyStops.length,
        'departure_times': departureTimes,
        'networks': networkNames,
      });
    }

    return results;
  }

  /// Returns record counts for diagnostics and tests.
  Map<String, int> get dataCounts {
    _ensureLoaded();

    return {
      'routes': _routes.length,
      'stops': _stops.length,
      'patterns': _patterns.length,
      'pattern_stops': _patternStops.length,
      'departures': _departures.length,
      'networks': _networks.length,
      'route_networks': _routeNetworks.length,
    };
  }
}
