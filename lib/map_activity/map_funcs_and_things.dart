import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:petrolchik/fetures/polyline_settings.dart';
import 'package:petrolchik/geolocation/geolocator_logic.dart';
import 'package:yandex_maps_mapkit/directions.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/runtime.dart' as rt;
import 'package:yandex_maps_mapkit/search.dart';
import 'package:yandex_maps_mapkit/image.dart' as ip;
import 'package:collection/collection.dart';

class YanMapAct {
  MapWindow? mapWindow;
  bool changer;
  bool searchChanger;
  List<RequestPoint> pointList;
  BuildContext context;
  YanMapAct({required this.changer, required this.searchChanger, required this.mapWindow, required this.pointList, required this.context});

  final drivingOptions = DrivingOptions(routesCount: 1);
  final drivingRouter = DirectionsFactory.instance.createDrivingRouter(DrivingRouterType.Combined);
  final vehicleOptions = DrivingVehicleOptions();
  var _drivingRoutes = <DrivingRoute>[];
  List<DrivingRoute> get drivingRoutes => _drivingRoutes;
  double routeLenght = 0;
  set drivingRoutes(List<DrivingRoute> newValue) {
    _drivingRoutes = newValue;
    _onDrivingRoutesUpdated();
  }

  double? expenditure;
  Position? pos;
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
    }
    drivingRoutes = newroutes;
    _onDrivingRoutesUpdated();
  }, onDrivingRoutesError: (rt.Error error) {
    print("Ошибка");
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
    }
  }

  void onSearchResponse(SearchResponse response) {
    pointList.clear();
    geomyloc();
    final point = response.collection.children.first.asGeoObject()?.geometry.firstOrNull!.asPoint()!;
    if (changer == true) {
      if (searchChanger == false) {
        if (point != null) {
          final placemark = mapWindow!.map.mapObjects.addPlacemark()
            ..geometry = point
            ..setIcon(ip.ImageProvider.fromImageProvider(const AssetImage("assets/image_asset/3.0x/pin_red.png")));
          pointList.add(RequestPoint(point, RequestPointType.Waypoint, null, null));
          setroute(true);
        } else {}
      } else {
        if (point != null) {
          if (pos != null) {
            final placemark = mapWindow!.map.mapObjects.addPlacemark()
              ..geometry = point
              ..setIcon(ip.ImageProvider.fromImageProvider(const AssetImage("assets/image_asset/3.0x/pin_red.png")));
            pointList.add(RequestPoint(point, RequestPointType.Waypoint, null, null));
            final point2 = Point(latitude: pos!.latitude, longitude: pos!.longitude);
            final placemark2 = mapWindow!.map.mapObjects.addPlacemark()
              ..geometry = point2
              ..setIcon(ip.ImageProvider.fromImageProvider(const AssetImage("assets/image_asset/3.0x/pin_red.png")));
            pointList.add(RequestPoint(point2, RequestPointType.Waypoint, null, null));
            setroute(true);
          }
        } else {}
      }
    } else {
      if (point != null) {
        mapWindow!.map.move(CameraPosition(point, zoom: 18, azimuth: mapWindow!.map.cameraPosition.azimuth, tilt: 0));
      } else {}
    }
  }

  void setroute(bool typerouting) {
    if (pointList.length >= 2) {
      final drivingSession = drivingRouter.requestRoutes(
        drivingOptions,
        vehicleOptions,
        drivingRoutListener,
        points: pointList,
      );
    }
    pointList.clear();
  }

  void onSearchError(rt.Error error) {
    print("Ошибка при поиске адреса:${error.toString()} ");
  }

  void geomyloc() async {
    pos = await GeoLogic().determinePosition();
  }

  void setRoutOnMap(DrivingRoute routeGeometry) {
    final polyline = mapWindow!.map.mapObjects.addPolylineWithGeometry(routeGeometry.geometry);
    polyline.applyMainRouteStyle();

    routeLenght = routeGeometry.metadata.weight.distance.value / 1000;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Container(
      height: 60,
      child: Column(
        children: [Text("Будет израсходовано на путь : " + (routeLenght * ((expenditure!) / 100)).toString() + " литров"), Text("Длинна пути : " + routeLenght.toString() + "км")],
      ),
    )));
  }

  void setEx(double Ex) {
    expenditure = Ex;
  }

  void _onDrivingRoutesUpdated() {
    if (drivingRoutes.isEmpty) {
      return;
    }

    drivingRoutes.forEachIndexed((index, route) {
      setRoutOnMap(route);
    });
  }
}
