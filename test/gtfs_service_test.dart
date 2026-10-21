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

    print('GTFS DATA LOADED SUCCESSFULLY');
    print('Record counts: $counts');
  });
}