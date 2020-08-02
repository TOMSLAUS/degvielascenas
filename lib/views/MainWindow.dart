import 'dart:async';
import 'dart:ffi';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../reusables/GasCard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:degvielascenas/Params.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:dropdown_search/dropdown_search.dart';

//##todo pull to refresh
class MainWindow extends StatefulWidget {
  @override
  _MainWindowState createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<LiquidPullToRefreshState> _refreshIndicatorKey =
  GlobalKey<LiquidPullToRefreshState>();
  Params params = new Params();
  String _valueCityButton;
  String _valueGasStationButton;
  String _valueGasTypeButton;
  var stations;
  var jsondata;
  List<Widget> _cards = new List();
  String lat;
  String lon;
  List<DropdownMenuItem<String>> cityButtons;
  List<DropdownMenuItem<String>> gasStationButtons;
  List<DropdownMenuItem<String>> gasTypeButtons;
  int pogas;
  int pogas2;

  @override
  initState() {
    getEverything();
    super.initState();
  }


  Future _refreshCards(){

    if(_citiesDown().value != null || _gasTypeDown().value != null || _gasStationDown().value != null){
      params.getStations(lat, lon);
      _cards.clear();

      for (stations in jsondata) {
        setState(() {
          _cards.add(GasCard(stations));
        });
      }

    }
    else {
      getLocation();
      getStations(lat, lon);
    }

    final Completer<void> completer = Completer<void>();
    completer.complete();
    setState(() {});
    return completer.future;
  }

  DropdownButton _citiesDown() => DropdownButton<String>(
        isExpanded: true,
        hint: DropdownMenuItem(
          child: Text('Visas pilsētas'),
          value: '',
        ),
        items: cityButtons,
        onChanged: (value) async {
          params.city = value;
          jsondata = await params.getStations(lat, lon);
          setState(() {
            _valueCityButton = value;
            _cards.clear();
            for (stations in jsondata) {
              setState(() {
                _cards.add(GasCard(stations));
              });
            }
          });
        },
        value: _valueCityButton,
      );

  DropdownButton _gasStationDown() => DropdownButton<String>(
        isExpanded: true,
        hint: DropdownMenuItem(
          child: Text('Visi zīmoli'),
          value: '',
        ),
        items: gasStationButtons,
        onChanged: (value) async {
          params.brand = value;
          jsondata = await params.getStations(lat, lon);
          setState(() {
            _valueGasStationButton = value;
            _cards.clear();
            for (stations in jsondata) {
              setState(() {
                _cards.add(GasCard(stations));
              });
            }
          });
        },
        value: _valueGasStationButton,
      );

  DropdownButton _gasTypeDown() => DropdownButton<String>(
        isExpanded: true,
        hint: DropdownMenuItem(
          child: Text('Visi degvielas veidi'),
          value: '',
        ),
        items: gasTypeButtons,
        onChanged: (value) async {
          params.gasType = value;
          jsondata = await params.getStations(lat, lon);
          setState(() {
            _valueGasTypeButton = value;
            _cards.clear();
            for (stations in jsondata) {
              setState(() {
                _cards.add(GasCard(stations));
              });
            }
          });
        },
        value: _valueGasTypeButton,
      );

//##todo pievienot meklēšanu
  List<DropdownMenuItem<String>> getCities(List city) {
    List<DropdownMenuItem<String>> buttonarr = new List();
    buttonarr.add(
      DropdownMenuItem(
        child: Text('Visas pilsētas'),
        value: '',
      ),
    );
    buttonarr.add(
      DropdownMenuItem(
        child: Text('Tuvākie vispirms (kārtot pēc cenas)'),
        value: 'byprice',
      ),
    );
    for (int i = 0; i < city.length; i++) {
      buttonarr.add(
        DropdownMenuItem(
            child: Text(
              city[i],
            ),
            value: city[i]),
      );
    }
    return buttonarr;
  }

  List<DropdownMenuItem<String>> getGasStations(List gasStations) {
    List<DropdownMenuItem<String>> buttonarr = new List();
    buttonarr.add(
      DropdownMenuItem(
        child: Text('Visi zīmoli'),
        value: '',
      ),
    );
    for (int i = 0; i < gasStations.length; i++) {
      buttonarr.add(
        DropdownMenuItem(
            child: Text(
              gasStations[i],
            ),
            value: gasStations[i]),
      );
    }
    return buttonarr;
  }

