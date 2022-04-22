
import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:flutter/material.dart';

class DivingShop extends StatefulWidget {
  @override
  _DivingShopState createState() => _DivingShopState();
}

class _DivingShopState extends State<DivingShop> {
  var imgList = [
    'assets/images/S__77242370.jpg',
    'assets/images/S__83271684.jpg',
    'assets/images/S__83271687.jpg'
  ];

  @override
  Widget build(BuildContext context) {
    //double width = MediaQuery.of(context).size.width * 0.9;
    return ListView.builder(
          padding: const EdgeInsets.all(5),
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: imgList.length,
          itemBuilder: (context, index) {
            return Center(
              child: Card(
                  child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[Flexible(flex:1,child:
                        Container(child: Image.asset(imgList[index]))),

                        Flexible(flex:2,child:
                              Column(mainAxisSize: MainAxisSize.min,children:[
                                Container(child: Text("TestBooking")),
                                Container(child: Column(children:[
                                  Text("Location: Phuket"),
                                  Text("Full Board"),
                                  Text("5 Star Hotel")
                                ]))
                              ]
                                )



                              ),
                        Flexible(flex:1,child:
                        Container(child: Text("Stars"))),

                      ]
                  )
              ),
            );
          }
    );
  }
}
