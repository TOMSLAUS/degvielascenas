import 'package:flutter/material.dart';

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
  GasType({@required this.type,  this.price, this.unit});

  //##todo uzlikt privātus mainīgos un uztaisīt enkapsulāciju.
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