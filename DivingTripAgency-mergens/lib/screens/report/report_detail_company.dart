import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/timestamp.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/trip.pbgrpc.dart';
import 'package:diving_trip_agency/screens/diveresort/resort_details_screen.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/profile/company/edit_profile_comp.dart';

import 'package:diving_trip_agency/screens/report/company_check_payment.dart';

import 'package:diving_trip_agency/screens/report/company_liveaboard.dart';
import 'package:diving_trip_agency/screens/report/company_resort.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';
import 'package:intl/intl.dart';

List<ReportTrip> trips = [];
List<ReportTrip> endedTrips = [];
List<Diver> diver = [];
List<Diver> endedDiver = [];
List<ReportTrip> incomingTrips = [];
List<Diver> incomingDiver = [];
List<Reservation> reservationIncoming = [];
List<Reservation> reservation = [];
GetProfileResponse user_profile = new GetProfileResponse();
var profile;

class CompanyReport extends StatefulWidget {
  @override
  State<CompanyReport> createState() => _CompanyReportState();
}

class _CompanyReportState extends State<CompanyReport> {
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
    // return profile;

    if (profile.hasAgency()) {
      user_profile = profile;
      return user_profile;
    }
  }

  getValidTrip() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = AgencyServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var listvalidtriprequest = GenerateCurrentTripsReportRequest();
    listvalidtriprequest.limit = Int64(20);
    listvalidtriprequest.offset = Int64(0);
    trips.clear();
    diver.clear();
    reservation.clear();
    try {
      await for (var feature
          in stub.generateCurrentTripsReport(listvalidtriprequest)) {
        //print(feature.trip);
        trips.add(feature.report);

        //diver
        for (int j = 0; j < trips.length; j++) {
          for (int k = 0; k < trips[j].divers.length; k++) {
            diver.add(trips[j].divers[k]);
          }
        }
        //reservation
        for (int j = 0; j < trips.length; j++) {
          for (int k = 0; k < trips[j].reservations.length; k++) {
            reservation.add(trips[j].reservations[k]);
          }
        }

        // print(trips);
        // print(trips.length);

      }
    } catch (e) {
      print('valid');
      print('ERROR: $e');
    }
    // print(diver);
    return trips;
  }

  getEndedTrip() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = AgencyServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var listendedtriprequest = GenerateYearlyEndedTripsReportRequest();
    listendedtriprequest.limit = Int64(20);
    listendedtriprequest.offset = Int64(0);
    endedTrips.clear();
    endedDiver.clear();
    // print(endedTrips);
    try {
      await for (var feature
          in stub.generateYearlyEndedTripsReport(listendedtriprequest)) {
        // print(feature);
        // print(feature.reports);
        for (int i = 0; i < feature.reports.length; i++) {
          // print(feature.reports[i]);
          endedTrips.add(feature.reports[i]);
          // print(endedTrips);

        }
        //diver
        for (int j = 0; j < endedTrips.length; j++) {
          for (int k = 0; k < endedTrips[j].divers.length; k++) {
            endedDiver.add(endedTrips[j].divers[k]);
          }
        }
      }
    } catch (e) {
      print('end');
      print('ERROR: $e');
    }
    // print(endedDiver);
    return endedTrips;
  }

  getIncomingTrip() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = AgencyServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var listincomingtriprequest = GenerateIncomingTripsReportRequest();
    listincomingtriprequest.limit = Int64(20);
    listincomingtriprequest.offset = Int64(0);
    listincomingtriprequest.weeks = 4;
    incomingTrips.clear();
    incomingDiver.clear();
    reservationIncoming.clear();

    try {
      await for (var feature
          in stub.generateIncomingTripsReport(listincomingtriprequest)) {
        incomingTrips.add(feature.report);
        //diver
        for (int j = 0; j < incomingTrips.length; j++) {
          for (int k = 0; k < incomingTrips[j].divers.length; k++) {
            incomingDiver.add(incomingTrips[j].divers[k]);
          }
        }
        //reservation
        for (int j = 0; j < incomingTrips.length; j++) {
          for (int k = 0; k < incomingTrips[j].reservations.length; k++) {
            reservationIncoming.add(incomingTrips[j].reservations[k]);
          }
        }
      }
    } catch (e) {
      print('incoming');
      print('ERROR: $e');
    }
    return incomingTrips;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SectionTitle(
            title: "All Trips",
            color: Color(0xFFFF78a2cc),
          ),
          SizedBox(height: 40),
          SizedBox(
            width: 1110,
            child: FutureBuilder(
              future: getProfile(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(children: [
                    SizedBox(
                      width: 1110,
                      child: FutureBuilder(
                        future: getIncomingTrip(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Center(
                                child: user_profile.hasAgency() &&
                                        incomingTrips.length != 0
                                    ? Column(
                                        children: [
                                          Container(
                                            margin: EdgeInsets.symmetric(
                                                vertical: 20),
                                            constraints:
                                                BoxConstraints(maxWidth: 1110),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  'Incoming Trips',
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                )),
                                          ),
                                          Container(
                                              child: Wrap(
                                                  spacing: 20,
                                                  runSpacing: 40,
                                                  children: List.generate(
                                                    incomingTrips.length,
                                                    (indexIncoming) => Center(
                                                      child: IncomingCard(
                                                        indexIncoming,
                                                      ),
                                                    ),
                                                  ))),
                                        ],
                                      )
                                    : Text('No incoming trip'));
                          } else {
                            return Text('No data');
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    SizedBox(
                      width: 1110,
                      child: FutureBuilder(
                        future: getValidTrip(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Center(
                              child: user_profile.hasAgency() &&
                                      trips.length != 0
                                  ? Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20),
                                          constraints:
                                              BoxConstraints(maxWidth: 1110),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Trips',
                                                style: TextStyle(fontSize: 20),
                                              )),
                                        ),
                                        Container(
                                            child: Wrap(
                                                spacing: 20,
                                                runSpacing: 40,
                                                children: List.generate(
                                                  trips.length,
                                                  (indexTrip) => Center(
                                                    child: InfoCard(
                                                      indexTrip,
                                                    ),
                                                  ),
                                                ))),
                                      ],
                                    )
                                  : Text('No trip'),
                            );
                          } else {
                            return Text('No data');
                          }
                        },
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    SizedBox(
                      width: 1110,
                      child: FutureBuilder(
                        future: getEndedTrip(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Center(
                              // child: Text('test'),
                              child: user_profile.hasAgency() &&
                                      endedTrips.length != 0
                                  ? Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.symmetric(
                                              vertical: 20),
                                          constraints:
                                              BoxConstraints(maxWidth: 1110),
                                          child: Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                'Ended trips',
                                                style: TextStyle(fontSize: 20),
                                              )),
                                        ),
                                        Container(
                                            child: Wrap(
                                                spacing: 20,
                                                runSpacing: 40,
                                                children: List.generate(
                                                  endedTrips.length,
                                                  (indexEndedTrip) => Center(
                                                    child: InfoCardEnded(
                                                      indexEndedTrip,
                                                    ),
                                                  ),
                                                ))),
                                      ],
                                    )
                                  : Text('No ended trip'),
                            );
                          } else {
                            return Text('No data');
                          }
                        },
                      ),
                    ),
                  ]);
                } else {
                  return Center(child: Text('User is not logged in'));
                }
              },
            ),
          ),
          SizedBox(
            height: 40,
          )
        ],
      ),
    );
  }
}

