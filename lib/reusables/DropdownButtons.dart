import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:degvielascenas/views/MainWindow.dart';






  List getCities(List city)  {
    List  buttonarr = new List();

  for (int i = 0 ; i<city.length;i++) {
DropdownMenuItem(

);
  //  buttonarr.add( DropdownMenuItem<String>(
  //  value: city[i],
 //   child: Text(
  //      city[i]
 //   ),
 //   ),
  }
  return buttonarr;
  }



   //getCities() async{
   // List buttonarr;
   // var url = 'https://gasprices.dna.lv/other/filterstations/?output=json';
  //  var body = {'city' : city};
  //  var response = await http.post(url, body: body);
  //  var jsondata = jsonDecode(response.body);
    //for (){

  //  }
 // }

