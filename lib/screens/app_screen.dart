import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:petrolchik/bloc/app_bloc.dart';
import 'package:petrolchik/camera_manager/camer_manager.dart';
import 'package:petrolchik/fetures/bottom_sheet.dart';
import 'package:petrolchik/map_activity/map_funcs_and_things.dart';
import 'package:petrolchik/screens/settings_screen.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/mapkit_factory.dart';
import 'package:yandex_maps_mapkit/yandex_map.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

final _AppBloc = AppBloc();
MapWindow? _mapWindow;
var bottom_sheet = 0.0;
//map things

late final _locationManager = mapkit.createLocationManager();
late final UserLocationLayer _userLocationLayer;
late final CameraManager _cameraManager;
final _searchAddres = TextEditingController();
late final Position _GeoView;
late final mapFuncs;

class _AppScreenState extends State<AppScreen> implements UserLocationObjectListener {
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final QueryWidth = MediaQuery.of(context).size.width;
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
            onTap: () {
              mapFuncs.searchAddressAndAddPlacemark(_searchAddres.text.trim(), _mapWindow, context);
            },
            child: Icon(Icons.search),
          ),
          Padding(padding: EdgeInsets.fromLTRB(QueryWidth / 40, 0, 0, 0)),
        ],
        centerTitle: true,
        title: TextField(
          controller: _searchAddres,
        ),
      ),
      body: BlocBuilder(
          bloc: _AppBloc,
          builder: (context, state) {
            if (true) {
              return Stack(children: [
                YandexMap(onMapCreated: (mapwindow) {
                  mapkit.onStart();
                  setState(() {
                    _mapWindow = mapwindow;
                    mapFuncs = YanMapAct(mapWindow: _mapWindow, searchChanger: true, changer: false, pointList: []);
                  });
                  _userLocationLayer = mapkit.createUserLocationLayer(mapwindow)
                    ..headingEnabled
                    ..setVisible(true)
                    ..setObjectListener(this);
                  _cameraManager = CameraManager(mapwindow, _locationManager)..start();
                }),
                BottomSheetCustom(
                  mapWindow: _mapWindow,
                )
              ]);
            }
          }),
    );
  }

  @override
  void onObjectAdded(UserLocationView view) {
    // TODO: implement onObjectAdded
  }

  @override
  void onObjectRemoved(UserLocationView view) {
    // TODO: implement onObjectRemoved
  }

  @override
  void onObjectUpdated(UserLocationView view, ObjectEvent event) {
    // TODO: implement onObjectUpdated
  }
}
