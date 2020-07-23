import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum Type{
  DIESEL,
  NINETYFIVE,
  NINETYEIGHT,
  ELECTICKWHFAST,
  ELECTRICKWHMEDIUM,
  ELECTRICPERMINUTE,
  LPG
}

class GasType{
  Type type;
  String price;
  String unit;
  String color;
  String time;
  GasType({@required this.type,  this.price, this.unit});

  String readTimestamp(int timestamp) {
    var now = DateTime.now();
    var format = DateFormat('HH:mm');
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    var diff = now.difference(date);
    var time = '';

    if(timestamp == 0000){
      return '';
    }

    if(date.month == today.month && date.day == today.day){
      time = 'Atjaunots šodien ' + format.format(date);
    }
    else if(date.month == yesterday.month && date.day == yesterday.day){
      time = 'Atjaunots vakar ' + format.format(date);
    }
    else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time =   'Atjaunots pirms ' + diff.inDays.toString() + '. dienas';
      } else {
        time ='Atjaunots pirms ' +  diff.inDays.toString()  + '. dienām';
      }
    } else {
      if (diff.inDays > 7 && diff.inDays < 14) {
        time = 'Atjaunots pirms ' + (diff.inDays / 7).floor().toString() + '. nedēļas';
      } else {

        time = 'Atjaunots pirms ' + (diff.inDays / 7).floor().toString() + '. nedēļām';
      }
    }

    return time;
  }


getType(){
  switch(this.type){
    case (Type.DIESEL):{
     return 'DD';
   }
    case (Type.NINETYEIGHT):{
      return '98';
    }
    case (Type.NINETYFIVE):{
      return '95';
    }
    case (Type.ELECTICKWHFAST):{
      return 'Kwh Fast';
    }
    case (Type.ELECTRICKWHMEDIUM):{
      return 'Kwh medium';
    }
    case (Type.ELECTRICPERMINUTE):{
      return 'E';
    }
    case (Type.LPG):{
      return 'lpg';
    }
  }
}



}