import 'package:cached_network_image/cached_network_image.dart';
import 'package:degvielascenas/reusables/GasPriceCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:map_launcher/map_launcher.dart';

class GasStation extends StatelessWidget {
  var _gasStation;
  var rng = new Random();
  List<Widget> cards = new List();

  var availableApps;

  GasStation(var gasStation) {
    this._gasStation = gasStation;
  }

  _getMaps() async {
    availableApps = await MapLauncher.installedMaps;
    print(availableApps);
  }

  @override
  Widget build(BuildContext context) {
    _getMaps();

    for (int i = 0; i < _gasStation.gasList.length; i++) {
      cards.add(GasPriceCard(
        price: _gasStation.gasList[i].price.toString(),
        gasType: _gasStation.gasList[i],
      ));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Stack(
                children: [
                  AspectRatio(
                    aspectRatio: 650 / 216,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.fitWidth,
                          alignment: FractionalOffset.topCenter,
                          image: NetworkImage(
                            'https://gasprices.dna.lv/imagetemp'
                            '/?lat=${_gasStation.lat.toString()}&lon=${_gasStation.lon.toString()}',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: FloatingActionButton(
                              heroTag: 1,
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Icon(CupertinoIcons.back),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 15, 0, 0),
                            child: Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(_gasStation.image),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: FloatingActionButton(
                      child: Icon(MdiIcons.car),
                      onPressed: () async {
                        List<Widget> _butons = new List();
                        for (int i = 0; i < availableApps.length; i++) {
                          _butons.add(
                            Container(
                              child: Card(
                                child: FlatButton(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.gps_fixed),
                                      Text(availableApps[i].mapName.toString())
                                    ],
                                  ),
                                  onPressed: (){
                                    availableApps[i].showMarker(
                                      coords: Coords(double.parse(_gasStation.lat), double.parse(_gasStation.lon)),
                                      title: _gasStation.gasStationName,
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        }
                        Alert(
                            context: context,
                            title: "Izvēlies aplikāciju",
                            content: SingleChildScrollView(
                              child: Column(
                                children: _butons,
                              ),
                            ),
                            buttons: [
                              DialogButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Atpakaļ",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              )
                            ]).show();

                        //   await availableApps.first.showMarker(
                        //    coords: Coords(double.parse(_gasStation.lat), double.parse(_gasStation.lon)),
                        //    title: _gasStation.gasStationName,
                        //   );
                      },
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                          child: Text(
                        _gasStation.gasStationName,
                        style: TextStyle(fontSize: 25),
                      )),
                      SizedBox(
                        height: 5,
                      ),
                      Center(
                          child: Text(
                        _gasStation.location,
                        style: TextStyle(
                          fontSize: 25,
                        ),
                      )),
                      SizedBox(
                        height: 5,
                      ),
                      /*    Row(children: [
                          Padding(
                            padding: EdgeInsets.all(10),
                          ),
                          Expanded(
                            flex: 1,
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                _launchURL(_waze);
                              },
                              child: Image.asset('assets/waze.png'),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(5),
                          ),
                          Expanded(
                            flex: 1,
                            child: FlatButton(
                              padding: EdgeInsets.all(0),
                              onPressed: () {
                                _launchURL(_googlemaps);
                              },
                              child: Image.asset('assets/googlemaps.jpg'),
                            ),
                          ),
                        ]),
                        Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            Expanded(
                              flex: 1,
                              child: FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  _launchURL(_yandex);
                                },
                                child: Image.asset('assets/yandex.jpg'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                            ),
                            Expanded(
                              flex: 1,
                              child: FlatButton(
                                padding: EdgeInsets.all(0),
                                onPressed: () {
                                  _launchURL(_openStreetMap);
                                },
                                child: Image.asset('assets/openstreetmap.jpg'),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                          ],
                        ),*/
                    ],
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  ListView.builder(
                    itemCount: cards.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) => cards[index],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class popUpButton extends StatelessWidget {
  var text;

  popUpButton({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      width: 10,
      child: Row(
        children: [
          Icon(MdiIcons.waze),
          Text(text),
        ],
      ),
    );
  }
}
