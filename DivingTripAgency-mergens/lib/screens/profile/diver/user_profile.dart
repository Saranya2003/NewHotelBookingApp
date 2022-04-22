import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/diver.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/timestamp.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/payment/payment_review_screen.dart';
import 'package:diving_trip_agency/screens/payment/payment_screen.dart';
import 'package:diving_trip_agency/screens/profile/diver/edit_profile_diver.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';
import 'package:intl/intl.dart';

List<TripWithTemplate> trips = [];
List<Reservation> reservation = [];

GetProfileResponse user_profile = new GetProfileResponse();
var profile;
int reservation_id;
double total_price;

class UserProfile extends StatefulWidget {
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  getData() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');
    final stub = DiverServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var listTrips = ListReservationsWithTripsRequest();
    listTrips.limit = Int64(20);
    listTrips.offset = Int64(0);
    trips.clear();
    try {
      await for (var feature in stub.listReservationsWithTrips(listTrips)) {
        trips.add(feature.trip);
        reservation.add(feature.reservation);
      }

      // print(reservation);
    } catch (e) {
      print('ERROR: $e');
    }
    // print(trips);
    return trips;
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
    // print(profile);

    if (profile.hasDiver()) {
      user_profile = profile;
      return user_profile;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: Color(0xfffd4f0f7).withOpacity(0.3)),
      child: Column(
        children: [
          SizedBox(
            height: 50,
          ),
          // Icon(
          //   Icons.image,
          //   size: 100,
          // ),
          SectionTitle(
            title: "Profile",
            color: Color(0xFFFF78a2cc),
          ),
          SizedBox(
            height: 50,
          ),

          SizedBox(
            width: 1110,
            child: FutureBuilder(
              future: getProfile(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      SizedBox(
                        child: FutureBuilder(
                          future: getProfile(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Center(
                                child: Container(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Firstname : ' +
                                            user_profile.diver.firstName
                                                .toString(),
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Lastname : ' +
                                            user_profile.diver.lastName
                                                .toString(),
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Level : ' +
                                            user_profile.diver.level.toString(),
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'E-mail : ' +
                                            user_profile.diver.account.email
                                                .toString(),
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Phone number : ' +
                                            user_profile.diver.phone.toString(),
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Text(
                                        'Birthday : ' +
                                            DateFormat("dd/MM/yyyy").format(
                                                user_profile.diver.birthDate
                                                    .toDateTime()),
                                        style: TextStyle(fontSize: 18),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Align(
                                        alignment: Alignment.center,
                                        child: RaisedButton(
                                            // color: Colors.yellow,

                                            color: Colors.blue[300],
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Text(
                                              'Edit',
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          EditDiverScreen()));
                                            }),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return Text('User is not logged in.');
                            }
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 1110,
                        child: FutureBuilder(
                          future: getData(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return trips.length != 0
                                  ? Column(
                                      children: [
                                        Center(
                                            child: Column(
                                          children: [
                                            Text(
                                              'Trip history',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Container(
                                                child: Wrap(
                                                    spacing: 20,
                                                    runSpacing: 40,
                                                    children: List.generate(
                                                      trips.length,
                                                      (index) => Center(
                                                        child: InfoCard(
                                                          index: index,
                                                        ),
                                                      ),
                                                    ))),
                                          ],
                                        )),
                                      ],
                                    )
                                  : Text('');
                            } else {
                              return Align(
                                  alignment: Alignment.center,
                                  child: Text('No data'));
                            }
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(child: Text('User is not logged in'));
                }
              },
            ),
          ),

          SizedBox(
            height: 50,
          ),
        ],
      ),
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
  // List<SearchTripsResponse_Trip> trips = [];
  List<TripWithTemplate> listTrip;
  @override
  Widget build(BuildContext context) {
    // getData();
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReviewTripScreen(
                      int.parse(reservation[widget.index].id.toString()),
                      double.parse(reservation[widget.index].price.toString()),
                      trips[widget.index],
                    )));
      },
      child: Container(
        height: 320,
        width: MediaQuery.of(context).size.width/1.2,
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
                width: MediaQuery.of(context).size.width/10,
                height: MediaQuery.of(context).size.width/10,
                child: trips[widget.index].tripTemplate.images.length == 0
                    ? new Container(
                        color: Colors.pink,
                      )
                    : Image.network(' http://139.59.101.136/static/' +
                            trips[widget.index]
                                .tripTemplate
                                .images[0]
                                .toString()
                        // trips[widget.index].tripTemplate.images[0].toString()
                        )),
            // child: Image.asset(LiveAboardDatas[widget.index].image)),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Text('Trip name : ' + _foundtrip[widget.index].name),
                        //LiveAboardDatas[widget.index].name),

                        Text('Location : ' +
                            trips[widget.index].tripTemplate.address.city),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Start date : ' +
                            DateFormat("dd/MM/yyyy").format(
                                trips[widget.index].fromDate.toDateTime())),
                        SizedBox(
                          height: 10,
                        ),
                        Text('End date : ' +
                            DateFormat("dd/MM/yyyy").format(
                                trips[widget.index].toDate.toDateTime())),
                        SizedBox(
                          height: 10,
                        ),

                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Text(LiveAboardDatas[widget.index].description),
                        Text('Total people : ' +
                            trips[widget.index].maxGuest.toString()),
                        SizedBox(
                          height: 10,
                        ),

                        Text('Trip type : ' +
                            trips[widget.index]
                                .tripTemplate
                                .tripType
                                .toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text('Price : ' +
                                reservation[widget.index].price.toString())),
                        SizedBox(
                          height: 20,
                        ),
                        // Align(
                        //   alignment: Alignment.centerRight,
                        //   child: RaisedButton(
                        //     onPressed: () {
                        //       //   Navigator.push(
                        //       //       context,
                        //       //       MaterialPageRoute(
                        //       //           builder: (context) =>
                        //       //               DiveResortDetailScreen()));
                        //     },
                        //     color: Colors.amber,
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(10)),
                        //     child: Text("View package"),
                        //   ),
                        // )
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
