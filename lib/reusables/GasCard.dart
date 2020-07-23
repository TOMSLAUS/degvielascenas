import 'dart:ui';

import 'package:degvielascenas/views/gasStationView.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:degvielascenas/GasType.dart';
import 'package:cached_network_image/cached_network_image.dart';



class GasCard extends StatelessWidget {
  var json;
  var image;
  var gasStationName;
  var brand;
  var location;
  var unit;
  var lat;
  var lon;
  GasType ninetyfive = new GasType(type: Type.NINETYFIVE);
  GasType electricKwhFast = new GasType(type: Type.ELECTICKWHFAST);
  GasType electricKwhMedium = new GasType(type: Type.ELECTRICKWHMEDIUM);
  GasType electricPerMinute = new GasType(type: Type.ELECTRICPERMINUTE);
  GasType ninetyeight = new GasType(type: Type.NINETYEIGHT);
  GasType diesel = new GasType(type: Type.DIESEL);
  GasType lpg = new GasType(type: Type.LPG);
  List gasList = new List();
  String electricColor = '#ffbc57';

 GasCard(var json, ){
   this.location = json['location']['street'];
   this.lat = json['location']['lat'];
   this.lon = json['location']['lon'];
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
    this.diesel.unit = json['prices']['diesel']['tag'];
    this.diesel.time = json['prices']['diesel']['time'];
    this.diesel.color = '#231f20';
    gasList.add(this.diesel);
  } on NoSuchMethodError catch (e) {
    this.diesel.price = null;
  }
  try {
    this.ninetyfive.price = json['prices']['95']['price'];
    this.ninetyfive.unit = json['prices']['95']['tag'];
    this.ninetyfive.time = json['prices']['95']['time'];
    this.ninetyfive.color = 	"#00994d";
    gasList.add(this.ninetyfive);
  } on NoSuchMethodError catch(e) {
    this.ninetyfive.price = null;
  }
   try {
     this.ninetyeight.price = json['prices']['98']['price'];
     this.ninetyeight.unit = json['prices']['98']['tag'];
     this.ninetyeight.time = json['prices']['98']['time'];
     this.ninetyeight.color = "#ee8402";
     gasList.add(ninetyeight);
   } on NoSuchMethodError catch(e) {
     this.ninetyeight.price = null;
   }
  try {
    this.electricKwhFast.price = json['prices']['perKwhFast']['price'];
    this.electricKwhFast.unit = json['prices']['perKwhFast']['unit'];
    this.electricKwhFast.time = '0000';
    //this.electricKwhFast.time = json['prices']['perKwhFast']['time'];
    this.electricKwhFast.color = electricColor;
    gasList.add(electricKwhFast);
  } on NoSuchMethodError catch(e) {
    this.electricKwhFast = null;
  }
   try {
    this.electricKwhMedium.price = json['prices']['perKWhMedium']['price'];
    this.electricKwhMedium.unit = json['prices']['perKWhMedium']['unit'];
    this.electricKwhMedium.time = '0000';
     // this.electricKwhMedium.time = json['prices']['perKWhMedium']['time'];

    this.electricKwhMedium.color = electricColor;
    gasList.add(electricKwhMedium);
   } on NoSuchMethodError catch(e) {
     this.electricKwhMedium = null;
   }
   try {
    this.electricKwhFast.price = json['prices']['perKWhFast']['price'];
    this.electricKwhFast.unit = json['prices']['perKWhFast']['unit'];
    this.electricKwhFast.time = '0000';
    //this.electricKwhFast.time = json['prices']['perKWhFast']['time'];
    this.electricKwhFast.color = electricColor;
    gasList.add(electricKwhFast);
   } on NoSuchMethodError catch(e) {
     this.electricKwhFast = null;
   }
   try {
    this.electricPerMinute.price = json['prices']['perMinute']['price'];
    this.electricPerMinute.unit = json['prices']['perMinute']['unit'];
    //this.electricPerMinute.time = json['prices']['perMinute']['time'];
    this.electricPerMinute.time = '0000';
    this.electricPerMinute.color = electricColor;
    gasList.add(electricPerMinute);
   } on NoSuchMethodError catch(e) {
     this.electricPerMinute = null;
   }
   try {
    this.lpg.price = json['prices']['lpg']['price'];
    this.lpg.unit = json['prices']['lpg']['unit'];
    this.lpg.time = json['prices']['lpg']['time'];
    this.lpg.color = "#e4232e";
    gasList.add(lpg);
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
                  //  Text(' EUR', style: TextStyle(fontSize: 8 , color: Colors.grey),),
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
        child: FlatButton(
          onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GasStation(this)),
            );
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
             mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
             Padding(
               padding: const EdgeInsets.fromLTRB(0, 10, 5, 10),
               child: this.image!=null ? CachedNetworkImage(
                 imageUrl: this.image,
                 imageBuilder: (context, imageProvider) => Container(
                   width: 50.0,
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
              Flexible(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(gasStationName , overflow:  TextOverflow.fade,),
                    SizedBox(height: 10,),
                    Text(location,
                          style: TextStyle(
                              color: Colors.grey,
                              ),
                      overflow: TextOverflow.fade,
                    ),
                  ],
                ),
              ),
              //Spacer(),
             // SizedBox(width: 50,),

                   Expanded(flex: 5 , child: Row(mainAxisAlignment: MainAxisAlignment.end,children:gasPrices)),
            ],
          ),
        ),

    );
  }
}