class InfoCard extends StatefulWidget {
  int indexTrip;
  InfoCard(int indexTrip) {
    this.indexTrip = indexTrip;
  }

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
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CompanyCheckpayment(
                    diver,
                    widget.indexTrip,
                    trips[widget.indexTrip].reservations,
                    trips)));

        // if (trips[widget.index].tripTemplate.tripType.toString() == "ONSHORE") {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => CompanyResort(widget.index, trips)));
        // } else {
        //   Navigator.push(
        //       context,
        //       MaterialPageRoute(
        //           builder: (context) => CompanyLiveaboard(widget.index, trips)));
        // }
      },
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
                child: trips[widget.indexTrip].tripTemplate.images.length == 0
                    ? new Container(
                        color: Colors.pink,
                      )
                    : Image.network(trips[widget.indexTrip]
                        .tripTemplate
                        .images[0]
                        .link
                        .toString())),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text('Trip name : ' +
                            trips[widget.indexTrip].tripTemplate.name),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Location : ' +
                            trips[widget.indexTrip].tripTemplate.address.city +
                            ', ' +
                            trips[widget.indexTrip]
                                .tripTemplate
                                .address
                                .country),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Start date : ' +
                            DateFormat("dd/MM/yyyy").format(
                                trips[widget.indexTrip]
                                    .startDate
                                    .toDateTime())),

                        SizedBox(
                          height: 10,
                        ),
                        Text('End date : ' +
                            DateFormat("dd/MM/yyyy").format(
                                trips[widget.indexTrip].endDate.toDateTime())),

                        SizedBox(
                          height: 10,
                        ),
                        Text('Total people : ' +
                            trips[widget.indexTrip].maxGuest.toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Number of divers left : ' +
                            trips[widget.indexTrip].placesLeft.toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Trip type : ' +
                            trips[widget.indexTrip]
                                .tripTemplate
                                .tripType
                                .toString()),
                        SizedBox(
                          height: 10,
                        ),
                        // Text('List of divers'),
                        // diver.length == 0
                        //     ? new Text("No diver")
                        //     : new Text("Firstname : " +
                        //         diver[widget.index].firstName +
                        //         " Lastname : " +
                        //         diver[widget.index].lastName +
                        //         "  \nPhone number :" +
                        //         diver[widget.index].phone +
                        //         " Level :" +
                        //         diver[widget.index].level.toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text('Price : ' +
                                trips[widget.indexTrip].price.toString())),
                        SizedBox(
                          height: 20,
                        ),
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

