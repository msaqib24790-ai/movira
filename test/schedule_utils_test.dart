import 'package:flutter_test/flutter_test.dart';

import '../lib/services/gtfs_service.dart';
import '../lib/services/schedule_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final monday = DateTime(2026, 10, 19);

  final schedules = <Map<String, String>>[
    {
      'stop_name': 'Test Stop',
      'route_short_name': 'R1',
      'departure_time': '06:15:00',
      'days': '1111111',
    },
    {
      'stop_name': 'Test Stop',
      'route_short_name': 'R1',
      'departure_time': '11:59:00',
      'days': '1111111',
    },
    {
      'stop_name': 'Test Stop',
      'route_short_name': 'R1',
      'departure_time': '12:00:00',
      'days': '1111111',
    },
    {
      'stop_name': 'Test Stop',
      'route_short_name': 'R1',
      'departure_time': '16:59:00',
      'days': '1111111',
    },
    {
      'stop_name': 'Test Stop',
      'route_short_name': 'R1',
      'departure_time': '17:00:00',
      'days': '1111111',
    },
  ];

  group('MOVIRA schedule filtering', () {
    test('All filter includes every departure on the selected day', () {
      final result = ScheduleUtils.filterSchedules(schedules, monday, 0);

      expect(result.length, 5);
    });

    test('Morning filter includes departures before noon', () {
      final result = ScheduleUtils.filterSchedules(schedules, monday, 1);

      expect(result.map((schedule) => schedule['departure_time']).toList(), [
        '06:15:00',
        '11:59:00',
      ]);
    });

    test('Afternoon filter includes noon through before 5 PM', () {
      final result = ScheduleUtils.filterSchedules(schedules, monday, 2);

      expect(result.map((schedule) => schedule['departure_time']).toList(), [
        '12:00:00',
        '16:59:00',
      ]);
    });

    test('Evening filter includes departures from 5 PM onward', () {
      final result = ScheduleUtils.filterSchedules(schedules, monday, 3);

      expect(result.map((schedule) => schedule['departure_time']).toList(), [
        '17:00:00',
      ]);
    });

    test('Day flags correctly identify service days', () {
      final weekdays = <String, String>{
        'departure_time': '08:00:00',
        'days': '1000000',
      };

      expect(ScheduleUtils.runsOnDay(weekdays, monday), isTrue);
      expect(
        ScheduleUtils.runsOnDay(weekdays, DateTime(2026, 10, 20)),
        isFalse,
      );
    });

    test('Invalid departure times are rejected', () {
      expect(ScheduleUtils.hourOf({'departure_time': '25:00:00'}), isNull);
      expect(ScheduleUtils.hourOf({'departure_time': '08:75:00'}), isNull);
      expect(ScheduleUtils.hourOf({'departure_time': 'invalid'}), isNull);
    });
  });

  group('MOVIRA time formatting', () {
    test('Formats midnight correctly', () {
      expect(ScheduleUtils.formatTime('00:05:00'), '12:05 AM');
    });

    test('Formats morning correctly', () {
      expect(ScheduleUtils.formatTime('06:15:00'), '6:15 AM');
    });

    test('Formats noon correctly', () {
      expect(ScheduleUtils.formatTime('12:00:00'), '12:00 PM');
    });

    test('Formats afternoon correctly', () {
      expect(ScheduleUtils.formatTime('17:30:00'), '5:30 PM');
    });

    test('Formats the final minute of the day correctly', () {
      expect(ScheduleUtils.formatTime('23:59:00'), '11:59 PM');
    });
  });

  test('GTFS departures contain valid schedule information', () async {
    final service = GtfsService.instance;
    await service.loadData();

    final departures = service.scheduledDepartures;

    expect(departures, isNotEmpty);

    for (final departure in departures.take(100)) {
      final time = departure['departure_time']?.toString() ?? '';
      final parts = time.split(':');

      expect(parts.length, 3);
      expect(ScheduleUtils.hourOf({'departure_time': time}), isNotNull);

      expect(departure['days']?.toString().length, 7);

      final route = departure['route'] as Map<String, String>?;
      final stop = departure['stop'] as Map<String, String>?;

      expect(route, isNotNull);
      expect(stop, isNotNull);
      expect(route?['route_short_name'], isNotEmpty);
      expect(stop?['stop_name'], isNotEmpty);
    }
  });
}
