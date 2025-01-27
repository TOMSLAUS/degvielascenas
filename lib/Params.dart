import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Params{
  String city = '';
  String brand = '';
  String gasType = '';

getStations(var lat, var lon)async{
      var _body;
      var url = 'https://gasprices.dna.lv/other/filterstations/?output=json';

      if(this.city == ''){
        print(this.gasType);
         _body = {'lat': lat.toString(), 'lon': lon.toString(),
          'brand' : this.brand , 'fuel' : this.gasType};
      }
      else
        {
          _body = {'brand' : this.brand, 'city' : this.city , 'fuel' : this.gasType , 'lat': lat.toString(), 'lon': lon.toString(),};
        }

      var response = await http.post(url, body: _body);

      print(response.statusCode);

      if (jsonDecode(response.body)!=null){
        return jsonDecode(response.body);
      }
      return null;
    }



}