import 'dart:ui';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:goole_map_module_17_18/place.dart';

class googleMapServices {
  // Set MArker
  Set<Marker> getMarkers({
    required void Function(String messege) onStatusChanged,
  }) {
    return {
      for (LandMark place in Places.all)
        Marker(
          markerId: MarkerId(place.id),

          position: place.position,
          infoWindow: InfoWindow(
            title: place.title,
            snippet: place.fact,
            onTap: () {
              onStatusChanged('Bubble Tapped:${place.title}');
            },
          ),
          onTap: () {
            onStatusChanged('Pin Tapped:${place.title}');
          },
        ),
    };
  }

  // Go to Glory School#
  Future<void> gotoGlorySchool(GoogleMapController? _mapController) async {
    if (_mapController == null) return;
    await _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Places.glorySchool01.position,
          zoom: 17,
          tilt: 50,
          bearing: 45,
        ),
      ),
    );
  }

  /// reset Map
  Future<void> resetMap(
    GoogleMapController? _mapController,
    CameraPosition camera,
  ) async {
    if (_mapController == null) return;

    await _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: camera.target, zoom: 12),
      ),
    );
  }

  // Zoom in
  Future<void> zoomIn(GoogleMapController? mapController) async {
    if (mapController == null) return;

    await mapController.animateCamera(CameraUpdate.zoomIn());
  }

  // Zoom out
  Future<void> zoomOut(GoogleMapController? mapController) async {
    if (mapController == null) return;

    await mapController.animateCamera(CameraUpdate.zoomOut());
  }

  /// Current Location
  Future<Position> getCurrentPosition() async {
    // Check GPS
    final enabled = await Geolocator.isLocationServiceEnabled();

    if (!enabled) {
      await Geolocator.openLocationSettings();

      final isEnabled = await Geolocator.isLocationServiceEnabled();

      if (!isEnabled) {
        throw LocationServiceDisabledException();
      }
    }

    // Check permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      throw PermissionDeniedException('Location permission denied');
    }

    // Get current position
    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 15),
      ),
    );
  }

  Future<bool> isLocationServiceEnabled() {
    return Geolocator.isLocationServiceEnabled();
  }

  Future<LocationPermission> checkPermission() {
    return Geolocator.checkPermission();
  }

  Future<LocationPermission> requestPermission() {
    return Geolocator.requestPermission();
  }

  Future<bool> openAppSettings() {
    return Geolocator.openAppSettings();
  }

  //

  // Add a point
  List<LatLng> addPoint(List<LatLng> points, LatLng position) {
    return [...points, position];
  }

  // Load campus route
  List<LatLng> loadCampusRoute() {
    return [for (final LandMark stop in Places.shuttleRoute) stop.position];
  }

  // Create polylines
  Set<Polyline> getLines(List<LatLng> points) {
    if (points.length < 2) return {};

    return {
      Polyline(
        polylineId: const PolylineId('walk'),
        color: const Color(0xFF009688),
        points: points,
        width: 5,
      ),
    };
  }

  // Clear route
  List<LatLng> clearPoints() {
    return [];
  }
}








/* 


 String _status = 'Tap a pin, then tap the white bubble';
  Set<Marker> _markers() {
    return {
      for (final LandMark place in Places.all)
        Marker(
          markerId: MarkerId(place.id),

          position: place.position,
          infoWindow: InfoWindow(
            title: place.title,
            snippet: place.fact,
            onTap: () {
              setState(() {
                _status = 'Bubble Tapped:${Places.all.first.title}';
              });
            },
          ),

          onTap: () {
            setState(() {
              _status = 'Pin Tapped:${Places.all.first.title}';
            });
          },
        ),
    };
  }


*/