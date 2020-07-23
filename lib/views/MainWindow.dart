import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../reusables/GasCard.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:degvielascenas/Params.dart';

//##todo pull to refresh
class MainWindow extends StatefulWidget {
  @override
  _MainWindowState createState() => _MainWindowState();
}

class _MainWindowState extends State<MainWindow> {

  Params params = new Params();
  String _valueCityButtons;
  String _valueGasStationButtons;
  String _valueGasTypeButtons;
  var stations;
  var jsondata;
  List <Widget> _cards = new List();
  String lat;
  String lon;
  List<DropdownMenuItem<String>> cityButtons;
  List<DropdownMenuItem<String>> gasStationButtons;
  List<DropdownMenuItem<String>> gasTypeButtons;
  int pogas;
  int pogas2;

  @override
  initState(){
    getEverything();
    super.initState();
  }


//##todo kas notiek kad nav neviena dus pēc kritērijiem ?
  DropdownButton _citiesDown() => DropdownButton<String> (
    isExpanded: true,
    hint: DropdownMenuItem(child: Text('Visas pilsētas'),value: '',),
    items: cityButtons,
    onChanged: (value) async {
      params.city = value;
      jsondata =  await  params.getStations(lat, lon);
      setState(()  {
        _valueCityButtons = value;
        _cards.clear();
        for (stations in jsondata){
          setState(() {
            _cards.add(GasCard(stations));
          });
        }
      });
    },
    value: _valueCityButtons ,
  );

  DropdownButton _gasStationDown() => DropdownButton<String>(
    isExpanded: true,
    hint: DropdownMenuItem(child: Text('Visi zīmoli'),value: '',),
    items: gasStationButtons,
    onChanged: (value) async {
      params.brand = value;
      jsondata =  await  params.getStations(lat, lon);
      setState(() {
        _valueGasStationButtons = value;
        _cards.clear();
        for (stations in jsondata){
          setState(() {
            _cards.add(GasCard(stations));
          });
        }
      });
    },
    value: _valueGasStationButtons,
  );

  DropdownButton _gasTypeDown() => DropdownButton<String>(
    isExpanded:  true,
    hint: DropdownMenuItem(child: Text('Visi degvielas veidi'),value: '',),
    items: gasTypeButtons,
    onChanged: (value) async {
      print(value);
      params.gasType = value;
      jsondata =  await  params.getStations(lat, lon);
      setState(() {
        _valueGasTypeButtons = value;
        _cards.clear();
        for (stations in jsondata){
          setState(() {
            _cards.add(GasCard(stations));
          });
        }
      });
    },
    value: _valueGasTypeButtons,
  );

//##todo pievienot meklēšanu
  List<DropdownMenuItem<String>> getCities(List city)  {
    List<DropdownMenuItem<String>> buttonarr = new List();
    buttonarr.add(DropdownMenuItem(child: Text('Visas pilsētas'),value: '',),);
    buttonarr.add(DropdownMenuItem(child: Text('Tuvākie vispirms (kārtot pēc cenas)'),value: 'byprice',),);
    for (int i = 0 ; i<city.length;i++) {
      buttonarr.add(
          DropdownMenuItem(
              child: Text(city[i],),
              value: city[i]),
      );
  }
    return buttonarr;
  }
  List<DropdownMenuItem<String>> getGasStations(List gasStations)  {
    List<DropdownMenuItem<String>> buttonarr = new List();
    buttonarr.add(DropdownMenuItem(child: Text('Visi zīmoli'),value: '',),);
    for (int i = 0 ; i<gasStations.length;i++) {
      buttonarr.add(
        DropdownMenuItem(
            child: Text(gasStations[i],),
            value: gasStations[i]
        ),
      );
    }
    return buttonarr;
  }
  List<DropdownMenuItem<String>> getGasType(List gasType)  {
    List<DropdownMenuItem<String>> buttonarr = new List();
    buttonarr.add(DropdownMenuItem(child: Text('Visi degvielas veidi'),value: '',),);
    for (int i = 0 ; i<gasType.length;i++) {
      buttonarr.add(
        DropdownMenuItem(
            child: Text(gasType[i],),
            value: gasType[i]
        ),
      );
    }
    return buttonarr;
  }

void getEverything() async {
  await getLocation();
  cityButtons =   getCities(await getCityButtons());
  gasTypeButtons =   getGasType(await getGasTypeButtons());
  gasStationButtons =   getGasStations(await getGasStationButtons());
  stations = getStations(lat, lon);
}

  void getLocation() async {

    var status = await Permission.location.request();

    if (status.isGranted == true){
      // GeolocationStatus geolocationStatus = await Geolocator()
      //    .checkGeolocationPermissionStatus();
      var position = await Geolocator().getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      lon = position.longitude.toString();
      lat = position.latitude.toString();
      print('gps location');
    }
    else {
      var url = 'https://api6.ipify.org?format=json';
      var response = await http.get(url);
      print(response.statusCode);
      Map data = jsonDecode(response.body);
      var cities = data['ip'];
      String  ipAddress = cities;
      print(ipAddress);

      var url2 = 'https://sys.airtel.lv/ip2country/$ipAddress/?full';
      var response2 = await http.get(url2);
      print(response2.statusCode);
      Map data2 = jsonDecode(response2.body);
      lat = data2['lat'];
      lon = data2['lon'];
      print('ip location');
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
    List <String> gasType = cities.keys.toList();
    return gasType;
  }



getStations(var lat, var lon) async {
  var url = 'https://gasprices.dna.lv/other/filterstations/?output=json';
  print(lat);
  var body = {'lat': lat.toString(), 'lon': lon.toString()};
  var response = await http.post(url, body: body);
  var jsondata = jsonDecode(response.body);
  print(response.statusCode);
  for (stations in jsondata){
    setState(() {
      _cards.add(GasCard(stations));
    });
  }
}



    @override
    Widget build(BuildContext context) {
    return Scaffold(
            body:SafeArea(
              child: OrientationBuilder(
        builder: (context, orientation) {
          return Column(
            children: <Widget>[
              Expanded(
                flex: orientation == Orientation.portrait ? 3 : 5,
                child: Container(

                  child: Center(
                    child: Column(
                      children: <Widget>[
                        Center(child: Container(
                          child: _citiesDown(), width: MediaQuery
                            .of(context)
                            .size
                            .width - 90,)),
                        SizedBox(height: 5,),

                        Center(child: Container(
                          child: _gasStationDown(), width: MediaQuery
                            .of(context)
                            .size
                            .width - 90,)),
                        SizedBox(height: 5,),

                        Center(child: Container(
                          child: _gasTypeDown(), width: MediaQuery.of(context).size.width - 90,)),
                        SizedBox(height: 5,),
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
                      if (_cards.isEmpty) {
                        return Container(
                          child: Center(
                            child: CircularProgressIndicator(
                              //  backgroundColor: Colors.blue,

                            )
                            ,)
                          ,);
                      }
                      else {
                        return ListView.builder(
                          itemCount: _cards.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) => _cards[index],

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
        }
              ),
            )
        );
    }

}
