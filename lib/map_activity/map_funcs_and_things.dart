import 'package:flutter/material.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/runtime.dart' as rt;
import 'package:yandex_maps_mapkit/search.dart';
import 'package:yandex_maps_mapkit/image.dart' as ip;

class YanMapAct {
  MapWindow? mapWindow;
  YanMapAct({
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
    //add point adding logic
    final context = BuildContext;
    final point = response.collection.children.first.asGeoObject()?.geometry.firstOrNull!.asPoint()!;
    if (point != null) {
      final placemark = mapWindow!.map.mapObjects.addPlacemark()
        ..geometry = point
        ..setIcon(ip.ImageProvider.fromImageProvider(const AssetImage("petrolchik/assets/image_asset/clipart3004129.png")));
      placemark..setIconStyle(IconStyle(scale: 0.2));
    } else {
      ScaffoldMessenger.of(context as BuildContext).showSnackBar(
        SnackBar(content: Text('Произошла ошибка при поиске адреса')),
      );
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
