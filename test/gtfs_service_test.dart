
import 'package:flutter_test/flutter_test.dart';
import '../lib/services/gtfs_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('GTFS assets load successfully', () async {
    final service = GtfsService.instance;

    await service.loadData();

    final counts = service.dataCounts;

    expect(counts['routes'], greaterThan(0));
    expect(counts['stops'], greaterThan(0));
    expect(counts['patterns'], greaterThan(0));
    expect(counts['pattern_stops'], greaterThan(0));
    expect(counts['departures'], greaterThan(0));
    expect(counts['networks'], greaterThan(0));

    print('GTFS data loaded successfully: $counts');
  });

  test('Direct route search finds Babu sabu to Niazi Adda', () async {
    final service = GtfsService.instance;

    await service.loadData();

    final results = service.searchRoutes(
      from: 'Babu sabu',
      to: 'Niazi Adda',
    );

    expect(results, isNotEmpty);
    expect(results.first['stops'], isA<List>());
    expect(results.first['stop_count'], greaterThan(0));

    print('Babu sabu -> Niazi Adda: ${results.length} route(s) found.');
  });

  test('Route search returns no results for an unmatched origin', () async {
    final service = GtfsService.instance;

    await service.loadData();

    final results = service.searchRoutes(
      from: 'Definitely Not a Real Stop',
      to: 'Niazi Adda',
    );

    expect(results, isEmpty);
  });
}
