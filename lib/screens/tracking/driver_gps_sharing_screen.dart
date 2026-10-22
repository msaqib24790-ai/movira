import 'dart:async';

import 'package:flutter/material.dart';

import '../../services/live_location_service.dart';

class DriverGpsSharingScreen extends StatefulWidget {
  const DriverGpsSharingScreen({super.key});

  @override
  State<DriverGpsSharingScreen> createState() => _DriverGpsSharingScreenState();
}

class _DriverGpsSharingScreenState extends State<DriverGpsSharingScreen> {
  final _tripIdController = TextEditingController();
  final _locationService = LiveLocationService();

  bool _checking = false;
  bool _sharing = false;
  bool _authorized = false;
  String _status = 'Enter your assigned active trip ID.';
  String? _error;

  Future<void> _checkAuthorization() async {
    final tripId = _tripIdController.text.trim();

    if (tripId.isEmpty) {
      setState(() {
        _error = 'Enter the active trip ID first.';
        _authorized = false;
      });
      return;
    }

    setState(() {
      _checking = true;
      _error = null;
      _authorized = false;
      _status = 'Checking driver authorization...';
    });

    try {
      final allowed = await _locationService.isDriverAssignedToTrip(tripId);

      if (!mounted) return;

      setState(() {
        _authorized = allowed;
        _status = allowed
            ? 'Authorized for this active trip.'
            : 'This account is not assigned to this active trip.';
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = 'Authorization check failed: $error';
        _status = 'Unable to verify authorization.';
      });
    } finally {
      if (mounted) {
        setState(() => _checking = false);
      }
    }
  }

  Future<void> _startSharing() async {
    final tripId = _tripIdController.text.trim();

    if (tripId.isEmpty) {
      setState(() => _error = 'Enter the active trip ID first.');
      return;
    }

    setState(() {
      _checking = true;
      _error = null;
      _status = 'Verifying trip and starting GPS sharing...';
    });

    try {
      // The service rechecks assignment before starting.
      await _locationService.startDriverSharing(
        tripId,
        onSharingError: (error) {
          if (!mounted) return;
          setState(() {
            _error = 'GPS sharing error: $error';
          });
        },
      );

      if (!mounted) {
        await _locationService.stopDriverSharing();
        return;
      }

      setState(() {
        _sharing = true;
        _authorized = true;
        _status = 'GPS sharing is running for trip $tripId.';
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _sharing = false;
        _authorized = false;
        _status = 'GPS sharing did not start.';
        _error = error.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _checking = false);
      }
    }
  }

  Future<void> _stopSharing() async {
    setState(() {
      _checking = true;
      _error = null;
    });

    try {
      await _locationService.stopDriverSharing();

      if (!mounted) return;

      setState(() {
        _sharing = false;
        _status = 'GPS sharing stopped.';
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        _error = 'Unable to stop GPS sharing: $error';
      });
    } finally {
      if (mounted) {
        setState(() => _checking = false);
      }
    }
  }

  @override
  void dispose() {
    unawaited(_locationService.stopDriverSharing());
    _tripIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const teal = Color(0xFF00C7B7);
    const navy = Color(0xFF071B2C);

    return Scaffold(
      appBar: AppBar(title: const Text('Driver GPS Sharing')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Icon(Icons.location_on_rounded, size: 64, color: teal),
            const SizedBox(height: 12),
            const Text(
              'Share your trip location',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Only an authorized driver assigned to an active trip '
              'can share GPS coordinates. Keep this screen open '
              'while sharing.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _tripIdController,
              enabled: !_sharing && !_checking,
              decoration: const InputDecoration(
                labelText: 'Assigned active trip ID',
                hintText: 'Enter your trip document ID',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.directions_bus_rounded),
              ),
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: _checking || _sharing ? null : _checkAuthorization,
              icon: const Icon(Icons.verified_user_outlined),
              label: const Text('Check Authorization'),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              onPressed: _checking || _sharing ? null : _startSharing,
              icon: const Icon(Icons.my_location_rounded),
              label: const Text('Start GPS Sharing'),
              style: FilledButton.styleFrom(
                backgroundColor: teal,
                foregroundColor: navy,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: !_sharing || _checking ? null : _stopSharing,
              icon: const Icon(Icons.stop_circle_outlined),
              label: const Text('Stop GPS Sharing'),
            ),
            const SizedBox(height: 22),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      _sharing
                          ? Icons.gps_fixed_rounded
                          : Icons.info_outline_rounded,
                      color: _sharing ? teal : Colors.amber,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _sharing
                                ? 'SHARING'
                                : _checking
                                ? 'PLEASE WAIT'
                                : _authorized
                                ? 'AUTHORIZED'
                                : 'NOT SHARING',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 6),
                          Text(_status),
                          if (_error != null) ...[
                            const SizedBox(height: 8),
                            Text(
                              _error!,
                              style: const TextStyle(color: Colors.redAccent),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Privacy: location is written to the liveLocations '
              'document for the selected trip. Firestore rules '
              'must continue to enforce driver authorization.',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
