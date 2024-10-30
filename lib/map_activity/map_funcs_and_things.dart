// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:petrolchik/fetures/polyline_settings.dart';
import 'package:petrolchik/geolocation/geolocator_logic.dart';
import 'package:yandex_maps_mapkit/directions.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/mapkit_factory.dart';
import 'package:yandex_maps_mapkit/runtime.dart' as rt;
import 'package:yandex_maps_mapkit/search.dart';
import 'package:yandex_maps_mapkit/image.dart' as ip;
import 'package:collection/collection.dart';

class YanMapAct {
  MapWindow? mapWindow;
  bool changer;
  bool searchChanger;
  List<RequestPoint> pointList;
  YanMapAct({required this.changer, required this.searchChanger, required this.mapWindow, required this.pointList});

  final drivingOptions = DrivingOptions(routesCount: 1);
  final drivingRouter = DirectionsFactory.instance.createDrivingRouter(DrivingRouterType.Combined);
  final vehicleOptions = DrivingVehicleOptions();
  var _drivingRoutes = <DrivingRoute>[];
  List<DrivingRoute> get drivingRoutes => _drivingRoutes;
  set drivingRoutes(List<DrivingRoute> newValue) {
    _drivingRoutes = newValue;
    _onDrivingRoutesUpdated();
  }

  void changerSearchFuncs() {
    searchChanger = !searchChanger;
  }

  final searchManager = SearchFactory.instance.createSearchManager(SearchManagerType.Combined);
  final searchOptions = SearchOptions(
    searchTypes: SearchType.Geo,
    resultPageSize: 1,
  );

  late final drivingRoutListener = DrivingSessionRouteListener(onDrivingRoutes: (newroutes) {
    if (newroutes.isEmpty == true) {
      final context = BuildContext;
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Не получилось построить путь')),
      );
    }
    drivingRoutes = newroutes;
    _onDrivingRoutesUpdated();
  }, onDrivingRoutesError: (rt.Error error) {
    print("Ошибка");
    final context = BuildContext;
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      SnackBar(content: Text('Произошла ошибка при построении маршрута')),
    );
  });

  Future<void> searchAddressAndAddPlacemark(
    String address,
    MapWindow? _mapController,
    BuildContext context,
  ) async {
    if (address.isEmpty) return;
    final listener = SearchSessionSearchListener(onSearchResponse: onSearchResponse, onSearchError: onSearchError);
    try {
      searchManager.submit(VisibleRegionUtils.toPolygon(_mapController!.map.visibleRegion), searchOptions, listener, text: address);
    } catch (e) {
      print("Ошибка при поиске адреса: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Произошла ошибка при поиске адреса')),
      );
    }
  }

  void onSearchResponse(SearchResponse response) {
    final context = BuildContext;
    final point = response.collection.children.first.asGeoObject()?.geometry.firstOrNull!.asPoint()!;
    if (changer == true) {
      if (searchChanger == false) {
        if (point != null) {
          final placemark = mapWindow!.map.mapObjects.addPlacemark()
            ..geometry = point
            ..setIcon(ip.ImageProvider.fromImageProvider(const AssetImage("assets/image_asset/3.0x/pin_red.png")));
          pointList.add(RequestPoint(point, RequestPointType.Waypoint, null, null));
          setroute(true);
        } else {
          ScaffoldMessenger.of(context as BuildContext).showSnackBar(
            SnackBar(content: Text('Произошла ошибка при поиске адреса')),
          );
        }
      } else {
        if (point != null) {
          final placemark = mapWindow!.map.mapObjects.addPlacemark()
            ..geometry = point
            ..setIcon(ip.ImageProvider.fromImageProvider(const AssetImage("assets/image_asset/3.0x/pin_red.png")));
          pointList.add(RequestPoint(point, RequestPointType.Waypoint, null, null));
          //add logic of getting user loc
        } else {
          ScaffoldMessenger.of(context as BuildContext).showSnackBar(
            SnackBar(content: Text('Произошла ошибка при поиске адреса')),
          );
        }
      }
    } else {
      if (point != null) {
        mapWindow!.map.move(CameraPosition(point, zoom: 18, azimuth: mapWindow!.map.cameraPosition.azimuth, tilt: 0));
      } else {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(content: Text('Произошла ошибка при поиске адреса')),
        );
      }
    }
  }

  void setroute(bool typerouting) {
    if (pointList.length == 2) {
      final drivingSession = drivingRouter.requestRoutes(
        drivingOptions,
        vehicleOptions,
        drivingRoutListener,
        points: pointList,
      );
      pointList.clear();
    }
  }

  void onSearchError(rt.Error error) {
    print("Ошибка при поиске адреса:${error.toString()} ");
    final context = BuildContext;
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      SnackBar(content: Text('Произошла ошибка при поиске адреса')),
    );
  }

  void setRoutOnMap(Polyline routeGeometry) {
    final polyline = mapWindow!.map.mapObjects.addPolylineWithGeometry(routeGeometry);
    polyline.applyMainRouteStyle();
  }

  void _onDrivingRoutesUpdated() {
    if (drivingRoutes.isEmpty) {
      return;
    }

    drivingRoutes.forEachIndexed((index, route) {
      setRoutOnMap(route.geometry);
    });
  }
}
