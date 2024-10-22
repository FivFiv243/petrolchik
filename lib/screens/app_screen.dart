import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:petrolchik/bloc/app_bloc.dart';
import 'package:petrolchik/fetures/bottom_sheet.dart';
import 'package:petrolchik/geolocator_act.dart/geolocator_logic.dart';
import 'package:petrolchik/screens/settings_screen.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/mapkit_factory.dart';
import 'package:yandex_maps_mapkit/src/bindings/image/image_provider.dart' as ip;
import 'package:yandex_maps_mapkit/yandex_map.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

final _AppBloc = AppBloc();
MapWindow? _mapWindow;
late AnimationController _controller;
var bottom_sheet = 0.0;
bool check = false;
//Text editing controllers
final _searchAddres = TextEditingController();
Position? _position;

class _AppScreenState extends State<AppScreen> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final QueryWidth = MediaQuery.of(context).size.width;
    final QueryHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context) {
              return SettingsScreen();
            }));
          },
          child: Icon(Icons.settings),
        ),
        actions: [
          Padding(padding: EdgeInsets.fromLTRB(QueryWidth / 100, 0, 0, 0)),
          InkWell(
            onTap: () {},
            child: Icon(Icons.search),
          ),
          Padding(padding: EdgeInsets.fromLTRB(QueryWidth / 40, 0, 0, 0)),
        ],
        centerTitle: true,
        title: TextField(),
      ),
      body: BlocBuilder(
          bloc: _AppBloc,
          builder: (context, state) {
            if (true) {
              return Stack(children: [
                YandexMap(onMapCreated: (mapwindow) {
                  mapkit.onStart();
                  _mapWindow = mapwindow;
                  if (check == false) {
                    StreamSubscription<Position> positionStream = Geolocator.getPositionStream(locationSettings: GeoLogic().locationSettings).listen((Position? position) {
                      setState(() {
                        _position = position;
                      });
                      final placemark = mapwindow.map.mapObjects.addPlacemark()
                        ..geometry = Point(latitude: _position!.latitude, longitude: _position!.longitude)
                        ..setIcon(ip.ImageProvider.fromImageProvider(AssetImage("assets/image_asset/pngwing.png")));
                      _mapWindow?.map.move(CameraPosition(Point(latitude: _position!.latitude, longitude: _position!.longitude), zoom: 0, azimuth: 0, tilt: 0));
                      print(position == null ? '\n\nStream Pos Unknown\n\n' : '\n\n' + '${position.latitude.toString()}, ${position.longitude.toString()}' + '\n\n');
                      print(_position == null ? '\n\nUser Unknown\n\n' : '\n\n' + '${_position!.latitude.toString()}, ${_position!.longitude.toString()}' + '\n\n');
                      check = true;
                    });
                  }
                  mapwindow.map.move(CameraPosition(Point(latitude: 21, longitude: 22.084), zoom: 0, azimuth: 0, tilt: 0));
                }),
                BottomSheetCustom()
              ]);
            }
          }),
    );
  }
}
