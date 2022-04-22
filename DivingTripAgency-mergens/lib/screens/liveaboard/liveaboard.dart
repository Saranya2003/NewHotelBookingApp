//import 'dart:html';

import 'package:diving_trip_agency/screens/aboutus/about_us_page.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard_data.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard_details.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/timestamp.pb.dart';

class liveaboard extends StatefulWidget {
  @override
  _liveabroad createState() => _liveabroad();
}

class _liveabroad extends State<liveaboard> {
//class liveaboard extends StatelessWidget {
  DateTime _dateTime;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          flex: 3,
          child: Column(children: [
            Container(
              margin: EdgeInsets.all(10.0),
              padding: EdgeInsets.all(10.0),
              height: 1800,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.red[50],
              ),
              child: Column(children: [
                Text("SEARCH"),
                TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        hintText: 'Date')),
                TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        fillColor: Colors.white,
                        hintText: 'Location')),
                ButtonTheme(
                  minWidth: 60,
                  height: 36,
                  child: RaisedButton(
                      color: Color(0xfff8dd9cc),
                      child: Text('Pick a date'),
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime.now())
                            .then((date) => {
                                  setState(() {
                                    var timeStamp =
                                        print(Timestamp.fromDateTime(date));
                                    _dateTime = date;
                                    print(_dateTime);
                                  })
                                });
                      }),
                ),
                ElevatedButton(onPressed: () {}, child: Text("SEARCH"))
              ]),
            ),
          ])),
      Expanded(
          flex: 7,
          child: Material(
            type: MaterialType.transparency,
            child: SingleChildScrollView(
              child: Container(
                //   margin: EdgeInsetsDirectional.only(top:120),
                width: double.infinity,
                // height: 600,
                decoration:
                    BoxDecoration(color: Color(0xfffd4f0f7).withOpacity(0.3)),
                child: Column(
                  children: [
                    SectionTitle(
                      title: "Liveaboard",
                      color: Color(0xFFFF78a2cc),
                    ),
                    SizedBox(height: 40),
                    SizedBox(
                        width: 1110,
                        child: Wrap(
                            spacing: 20,
                            runSpacing: 40,
                            children: List.generate(
                              LiveAboardDatas.length,
                              (index) => Center(
                                child: InfoCard(
                                  index: index,
                                ),
                              ),
                            ))),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ),
          ))
    ]);
  }
}

class InfoCard extends StatefulWidget {
  const InfoCard({
    Key key,
    this.index,
  }) : super(key: key);

  final int index;

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 320,
        width: 1000,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
                width: 300,
                height: 300,
                child: Image.asset(LiveAboardDatas[widget.index].image)),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Liveaboard name : ' +
                            LiveAboardDatas[widget.index].name),

                        SizedBox(
                          height: 10,
                        ),
                         Row(
                          children: [
                            Text('City'),
                            SizedBox(width:20),
                            Text('Country'),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        // Text(LiveAboardDatas[widget.index].description),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        Text('Total capacity'),

                        SizedBox(
                          height: 10,
                        ),
                        Text('Room type'),
                        SizedBox(
                          height: 10,
                        ),

                        Align(
                          alignment: Alignment.centerRight,
                          child: Text('Price : ' + LiveAboardDatas[widget.index].price)),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: RaisedButton(
                            onPressed: () {
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             LiveaboardDetailScreen()));
                              
                            },
                            color: Colors.amber,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text("View boat"),
                          ),
                        )

              ],
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}