class InfoCardEnded extends StatefulWidget {
  int indexEndedTrip;
  InfoCardEnded(int indexEndedTrip) {
    this.indexEndedTrip = indexEndedTrip;
  }

  @override
  State<InfoCardEnded> createState() => _InfoCardEndedState();
}

class _InfoCardEndedState extends State<InfoCardEnded> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // onTap: () {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) =>
      //             CompanyCheckpayment(endedDiver, widget.indexEndedTrip)));

      // if (trips[widget.index].tripTemplate.tripType.toString() == "ONSHORE") {
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) =>
      //               CompanyResort(widget.index, endedTrips)));
      // } else {
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) =>
      //               CompanyLiveaboard(widget.index, endedTrips)));
      // }
      // },
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
                child: endedTrips[widget.indexEndedTrip]
                            .tripTemplate
                            .images
                            .length ==
                        0
                    ? new Container(
                        color: Colors.pink,
                      )
                    : Image.network(endedTrips[widget.indexEndedTrip]
                        .tripTemplate
                        .images[0]
                        .link
                        .toString())),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text('Trip name : ' +
                            endedTrips[widget.indexEndedTrip]
                                .tripTemplate
                                .name),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Location : ' +
                            endedTrips[widget.indexEndedTrip]
                                .tripTemplate
                                .address
                                .city +
                            ', ' +
                            endedTrips[widget.indexEndedTrip]
                                .tripTemplate
                                .address
                                .country),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Start date : ' +
                            DateFormat("dd/MM/yyyy").format(
                                endedTrips[widget.indexEndedTrip]
                                    .startDate
                                    .toDateTime())),
                        SizedBox(
                          height: 10,
                        ),
                        Text('End date : ' +
                            DateFormat("dd/MM/yyyy").format(
                                endedTrips[widget.indexEndedTrip]
                                    .endDate
                                    .toDateTime())),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Total people : ' +
                            endedTrips[widget.indexEndedTrip]
                                .maxGuest
                                .toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Number of divers left : ' +
                            endedTrips[widget.indexEndedTrip]
                                .placesLeft
                                .toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Trip type : ' +
                            endedTrips[widget.indexEndedTrip]
                                .tripTemplate
                                .tripType
                                .toString()),
                        SizedBox(
                          height: 10,
                        ),
                        endedDiver.length == 0
                            ? new Text("No diver")
                            : new Text("List of divers : " +
                                endedDiver[widget.indexEndedTrip].firstName +
                                endedDiver[widget.indexEndedTrip].lastName),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text('Price : ' +
                                endedTrips[widget.indexEndedTrip]
                                    .price
                                    .toString())),
                        SizedBox(
                          height: 20,
                        ),
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

