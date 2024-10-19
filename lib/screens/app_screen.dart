import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:petrolchik/bloc/app_bloc.dart';
import 'package:yandex_maps_mapkit/mapkit.dart';
import 'package:yandex_maps_mapkit/yandex_map.dart';

class AppScreen extends StatefulWidget {
  const AppScreen({super.key});

  @override
  State<AppScreen> createState() => _AppScreenState();
}

final _AppBloc = AppBloc();
MapWindow? _mapWindow;

class _AppScreenState extends State<AppScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder(
          bloc: _AppBloc,
          builder: (context, state) {
            if (true) {
              return YandexMap(onMapCreated: (mapwindow) {
                _mapWindow = mapwindow;
              });
            }
          }),
    );
  }
}
