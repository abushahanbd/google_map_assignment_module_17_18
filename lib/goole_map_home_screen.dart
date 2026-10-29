import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:goole_map_module_17_18/controller/google_,ap_controller.dart';
import 'package:goole_map_module_17_18/place.dart';

class GoogleMapHomeScreen extends StatefulWidget {
  const GoogleMapHomeScreen({super.key});

  @override
  State<GoogleMapHomeScreen> createState() => _GoogleMapHomeScreenState();
}

class _GoogleMapHomeScreenState extends State<GoogleMapHomeScreen> {
  final ValueNotifier<CameraPosition> _camera = ValueNotifier<CameraPosition>(
    Places.openingCamera,
  );
  GoogleMapController? _mapController;
  LatLng? _me;

  String _status = 'Press "Find me". On an emulator, set a fake location first';

  bool _busy = false;
  List<LatLng> _point = [];

  @override
  void dispose() {
    _camera.dispose();
    super.dispose();
  }

  bool _isScroll = false;
  bool _isZoom = false;

  final googleMapController _Controller = googleMapController();
  String get _TapStatus => _Controller.status;

  Set<Marker> _markers() {
    return _Controller.getMarkers(
      onUpdate: () {
        if (!mounted) return;

        setState(() {});
      },
    );
  }

  // findMe

  Future<void> _findMe() async {
    if (_busy) return;

    setState(() => _busy = true);
    debugPrint('[FindMe] Started');

    try {
      // 1. Get current location from Controller
      final LatLng here = await _Controller.findMe();

      debugPrint('[FindMe] Location received: $here');

      if (!mounted) return;
      

      // 2. Update marker and status
      setState(() {
        _me = here;
        _status =
            'Lat: ${here.latitude.toStringAsFixed(6)}\n'
            'Lng: ${here.longitude.toStringAsFixed(6)}';
      });

      // 3. Move the map camera
      final GoogleMapController? controller = _mapController;

      if (controller == null) {
        debugPrint('[FindMe] Map controller is null');
        setState(() {
          _status = 'Location found, but map is not ready yet.';
        });
        return;
      }

      await controller.animateCamera(CameraUpdate.newLatLngZoom(here, 17));

      debugPrint('[FindMe] Camera moved to current location');
    } catch (e, stackTrace) {
      debugPrint('[FindMe] Error: $e');
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      setState(() {
        _status = 'Failed to get location: $e';
      });
    } finally {
      if (mounted) {
        setState(() => _busy = false);
      }
    }
  }

  LocationPermission? _permission;
  bool _isServicesOn = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    try {
      final result = await _Controller.refresh();

      if (!mounted) return;

      setState(() {
        _permission = result.permission;
        _isServicesOn = result.serviceEnabled;
      });
    } catch (e) {
      debugPrint('Refresh failed: $e');
    }
  }

  Future<void> _ask() async {
    try {
      final result = await _Controller.ask();

      if (!mounted) return;

      setState(() {
        _permission = result.permission;
        _isServicesOn = result.serviceEnabled;
      });
    } catch (e) {
      debugPrint('Permission request failed: $e');
    }
  }

  bool get _canShowBlueDot => _Controller.canShowBlueDot(_permission);

  String _explain() => _Controller.explain(_permission);

  void _addPoint(LatLng position) {
    setState(() {
      _point = _Controller.addPoint(_point, position);
    });
  }

  void _loadCampusRoute() {
    setState(() {
      _point = _Controller.loadCampusRoute();
    });
  }

  Set<Polyline> _lines() {
    return _Controller.getLines(_point);
  }

  void _clear() {
    setState(() {
      _point = _Controller.clearPoints();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Map Home Screen'),
        centerTitle: true,
      ),

      body: Column(
        children: [
          Text(_TapStatus),

          Text(_explain()),
          Text(
            _isServicesOn
                ? 'Location service is ON'
                : 'Location service is OFF',
          ),
          Text(
            _canShowBlueDot
                ? 'Blue dot permission is granted'
                : 'Blue dot permission is not granted',
          ),

          Expanded(
            child: GoogleMap(
              onTap: _addPoint,
              polylines: _lines(),
              initialCameraPosition: Places.openingCamera,
              markers: {
                ..._markers(),

                if (_me != null)
                  Marker(
                    markerId: MarkerId('Me'),
                    position: _me!,
                    infoWindow: InfoWindow(title: 'Me Here'),
                  ),
              },
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _mapController = controller;
                debugPrint('Map Controller Created: $_mapController');
              },

              zoomGesturesEnabled: _isZoom,
              scrollGesturesEnabled: _isScroll,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15),
            child: Wrap(
              spacing: 15,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    debugPrint('Button Clicked');
                    debugPrint('Controller: $_mapController');

                    await _Controller.gotoGlorySchool(_mapController);
                  },
                  child: const Text('Goto Glory School'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    debugPrint('Button Clicked');
                    debugPrint('Controller: $_mapController');

                    await _Controller.zoomIn(_mapController);
                  },
                  child: const Text('Zoom In'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    debugPrint('Button Clicked');
                    debugPrint('Controller: $_mapController');

                    await _Controller.zoomOut(_mapController);
                  },
                  child: const Text('Zoom Out'),
                ),

                ElevatedButton(
                  onPressed: () async {
                    await _Controller.resetMap(
                      _mapController,
                      const CameraPosition(
                        target: LatLng(23.8103, 90.4125),
                        zoom: 12,
                      ),
                    );
                  },
                  child: const Text('Reset Map'),
                ),

                ElevatedButton(
                  onPressed: _busy ? null : _findMe,
                  child: Text(_busy ? 'Finding me....' : 'Find me'),
                ),

                FilterChip(
                  label: Text('Scroll'),
                  selected: _isScroll,
                  onSelected: (bool value) {
                    setState(() {
                      _isScroll = value;
                    });
                  },
                ),

                FilterChip(
                  label: Text('Zoom'),
                  selected: _isZoom,
                  onSelected: (bool value) {
                    setState(() {
                      _isZoom = value;
                    });
                  },
                ),

                ElevatedButton(
                  onPressed: _ask,
                  child: const Text('Request Permission'),
                ),
                ElevatedButton(
                  onPressed: _refresh,
                  child: const Text('Refresh Status'),
                ),

                ElevatedButton(
                  onPressed: _loadCampusRoute,
                  child: const Text('Load Campus Route'),
                ),
                ElevatedButton(
                  onPressed: _clear,
                  child: const Text('Clear Route'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