  List<DropdownMenuItem<String>> getGasType(List gasType) {
    List<DropdownMenuItem<String>> buttonarr = new List();
    buttonarr.add(
      DropdownMenuItem(
        child: Text('Visi degvielas veidi'),
        value: '',
      ),
    );
    for (int i = 0; i < gasType.length; i++) {
      buttonarr.add(
        DropdownMenuItem(
            child: Text(
              gasType[i],
            ),
            value: gasType[i]),
      );
    }
    return buttonarr;
  }

  void getEverything() async {
    await getLocation();
    cityButtons = getCities(await getCityButtons());
    gasTypeButtons = getGasType(await getGasTypeButtons());
    gasStationButtons = getGasStations(await getGasStationButtons());
    stations = getStations(lat, lon);
  }

  void getLocation() async {
    var status = await Permission.location.request();

    if (status.isGranted == true) {
      var position = await Geolocator()
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      lon = position.longitude.toString();
      lat = position.latitude.toString();
    } else {
      var url = 'https://api6.ipify.org?format=json';
      var response = await http.get(url);
      print(response.statusCode);
      Map data = jsonDecode(response.body);
      var cities = data['ip'];
      String ipAddress = cities;
      print(ipAddress);

      var url2 = 'https://sys.airtel.lv/ip2country/$ipAddress/?full';
      var response2 = await http.get(url2);
      print(response2.statusCode);
      Map data2 = jsonDecode(response2.body);
      lat = data2['lat'];
      lon = data2['lon'];
    }
  }

//##todo sakārtot šo
  getCityButtons() async {
    var url = 'https://gasprices.dna.lv/api/1/?method=nstuff';
    var response = await http.post(url);
    print(response.statusCode);
    Map data = jsonDecode(response.body);
    List cities = data['cities']['LV'];
    return cities;
  }

  getGasStationButtons() async {
    var url = 'https://gasprices.dna.lv/api/1/?method=nstuff';
    var response = await http.post(url);
    print(response.statusCode);
    Map data = jsonDecode(response.body);
    var brands = data['brands'];
    List stations = brands.keys.toList();
    return stations;
  }

  getGasTypeButtons() async {
    var url = 'https://gasprices.dna.lv/api/1/?method=nstuff';
    var response = await http.post(url);
    print(response.statusCode);
    Map data = jsonDecode(response.body);
    Map cities = data['fuel'];
    List<String> gasType = cities.keys.toList();
    return gasType;
  }

  getStations(var lat, var lon) async {
    var url = 'https://gasprices.dna.lv/other/filterstations/?output=json';
    var body = {'lat': lat.toString(), 'lon': lon.toString()};
    var response = await http.post(url, body: body);
    var jsondata = jsonDecode(response.body);
    print(response.statusCode);
    for (stations in jsondata) {
      setState(() {
        _cards.add(GasCard(stations));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(
      child: OrientationBuilder(builder: (context, orientation) {
        return Column(
          children: <Widget>[
            Expanded(
              flex: orientation == Orientation.portrait ? 3 : 5,
              child: Container(
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Center(
                          child: Container(
                        child: _citiesDown(),
                        width: MediaQuery.of(context).size.width - 90,
                      )),
                      SizedBox(
                        height: 5,
                      ),
                      
                      Center(
                          child: Container(
                        child: _gasStationDown(),
                        width: MediaQuery.of(context).size.width - 90,
                      )),
                      SizedBox(
                        height: 5,
                      ),

                      Center(
                          child: Container(
                        child: _gasTypeDown(),
                        width: MediaQuery.of(context).size.width - 90,
                      )),
                      SizedBox(
                        height: 5,
                      ),
                      //Flexible(child: _gasStationDown()),
                      //Flexible(child: _gasTypeDown()),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: orientation == Orientation.portrait ? 8 : 5,
              child: Scrollbar(
                child: FutureBuilder(
                  builder: (context, cards) {
                    if (_cards.isEmpty &&
                        (_citiesDown().value != null ||
                            _gasStationDown().value != null ||
                            _gasTypeDown().value != null)) {
                      return Container(
                          child: Text('DUS ar šādiem kritērijiem nepastāv.'));
                    } else if (_cards.isEmpty) {
                      return Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return LiquidPullToRefresh(
                        onRefresh: _refreshCards,
                        child: ListView.builder(
                          itemCount: _cards.length,
                          shrinkWrap: true,
                          itemBuilder: (context,index)=> _cards[index],
                        ),
                      );
                    }
                  },
                  //     child: ListView.builder(
                  //    itemCount: cards.length,
                  //    shrinkWrap: true,
                  //     itemBuilder: (context,index)=> cards[index],
                  //   ),
                ),
              ),
            ),
          ],
        );
      }),
    ));
  }
}