class IncomingCard extends StatefulWidget {
  int indexIncoming;
  IncomingCard(int indexIncoming) {
    this.indexIncoming = indexIncoming;
  }

  @override
  State<IncomingCard> createState() => _IncomingCardState();
}

class _IncomingCardState extends State<IncomingCard> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        //  print( incomingTrips[widget.indexIncoming].reservations);
        //  print(reservationIncoming);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CompanyCheckpayment(
                    incomingDiver,
                    widget.indexIncoming,
                    incomingTrips[widget.indexIncoming].reservations,
                    incomingTrips)));
        //   // if (trips[widget.index].tripTemplate.tripType.toString() == "ONSHORE") {
        //   //   Navigator.push(
        //   //       context,
        //   //       MaterialPageRoute(
        //   //           builder: (context) =>
        //   //               CompanyResort(widget.index, incomingTrips)));
        //   // } else {
        //   //   Navigator.push(
        //   //       context,
        //   //       MaterialPageRoute(
        //   //           builder: (context) =>
        //   //               CompanyLiveaboard(widget.index, incomingTrips)));
        //   // }
      },
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
                child: incomingTrips[widget.indexIncoming]
                            .tripTemplate
                            .images
                            .length ==
                        0
                    ? new Container(
                        color: Colors.pink,
                      )
                    : Image.network(incomingTrips[widget.indexIncoming]
                        .tripTemplate
                        .images[0]
                        .link
                        .toString())),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text('Trip name : ' +
                            incomingTrips[widget.indexIncoming]
                                .tripTemplate
                                .name),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Location : ' +
                            incomingTrips[widget.indexIncoming]
                                .tripTemplate
                                .address
                                .city +
                            ', ' +
                            incomingTrips[widget.indexIncoming]
                                .tripTemplate
                                .address
                                .country),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Start date : ' +
                            DateFormat("dd/MM/yyyy").format(
                                incomingTrips[widget.indexIncoming]
                                    .startDate
                                    .toDateTime())),
                        SizedBox(
                          height: 10,
                        ),
                        Text('End date : ' +
                            DateFormat("dd/MM/yyyy").format(
                                incomingTrips[widget.indexIncoming]
                                    .endDate
                                    .toDateTime())),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Total people : ' +
                            incomingTrips[widget.indexIncoming]
                                .maxGuest
                                .toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Number of divers left : ' +
                            incomingTrips[widget.indexIncoming]
                                .placesLeft
                                .toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Trip type : ' +
                            incomingTrips[widget.indexIncoming]
                                .tripTemplate
                                .tripType
                                .toString()),
                        SizedBox(
                          height: 10,
                        ),

                        // Text('List of divers'),
                        // incomingDiver.length == 0
                        //     ? new Text("No diver")
                        //     : new Text("Firstname : " +
                        //         incomingDiver[widget.index].firstName +
                        //         " Lastname : " +
                        //         incomingDiver[widget.index].lastName +
                        //         "  \nPhone number :" +
                        //         incomingDiver[widget.index].phone +
                        //         " Level :" +
                        //         incomingDiver[widget.index].level.toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text('Price : ' +
                                incomingTrips[widget.indexIncoming]
                                    .price
                                    .toString())),
                        SizedBox(
                          height: 20,
                        ),
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
