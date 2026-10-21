
import 'package:cloud_firestore/cloud_firestore.dart';

class BusRouteService {
  static final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  static CollectionReference<Map<String, dynamic>>
  get _routesCollection => _firestore.collection('routes');

  /// Retrieves all routes from Firestore.
  static Future<List<Map<String, dynamic>>> getAllRoutes() async {
    final snapshot = await _routesCollection.get();

    return snapshot.docs.map((doc) {
      return {
        'id': doc.id,
        ...doc.data(),
      };
    }).toList();
  }

  /// Finds routes that contain both the starting
  /// and destination stops.
  static Future<List<Map<String, dynamic>>> searchRoutes({
    required String from,
    required String to,
  }) async {
    final routes = await getAllRoutes();

    final start = from.trim().toLowerCase();
    final destination = to.trim().toLowerCase();

    return routes.where((route) {
      final stops = (route['stops'] as List<dynamic>?)
          ?.map((stop) => stop.toString().toLowerCase())
          .toList() ??
          [];

      final startIndex = stops.indexOf(start);
      final destinationIndex = stops.indexOf(destination);

      return startIndex != -1 &&
          destinationIndex != -1 &&
          startIndex < destinationIndex;
    }).toList();
  }

  /// Retrieves one route by its Firestore document ID.
  static Future<Map<String, dynamic>?> getRouteById(
      String routeId) async {
    final doc = await _routesCollection.doc(routeId).get();

    if (!doc.exists) {
      return null;
    }

    return {
      'id': doc.id,
      ...doc.data()!,
    };
  }
}
