import 'dart:async';
import 'package:petrolchik/camera_manager/camer_position_listiner.dart';
import 'package:petrolchik/geolocation/location_listener.dart';
import 'package:petrolchik/utils/utils.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';

final class CameraManager {
  final MapWindow _mapWindow;
  final LocationManager _locationManager;

  final _cameraPosition = BehaviorSubject<CameraPosition>();

  late final _cameraPositionListener = CameraPositionListenerImpl((_, cameraPosition, __, ___) => _cameraPosition.add(cameraPosition));

  late final _locationListener = LocationListenerImpl(
    onLocationUpdate: (location) {
      _location = location;

      if (_isLocationUnknown) {
        _isLocationUnknown = false;
        moveCameraToUserLocation();
      }
    },
    onLocationStatusUpdate: (locationStatus) {},
  );

  Location? _location;
  var _isLocationUnknown = true;

  static const _mapDefaultZoom = 15.0;

  CameraManager(
    this._mapWindow,
    this._locationManager,
  );

  Stream<CameraPosition> get cameraPosition => _cameraPosition;

  void moveCameraToUserLocation() {
    _location?.let((location) {
      final map = _mapWindow.map;

      final cameraPosition = map.cameraPosition;
      final newZoom = cameraPosition.zoom < _mapDefaultZoom ? _mapDefaultZoom : cameraPosition.zoom;

      final newCameraPosition = CameraPosition(
        location.position,
        zoom: newZoom,
        azimuth: cameraPosition.azimuth,
        tilt: 0.0,
      );

      map.move(
        newCameraPosition,
      );
    });
  }

  void start() {
    _stop();
    _mapWindow.map.addCameraListener(_cameraPositionListener);

    _locationManager.subscribeForLocationUpdates(
      LocationFilteringMode.On,
      LocationPurpose.General,
      _locationListener,
      desiredAccuracy: 0.0,
      minTime: 1000,
      minDistance: 0,
      allowUseInBackground: false,
    );
  }

  void dispose() {
    _stop();
    _cameraPosition.close();
  }

  void _stop() {
    _locationManager.unsubscribe(_locationListener);
    _mapWindow.map.removeCameraListener(_cameraPositionListener);
  }
}
