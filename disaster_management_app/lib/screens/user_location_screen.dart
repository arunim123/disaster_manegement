import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class UserLocationScreen extends StatefulWidget {
  const UserLocationScreen({super.key});

  @override
  State<UserLocationScreen> createState() => _UserLocationScreenState();
}

class _UserLocationScreenState extends State<UserLocationScreen> {
  LatLng? _currentPosition;
  bool _isLoading = true;
  String? _errorMessage;
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    bool serviceEnabled;
    LocationPermission permission;

    try {
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _errorMessage = 'Location services are disabled on your device. Please enable them in your device settings to see your location.';
          _isLoading = false;
        });
        return;
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _errorMessage = 'Location permission was denied. Please grant permission to show your current location.';
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _errorMessage = 'Location permission is permanently denied. To use this feature, please enable it in your app settings.';
          _isLoading = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _isLoading = false;
        if (_currentPosition != null) {
            _mapController.move(_currentPosition!, 15.0);
        }
      });
    } catch (e) {
      if (e is PermissionRequestInProgressException) {
         setState(() {
            _errorMessage = 'A location permission request is already in progress. Please respond to the existing dialog.';
            _isLoading = false;
         });
      } else {
        setState(() {
          _errorMessage = 'Failed to get current location. Please ensure your GPS is on and try again. Error: ${e.toString()}';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Current Location'),
        actions: [
          Semantics(
            label: 'Refresh current location button',
            child: IconButton(
              icon: const Icon(Icons.my_location),
              onPressed: _determinePosition,
              tooltip: 'Get Current Location',
            ),
          )
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    bool isPermissionError = message.toLowerCase().contains('permission');
    bool isServiceError = message.toLowerCase().contains('services are disabled');

    List<Widget> actions = [
      ElevatedButton.icon(
        icon: const Icon(Icons.refresh),
        label: const Text('Retry'),
        onPressed: _determinePosition,
        style: ElevatedButton.styleFrom(minimumSize: const Size(150, 40)),
      ),
    ];

    if (isPermissionError) {
      actions.add(const SizedBox(height: 10));
      actions.add(
        TextButton.icon(
          icon: const Icon(Icons.settings_outlined),
          label: const Text('Open App Settings'),
          onPressed: () async => await Geolocator.openAppSettings(),
          style: TextButton.styleFrom(minimumSize: const Size(150, 40)),
        ),
      );
    } else if (isServiceError) {
      actions.add(const SizedBox(height: 10));
      actions.add(
        TextButton.icon(
          icon: const Icon(Icons.settings),
          label: const Text('Open Location Settings'),
          onPressed: () async => await Geolocator.openLocationSettings(),
          style: TextButton.styleFrom(minimumSize: const Size(150, 40)),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.red[600]),
            const SizedBox(height: 20),
            Text(
              message,
              style: TextStyle(color: Colors.red[700], fontSize: 17, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 25),
            ...actions,
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Fetching your location...', style: TextStyle(fontSize: 16)),
          ],
        )
      );
    }
    if (_errorMessage != null) {
      return _buildErrorWidget(context, _errorMessage!); 
    }
    if (_currentPosition == null) {
      return _buildErrorWidget(context, 'Could not determine location. Please ensure your GPS is on and try again.');
    }
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _currentPosition!,
        initialZoom: 15.0,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.disaster_management_app', 
        ),
        MarkerLayer(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: _currentPosition!,
              child: Tooltip(
                message: 'Your current location',
                child: Icon(
                  Icons.person_pin_circle,
                  color: Theme.of(context).primaryColor,
                  size: 50.0,
                  semanticLabel: 'Your current location marker',
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
} 