import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbjson.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/trip.pbgrpc.dart';
import 'package:diving_trip_agency/screens/aboutus/about_us_page.dart';
import 'package:diving_trip_agency/screens/diveresort/resort_details_screen.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard_data.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard_details.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/timestamp.pb.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

// This list holds the data for the list view
List<TripWithTemplate> _foundtrip = [];
List costchecklist = [];
List durationchecklist = [];

String dropdownValue = "All";
String dropdownValue2 = "All";
enum Cost { one, two, three, more, all }

List<TripWithTemplate> trips = [];
List Commlist = [
  [
                  ["Betty","Nice Trip!",5],
                  ["Paul","Love it",4]
  ],
  [
    ["Oliver","Fun Trip!",5],
    ["Peter","Oh yeah!",4]
  ],

];

// List<TripWithTemplate> allTrips = [];

class Review extends StatefulWidget {
  // SearchTripsResponse_Trip tripdetail ;
  // TripDetail(SearchTripsResponse_Trip tripdetail){
  //   this.tripdetail=tripdetail;

  // }
  _ReviewState createState() => _ReviewState();
}

class _ReviewState extends State<Review> {

  @override
  initState() {
    // at the beginning, all users are shown
    super.initState();
    //  trips;
  }


  Widget build(BuildContext context) {
    double screenwidth = MediaQuery
        .of(context)
        .size
        .width;

    return Container(
        child:Column(
          children: [
            Text("Columntest"),
          ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: 5,
          itemBuilder: (context, index) {
            return InfoCard(
              index: index,
            );
          })
          ],
        )

    );
  }
}


class InfoCard extends StatefulWidget {
  InfoCard({
    Key key,
    this.index,
  }) : super(key: key);
  int index;

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                    child: Text("Image")
                )
            ),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical:20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Text('Trip name : ' + _foundtrip[widget.index].name),
                      //LiveAboardDatas[widget.index].name),
                      Text('Trip name : '),
                      Text("Location: "),
                      Text("Start date: "),
                      Text("End date: "),
                      Text("Total people: "),
                      Text("Trip type: "),

                  ],
                  ),
                )),
            Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20,vertical:20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Text("Review"),

                              ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: Commlist.length,
                                      itemBuilder: (context, index) {
                                        return

                                            ListTile(
                                              title: Text(Commlist[index][0][0]+" says: "),
                                            leading: Icon(Icons.comment),
                                            trailing: RatingBarIndicator(
                                              rating: 3.75,
                                              itemBuilder: (context, index) => Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                              ),
                                              itemCount: 5,
                                              itemSize: 15.0,
                                              direction: Axis.horizontal,
                                            ),
                                            subtitle:Text(Commlist[index][0][1])



                                        );
                              }

                              ),
                  Row(
                    children: [
                      Expanded(
                          flex: 9,
                          child: Container(
                            child:TextField(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Comment here',
                              ),
                            )
                          ),
                      ),
                  Expanded(
                    flex: 1,
                      child:
                      IconButton(
                        icon: Icon(Icons.send),
                        iconSize: 30,
                        color: Colors.blue,
                        tooltip: 'Post comment',
                        onPressed: () {
                          setState(() {

                          });
                        },
                      ),
                  )
                    ],
                  ),
                ]
                  ),
            )
            ),
          ],
        ),
      ),
    );
  }
}
