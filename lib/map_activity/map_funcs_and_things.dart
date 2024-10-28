import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/runtime.dart' as rt;
import 'package:yandex_maps_mapkit/search.dart';
import 'package:yandex_maps_mapkit/image.dart' as ip;

class YanMapAct {
  MapWindow? mapWindow;
  bool changer;
  YanMapAct({
    required this.changer,
    required this.mapWindow,
  });

  final searchManager = SearchFactory.instance.createSearchManager(SearchManagerType.Combined);

  final searchOptions = SearchOptions(
    searchTypes: SearchType.Geo,
    resultPageSize: 1,
  );

  Future<void> searchAddressAndAddPlacemark(String address, MapWindow? _mapController, BuildContext context) async {
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
      //add point adding logic
      if (point != null) {
        final placemark = mapWindow!.map.mapObjects.addPlacemark()
          ..geometry = point
          ..setIcon(ip.ImageProvider.fromImageProvider(const AssetImage("assets/image_asset/3.0x/pin_red.png")));
      } else {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(content: Text('Произошла ошибка при поиске адреса')),
        );
      }
    } else {
      if (point != null) {
        mapWindow!.map.move(CameraPosition(point, zoom: 10, azimuth: mapWindow!.map.cameraPosition.azimuth, tilt: 0));
      } else {
        ScaffoldMessenger.of(context as BuildContext).showSnackBar(
          SnackBar(content: Text('Произошла ошибка при поиске адреса')),
        );
      }
    }
  }

  void onSearchError(rt.Error error) {
    print("Ошибка при поиске адреса:${error.toString()} ");
    final context = BuildContext;
    ScaffoldMessenger.of(context as BuildContext).showSnackBar(
      SnackBar(content: Text('Произошла ошибка при поиске адреса')),
    );
  }
}
