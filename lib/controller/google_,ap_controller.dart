import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:goole_map_module_17_18/services/google_map_services.dart';

class googleMapController {
  final googleMapServices _servicecs = googleMapServices();
  String status = 'Tap a pin, then tap the white bubble';
  Set<Marker> getMarkers({required void Function() onUpdate}) {
    return _servicecs.getMarkers(
      onStatusChanged: (massege) {
        status = massege;
        onUpdate();
      },
    );
  }

  Future<void> gotoGlorySchool(GoogleMapController? mapController) async {
    await _servicecs.gotoGlorySchool(mapController);
  }

  Future<void> resetMap(
    GoogleMapController? mapController,
    CameraPosition camera,
  ) async {
    await _servicecs.resetMap(mapController, camera);
  }

  Future<void> zoomIn(GoogleMapController? mapController) async {
    await _servicecs.zoomIn(mapController);
  }

  Future<void> zoomOut(GoogleMapController? mapController) async {
    await _servicecs.zoomOut(mapController);
  }

  // find me
  Future<LatLng> findMe() async {
    final Position position = await _servicecs.getCurrentPosition();
    
    return LatLng(position.latitude, position.longitude);
  }

  Future<({LocationPermission permission, bool serviceEnabled})>
  refresh() async {
    final results = await Future.wait([
      _servicecs.checkPermission(),
      _servicecs.isLocationServiceEnabled(),
    ]);

    return (
      permission: results[0] as LocationPermission,
      serviceEnabled: results[1] as bool,
    );
  }

  Future<({LocationPermission permission, bool serviceEnabled})> ask() async {
    LocationPermission permission = await _servicecs.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await _servicecs.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      await _servicecs.openAppSettings();
    }

    final bool serviceEnabled = await _servicecs.isLocationServiceEnabled();

    if (permission == LocationPermission.deniedForever) {
      permission = await _servicecs.checkPermission();
    }

    return (permission: permission, serviceEnabled: serviceEnabled);
  }

  bool canShowBlueDot(LocationPermission? permission) {
    return permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse;
  }

  String explain(LocationPermission? permission) {
    if (permission == null) {
      return 'No location permission available.';
    }

    switch (permission) {
      case LocationPermission.denied:
        return 'Location permission is denied.';
      case LocationPermission.deniedForever:
        return 'Location permission is permanently denied.';
      case LocationPermission.always:
        return 'Location permission is granted always.';
      case LocationPermission.whileInUse:
        return 'Location permission is granted while in use.';
      case LocationPermission.unableToDetermine:
        return 'Unable to determine location permission.';
    }
  }

  // Add a point
  List<LatLng> addPoint(List<LatLng> points, LatLng position) {
    return _servicecs.addPoint(points, position);
  }

  // Load campus route
  List<LatLng> loadCampusRoute() {
    return _servicecs.loadCampusRoute();
  }

  // Get polylines
  Set<Polyline> getLines(List<LatLng> points) {
    return _servicecs.getLines(points);
  }

  // Clear route
  List<LatLng> clearPoints() {
    return _servicecs.clearPoints();
  }
}
