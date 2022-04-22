import 'dart:convert';
import 'dart:core';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/timestamp.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/reservation.pbgrpc.dart';
import 'package:diving_trip_agency/screens/detail/trip_detail(bak).dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/profile/diver/edit_profile_diver.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../nautilus/proto/dart/model.pb.dart';


List Cartlist = [];

List<RoomType> roomtypes;
List<TripWithTemplate> details;
//TODO: Get RoomType object as String or JSON
//TODO: Ditto with the TripWithTemplate Object
int indexRoom;
int indexDetail;
int quantity;
int diver;
GetProfileResponse user_profile = new GetProfileResponse();
var profile;


class CartWidget extends StatefulWidget {
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<CartWidget> {
  final Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  @override
  void initState() {

    for (int i = 0; i < Cartlist.length; i++) {
      roomtypes = Cartlist[i][6];
      details = Cartlist[i][5];
      indexRoom = Cartlist[i][7];
      indexDetail = Cartlist[i][8];
      quantity = Cartlist[i][9];
      diver = Cartlist[i][10];
      persCarthive(i);
    }
    // TODO: implement initState
    super.initState();
  }

  void persCarthive(int cartind) async{ //Test Hive

    var box = await Hive.openBox('testBox');
    print(Cartlist[cartind][6]);
    var jsonroomtype = jsonEncode((Cartlist[cartind][6]
    as List<RoomType>).map((e) => e.toProto3Json()).toList());
    box.put('roomtype', jsonroomtype.toString());
    print("-------------------");
    print(box.get('roomtype'));

    var jsondetails = jsonEncode((Cartlist[cartind][5]
    as List<TripWithTemplate>).map((e) => e.toProto3Json()).toList());

    box.put('tripdetail', jsondetails.toString());
    print("-------------------");
    print(box.get('tripdetail'));
    print("-------------------");
    print(box.toMap());

  }

  void persCart(int cartind) async{ //Test Sharedpreference
    /*Map<String,dynamic> roomtypeJSON =
    {
      'roomtype':Cartlist[cartind][6]['room_type'],
      'reservationid': Cartlist[cartind][6]['reservation_id']
    };*/

    print("roomstypeJSON");
    print(Cartlist[cartind][6][0]);
    print("Length of hotel list");
    print(Cartlist[cartind][6][0]);

    //print(roomtypeJSON);
    Map<String, dynamic> cartitem =
    {'roomtypes': "Test",
    'details':Cartlist[cartind][5],
    'indexRoom':Cartlist[cartind][7],
    'indexDetail' : Cartlist[cartind][8],
    'quantity' : Cartlist[cartind][9],
    'diver' : Cartlist[cartind][10],
    };
    print("Cartitem here");
    //var jsonstring = jsonEncode(cartitem);

    //print(jsonstring);
    //prefs.setStringList('cartkey', [roomtypes, details, indexRoom]);
    //bool result = await prefs.setString('cartitem', jsonEncode(cartitem));
    //print(result);
  }

  getProfile() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');
    final pf = AccountClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    profile = await pf.getProfile(new Empty());

    user_profile = profile;
    return user_profile;
  }

  void bookTrips() async {
    await getProfile();
    print('length' + Cartlist.length.toString());
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = ReservationServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var reservation;

    var room = Reservation_Room();
    for (int i = 0; i < roomtypes.length; i++) {
      room.quantity = quantity;
      room.roomTypeId = roomtypes[indexRoom].id;
      room.noDivers = diver;
    }

    reservation = Reservation()..rooms.add(room);
    reservation.tripId = details[indexDetail].id;
    reservation.diverId = user_profile.diver.id;
    reservation.price =
        (roomtypes[indexRoom].price * quantity) + details[indexDetail].price;
    reservation.totalDivers = Int64(quantity);

    var bookRequest = CreateReservationRequest()..reservation = reservation;
    try {
      var response = stub.createReservation(bookRequest);
      print('response: ${response}');
    } catch (e) {
      print(e);
    }


  }

