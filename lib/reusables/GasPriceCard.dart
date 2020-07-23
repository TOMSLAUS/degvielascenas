import 'package:degvielascenas/GasType.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class GasPriceCard extends StatelessWidget {
  GasType gasType;
  var type;
  var price;
  var lastUpdated;
  Color color;

  
  GasPriceCard({this.type, this.price, this.gasType, this.color});

 /* GasPriceCard(var gasType, var price, var lastUpdated, var color){
this.gasType = gasType;
this.price = price;
this.lastUpdated = lastUpdated;
this.color = color;
  }
*/
  @override
  Widget build(BuildContext context) {

    return Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          Padding(
            padding: EdgeInsets.fromLTRB(30, 15, 0, 15),
            child: Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Hexcolor(gasType.color),
              ),
              child: Text(gasType.getType(), style: TextStyle(color: Colors.white),),
            ),
          ),
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
              child:

              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [

                  Column(
                    children: [
                      Row(
                        children: [
                          Text(gasType.price),
                          Text(' EUR', style: TextStyle(fontSize: 8 , color: Colors.grey),),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Text(gasType.readTimestamp(int.parse(gasType.time)))
                    ],
                  ),

                ],
              )),

        ],
      ),
    );
  }
}
