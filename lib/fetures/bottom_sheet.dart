import 'package:flutter/material.dart';
import 'package:pretty_animated_buttons/pretty_animated_buttons.dart';
import 'package:pretty_animated_buttons/widgets/pretty_slide_up_button.dart';
import 'package:yandex_maps_mapkit/src/mapkit/map/map_window.dart';

import '../map_activity/map_funcs_and_things.dart';

final _searchSessionStart = TextEditingController();
final _searchSessionEnd = TextEditingController();
bool toggleType = true;

class BottomSheetCustom extends StatefulWidget {
  const BottomSheetCustom({super.key, required this.mapWindow});
  final MapWindow? mapWindow;
  @override
  State<BottomSheetCustom> createState() => _BottomSheetCustomState();
}

class _BottomSheetCustomState extends State<BottomSheetCustom> {
  @override
  Widget build(BuildContext context) {
    final mapFuncs = YanMapAct(mapWindow: widget.mapWindow, searchChanger: toggleType, changer: true, pointList: []);
    final QueryWidth = MediaQuery.of(context).size.width;
    final QueryHeight = MediaQuery.of(context).size.height;
    return DraggableScrollableSheet(
      initialChildSize: 0.035, // Начальный размер
      minChildSize: 0.035, // Минимальный размер
      maxChildSize: 0.55, // Максимальный размер
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 5,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    PrettySlideUpButton(
                        bgColor: Colors.white10,
                        firstChild: Text(
                          'От вас до точки',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        secondChild: Text(
                          'От точки до точки',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          setState(() {
                            toggleType = !toggleType;
                            mapFuncs.changerSearchFuncs();
                          });
                        }),
                    SizedBox(height: 5),
                    Container(
                      margin: EdgeInsets.fromLTRB((QueryWidth / 10) / 2, 0, (QueryWidth / 10) / 2, 0),
                      child: TextField(
                        maxLength: 128,
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(),
                          hoverColor: Colors.black,
                          labelText: 'конечный адресс',
                          labelStyle: TextStyle(color: Colors.black87),
                          border: UnderlineInputBorder(),
                          disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey, width: 1, style: BorderStyle.solid)),
                        ),
                        controller: _searchSessionEnd,
                      ),
                    ),
                    SizedBox(height: 5),
                    TweenAnimationBuilder(
                      tween: Tween(
                        begin: toggleType ? QueryWidth / 10 : QueryWidth + 1,
                        end: toggleType ? QueryWidth + 1 : QueryWidth / 10,
                      ),
                      duration: Duration(milliseconds: 500),
                      builder: (BuildContext contextW, double value1, _) {
                        return Container(
                          margin: EdgeInsets.fromLTRB(value1 / 2, 0, value1 / 2, 0),
                          child: TextField(
                            maxLength: 128,
                            decoration: InputDecoration(
                              enabledBorder: UnderlineInputBorder(),
                              hoverColor: Colors.black,
                              labelText: 'Начальный адресс',
                              labelStyle: TextStyle(color: Colors.black87),
                              border: UnderlineInputBorder(),
                              disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(5), borderSide: BorderSide(color: Colors.grey, width: 1, style: BorderStyle.solid)),
                            ),
                            controller: _searchSessionStart,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PrettyWaveButton(
                            child: Text(
                              "Построить",
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              widget.mapWindow!.map.mapObjects.clear();
                              if (toggleType == false) {
                                mapFuncs.searchAddressAndAddPlacemark(_searchSessionEnd.text.trim(), widget.mapWindow, context);
                                mapFuncs.searchAddressAndAddPlacemark(_searchSessionStart.text.trim(), widget.mapWindow, context);
                              } else {
                                mapFuncs.searchAddressAndAddPlacemark(_searchSessionEnd.text.trim(), widget.mapWindow, context);
                              }
                            })
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
