import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:degvielascenas/GasType.dart';
import 'package:cached_network_image/cached_network_image.dart';



class GasCard extends StatelessWidget {
  var json;
  var image;
  var gasStationName;
  var brand;
  var location;
  var unit;
  GasType ninetyfive = new GasType(type: Type.NINETYFIVE);
  GasType electricKwhFast = new GasType(type: Type.ELECTICKWHFAST);
  GasType electricKwhMedium = new GasType(type: Type.ELECTRICKWHMEDIUM);
  GasType electricPerMinute = new GasType(type: Type.ELECTRICPERMINUTE);
  GasType ninetyeight = new GasType(type: Type.NINETYEIGHT);
  GasType diesel = new GasType(type: Type.DIESEL);
  GasType lpg = new GasType(type: Type.LPG);



 GasCard(var json, ){
   this.location = json['location']['street'];
  this.gasStationName= json['title'];

   try { this.brand = json['brand']['key'];
   } on NoSuchMethodError catch(e) {
     this.brand = null;
   }

  try {this.image = json['brand']['logo'];
  } on NoSuchMethodError catch(e) {
    this.image = null;
  }
  try {
    this.diesel.price = json['prices']['diesel']['price'];
    this.unit = json['prices']['diesel']['tag'];
  } on NoSuchMethodError catch (e) {
    this.diesel.price = null;
  }
  try {
    this.ninetyfive.price = json['prices']['95']['price'];
    this.unit = json['prices']['95']['tag'];
  } on NoSuchMethodError catch(e) {
    this.ninetyfive.price = null;
  }
  try {
    this.electricKwhFast.price = json['prices']['perKwhFast']['price'];
    this.unit = json['prices']['perKwhFast']['unit'];
  } on NoSuchMethodError catch(e) {
    this.electricKwhFast = null;
  }
   try {
    this.electricKwhMedium.price = json['prices']['perKWhMedium']['price'];
    this.unit = json['prices']['perKWhMedium']['unit'];
   } on NoSuchMethodError catch(e) {
     this.electricKwhMedium = null;
   }
   try {
    this.electricKwhFast.price = json['prices']['perKWhFast']['price'];
    this.unit = json['prices']['perKWhFast']['unit'];
   } on NoSuchMethodError catch(e) {
     this.electricKwhFast = null;
   }
   try {
    this.electricPerMinute.price = json['prices']['perMinute']['price'];
    this.unit = json['prices']['perMinute']['unit'];
   } on NoSuchMethodError catch(e) {
     this.electricPerMinute = null;
   }
   try {
    this.lpg.price = json['prices']['lpg']['price'];
    this.unit = json['prices']['lpg']['unit'];
  } on NoSuchMethodError catch(e) {
     this.lpg.price = null;
   }

 }




  @override
  Widget build(BuildContext context) {
    List <Widget> gasPrices = new List();

    var gasTypes = [ninetyfive, electricKwhFast, ninetyeight, diesel, lpg, electricPerMinute, electricKwhMedium, electricKwhFast];
    for (int i = 0; i<gasTypes.length;i++){
      if(gasTypes[i]!=null && gasTypes[i].price!=null){
        gasPrices.add(Container(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      gasTypes[i].getType(),
                      style: TextStyle(color: Colors.white),),),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Text(gasTypes[i].price),
                 Text(' EUR', style: TextStyle(fontSize: 8 , color: Colors.grey),),
                 //##todo salabot units
                 //   Text(gasTypes[i].unit!=null ? gasTypes[i].unit: 'ērror'),
                  ],
                ),

              ],
            ),
          ),
        ),
        );
      }
    }


    return Card(
        child: Row(
           mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
           Padding(
             padding: const EdgeInsets.all(10.0),
             child: this.image!=null ? CachedNetworkImage(
               imageUrl: this.image,
               imageBuilder: (context, imageProvider) => Container(
                 width: 60.0,
                 height: 60.0,
                 decoration: BoxDecoration(
                   shape: BoxShape.circle,
                   image: DecorationImage(
                       image: imageProvider, fit: BoxFit.cover),
                 ),
               ),
               placeholder: (context, url) => CircularProgressIndicator(),
               errorWidget: (context, url, error) => Icon(Icons.error),
             )
                 :
             CachedNetworkImage(
               imageUrl: 'https://www.adler-colorshop.com/media/image/a2/5d/c2/farbtoene-ferrocolor-weiss.jpg',
               imageBuilder: (context, imageProvider) => Container(
                 width: 60.0,
                 height: 60.0,
                 decoration: BoxDecoration(
                   shape: BoxShape.circle,
                   image: DecorationImage(
                       image: imageProvider, fit: BoxFit.cover),
                 ),
               ),
               placeholder: (context, url) => CircularProgressIndicator(),
               errorWidget: (context, url, error) => Icon(Icons.error),
             )

           ),
            Column(
              children: <Widget>[
                Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(gasStationName),
                    SizedBox(height: 10,),
                    Text(location,
                          style: TextStyle(
                              color: Colors.grey,
                              ),
                    ),
                  ],
                ),

              ],
            ),

            Spacer(flex: 10,),
                 Row(children:gasPrices),
            Spacer(flex: 1,),
          ],
        ),

    );
  }
}