  @override
  Widget build(BuildContext context) {
    /* print("Roomtypes here.");
     print(roomtypes);
     print("details here.");
     print(details);
     print("indexroom here.");
     print(indexRoom);
     print(indexDetail);
     print(quantity);
     print(diver);*/


    return Container(
        //width: 800,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(20),
        child: Column(children: [
          SectionTitle(
            title: "Trips in cart",
            color: Color(0xFFFF78a2cc),
          ),
          SizedBox(height: 40),
          ListView.builder(
            itemCount: Cartlist.length,
            shrinkWrap: true,
            itemBuilder: (context, position) {
              return Card(
                  child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Wrap(
                          direction: Axis.horizontal,
                            //mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  width: MediaQuery.of(context).size.width/15,
                                  height: MediaQuery.of(context).size.width/15,
                                  child: Cartlist[position][0]),

                              // Flexible(
                              //     child: Container(
                              //   child: Image(
                              //       image: NetworkImage(
                              //          Cartlist[position][0])),
                              // )),
                              SizedBox(width: 30),
                              Wrap(
                                direction: Axis.vertical,
                                  //crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Trip Name: " +
                                          Cartlist[position][1].toString(),
                                      // style: TextStyle(fontSize: 22.0),
                                    ),
                                    Text(
                                      "Hotel Name: " +
                                          Cartlist[position][2].toString(),
                                      // style: TextStyle(fontSize: 22.0),
                                    ),
                                    Text(
                                      "Room Name: " +
                                          Cartlist[position][3].toString(),
                                      // style: TextStyle(fontSize: 22.0),
                                    ),
                                    Text(
                                      "Total price: " +
                                          Cartlist[position][4].toString(),
                                      // style: TextStyle(fontSize: 22.0),
                                    ),
                                  ]),
                              SizedBox(width: 30),
                              /*TextButton(
                            child: Text(
                              "Edit",
                              style: TextStyle(fontSize: 25),
                            ),
                            onPressed: () {},
                            style: TextButton.styleFrom(
                                primary: Colors.red,
                                elevation: 2,
                                backgroundColor: Colors.amber),
                          ),*/
                              TextButton(
                                child: Text(
                                  "Check JSON",
                                  // style: TextStyle(fontSize: 25),
                                ),
                                onPressed: () {

                                  setState(() {
                                    print("Checked");
                                    persCarthive(position);
                                    //persCart(position);
                                  });
                                },
                                style: TextButton.styleFrom(
                                    primary: Colors.red,
                                    elevation: 2,
                                    backgroundColor: Colors.amber),
                              ),

                              SizedBox(width: 30),
                              TextButton(
                                child: Text(
                                  "Remove",
                                  // style: TextStyle(fontSize: 25),
                                ),
                                onPressed: () {
                                  setState(() {
                                    print("deleted");

                                    Cartlist.removeAt(position);
                                    print(Cartlist);
                                  });
                                },
                                style: TextButton.styleFrom(
                                    primary: Colors.red,
                                    elevation: 2,
                                    backgroundColor: Colors.amber),
                              ),
                            ]),
                      )));
            },
          ),
          SizedBox(height: 30),
          Cartlist.length != 0
              ? TextButton(
                  child: Text(
                    "Book",
                    // style: TextStyle(fontSize: 25),
                  ),
                  onPressed: () async {
                    await bookTrips();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Booking"),
                            content: Text("done"),
                            actions: <Widget>[
                              // FlatButton(
                              //   child: Text("OK"),
                              // ),
                            ],
                          );
                        });
                    //print(Cartlist);
                  },
                  style: TextButton.styleFrom(
                      primary: Colors.white,
                      elevation: 2,
                      backgroundColor: Colors.indigo),
                )
              : Text('No trip'),
          SizedBox(height: 30),
        ]));

    /*Container(
      color: const Color(0xFFFFE306),
      child: Column(

        children:[
          Text("Shopping Cart"),
        ]
      )
    );*/
  }
}
