import 'package:cached_network_image/cached_network_image.dart';
import 'package:degvielascenas/reusables/GasPriceCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:url_launcher/url_launcher.dart';

class GasStation extends StatelessWidget {
  var _gasStation;
  var rng = new Random();
  List<Widget> cards = new List();
  //var _waze = 'https://www.waze.com/livemap/directions?latlng=${_gasStation.lat.toString()}%2C${_gasStation.lon.toString()}&navigate=yes&q=Circle%20K%20Eksporta&zoom=17';
  var _waze;
  var _googlemaps;
  var _yandex;
  var _openStreetMap;
  GasStation(var gasStation) {
    this._gasStation = gasStation;
    _waze =
        'https://www.waze.com/livemap/directions?latlng=${_gasStation.lat.toString()}%2C${_gasStation.lon.toString()}&navigate=yes&zoom=17';
    _googlemaps =
        'https://www.google.com/maps/dir/?api=1&destination=${_gasStation.lat.toString()},${_gasStation.lon.toString()}&query=${_gasStation.lat.toString()},${_gasStation.lon.toString()}';
    _yandex =
        'https://yandex.ru/maps/?ll=${_gasStation.lat.toString()}%2C${_gasStation.lon.toString()}&mode=routes&rtext=~${_gasStation.lat.toString()}%2C${_gasStation.lon.toString()}&rtt=auto&ruri=~&z=16';
    _openStreetMap =
        'https://www.openstreetmap.org/?mlat=${_gasStation.lat.toString()}&mlon=${_gasStation.lon.toString()}#map=12/${_gasStation.lat.toString()}/${_gasStation.lon.toString()}';
  }

  _launchURL(var url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    for (int i = 0; i < _gasStation.gasList.length; i++) {
      cards.add(GasPriceCard(
        price: _gasStation.gasList[i].price.toString(),
        gasType: _gasStation.gasList[i],
      ));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Stack(
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

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: FloatingActionButton(
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
                  SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Text(_gasStation.gasStationName , style: TextStyle(fontSize: 25),),
                      SizedBox(height: 5,),
                      Text(_gasStation.location, style: TextStyle(fontSize: 25,),),
                      SizedBox(height: 5,),
                      Row(children: [
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
                      ),
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
