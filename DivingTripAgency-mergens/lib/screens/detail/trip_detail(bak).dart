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

// This list holds the data for the list view
List<TripWithTemplate> _foundtrip = [];
List costchecklist = [];
List durationchecklist = [];

String dropdownValue = "All";
String dropdownValue2 = "All";
enum Cost { one, two, three, more, all }

List<TripWithTemplate> trips = [];
// List<TripWithTemplate> allTrips = [];

class TripDetail extends StatefulWidget {
  // SearchTripsResponse_Trip tripdetail ;
  // TripDetail(SearchTripsResponse_Trip tripdetail){
  //   this.tripdetail=tripdetail;

  // }
  _TripDetailState createState() => _TripDetailState();
}

class _TripDetailState extends State<TripDetail> {
  // _TripDetailState(SearchTripsResponse_Trip tripdetail){
  //   this.tripdetail=tripdetail;

  // }
  //  SearchTripsResponse_Trip tripdetail ;
  DateTime _dateFrom;
  DateTime _dateTo;
  String _diff = "";
  bool value = false;
  int guestvalue;
  Cost tripcost = Cost.all;
  @override
  initState() {
    // at the beginning, all users are shown
    super.initState();
    costchecklist = [false, false, false, false, false];
    durationchecklist = [false, false, false, false, false, false];

    dropdownValue = 'All';
    dropdownValue2 = 'All';
    _foundtrip = trips;
    //  trips;
  }

  getTrip() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = TripServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var listtriprequest = ListValidTripsRequest();
    listtriprequest.limit = Int64(20);
    listtriprequest.offset = Int64(0);
    trips.clear();
    try {
      await for (var feature in stub.listValidTrips(listtriprequest)) {
        trips.add(feature.trip);
        // print(trips);
      }
    } catch (e) {
      print('ERROR: $e');
    }

    return trips;
  }

  searchData() async {;
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
    var searchtrips = SearchTripsOptions();

    searchtrips.country = '5';
    // searchtrips.country = 'm';

    //  searchtrips.country = dropdownValue;
    searchtrips.divers = 1;
    // searchtrips.divers =guestvalue;
    var ts = Timestamp();
    ts.seconds = Int64(1643670395);
    searchtrips.startDate = ts;
    var ts2 = Timestamp();
    // ts2.seconds = Int64(1645996634);
    ts2.seconds = Int64(1648767995);
    searchtrips.endDate = ts2;

    // searchtrips.tripType = TripType.OFFSHORE;
    var searchtriprequest = SearchTripsRequest();
    searchtriprequest.limit = Int64(100);
    searchtriprequest.offset = Int64(100);
    searchtriprequest.searchTripsOptions = searchtrips;

    trips.clear();
    // print(listonshorerequest);
    // stub.searchTrips(listonshorerequest);
    //print(listtriprequest);
    try {
      await for (var feature in stub.searchTrips(searchtriprequest)) {
        // print(feature.trip.price);
        // print(feature.trip.fromDate);
        // print(feature.trip.toDate);
        // print(feature.trip.maxGuest);
        // print(feature.trip.tripTemplate.address.city);
        // print(feature.trip.tripTemplate.images);
        //  print(feature.trip);
        trips.add(feature.trip);
        //  print(trips.length);
        // tripMap[feature.trip.toString()] = feature.trip.id;
      }
    } catch (e) {
      print('ERROR: $e');
    }
    // print('---');
    return trips;
    // print(trips.length);
    // print('****');
  }

  Widget build(BuildContext context) {
    //   _foundtrip = LiveAboardDatas;
    //   // print('candy mai suay');
    //   // print(_foundtrip[1].id);
    //   // print(_foundtrip[2].id);
    //   // print(_foundtrip[3].id);
    double screenwidth = MediaQuery.of(context).size.width;

    return Row(children: [
      Expanded(
          flex: 3,
          child: Column(children: [
            Container(
                margin: EdgeInsets.all(10.0),
                padding: EdgeInsets.all(10.0),
                height: 1800,
                width: screenwidth,
                decoration: BoxDecoration(
                  color: Colors.red[50],
                ),
                child: Column(children: [
                  Container(
                      width: 1000,
                      child: Row(children: [
                        Text(
                          "SEARCH",
                          style: TextStyle(fontSize: 20),
                        ),
                        Spacer(),
                        ElevatedButton(
                          style: TextButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            _runFilter();
                          },
                          child: const Text('Search'),
                        )
                      ])),
                  SizedBox(height: 20),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text('Start Date'),
                      Spacer(),
                      // Text(_dateFrom == null ? '' : _dateFrom.toString()),
                       Text(_dateFrom == null
                          ? ''
                          : DateFormat("dd/MM/yyyy").format(_dateFrom)),
                      Spacer(),
                      RaisedButton(
                          color: Color(0xfff8dd9cc),
                          child: Text('Pick a date'),
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now().subtract(Duration(days:60)),
                                    lastDate: DateTime.now().add(Duration(days:30)))
                                .then((date) => {
                                      setState(() {
                                        var timeStamp =
                                            //  print(Timestamp.fromDateTime(date));
                                            _dateFrom = date;
                                      })
                                    });
                          }),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text('To'),
                      Spacer(),
                      // Text(_dateTo == null ? '' : _dateTo.toString()),
                       Text(_dateTo == null
                          ? ''
                          : DateFormat("dd/MM/yyyy").format(_dateFrom)),
                      Spacer(),
                      RaisedButton(
                          color: Color(0xfff8dd9cc),
                          child: Text('Pick a date'),
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                firstDate: DateTime.now().subtract(Duration(days:60)),
                                lastDate: DateTime.now().add(Duration(days:30)))
                                .then((date) => {
                                      setState(() {
                                        var timeStamp =
                                            //    print(Timestamp.fromDateTime(date));
                                            _dateTo = date;
                                      })
                                    });
                          }),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text('Location'),
                      Spacer(),
                      Container(
                        width: screenwidth * 0.05,
                        child: DropdownButton<String>(
                          value: dropdownValue,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          iconSize: 30,
                          isExpanded: true,
                          style: const TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.black,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue = newValue;
                            });
                          },
                          items: <String>[
                            'All',
                            'Bangkok',
                            'Phuket',
                            'Krabi',
                            'Samui island',
                            'Trat',
                            'test',
                            'Koh Samet',
                            'Rayong',
                            'Chanthaburi'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        child: Text('Number of customers'),
                        width: screenwidth * 0.05,
                      ),
                      Spacer(),
                      Container(
                        width: screenwidth * 0.05,
                        height: 30,
                        child: TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            fillColor: Colors.white,
                            // hintText: 'Number of customer'
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              guestvalue = int.parse(newValue);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        child: Text('Trip Duration (days)'),
                        width: screenwidth * 0.05,
                      ),
                      Spacer(),
                      Container(
                        width: screenwidth * 0.05,
                        height: 30,
                        child: TextField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              fillColor: Colors.white,
                              // hintText: 'Trip Duration (days)'
                            ),
                            onChanged: (String newvalue) {
                              setState(() {
                                _diff = newvalue;
                              });
                            }),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text('Trip type'),
                      Spacer(),
                      Container(
                        width: screenwidth * 0.05,
                        child: DropdownButton<String>(
                          value: dropdownValue2,
                          icon: const Icon(Icons.arrow_downward),
                          elevation: 16,
                          iconSize: 30,
                          isExpanded: true,
                          style: const TextStyle(color: Colors.black),
                          underline: Container(
                            height: 2,
                            color: Colors.black,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              dropdownValue2 = newValue;
                            });
                          },
                          items: <String>['All', 'Onshore', 'Offshore']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Align(
                      alignment: Alignment.topLeft,
                      child: Text("Price (per person/trip)")),
                  Container(
                      child: Column(
                    children: <Widget>[
                      ListTile(
                        title: const Text('all'),
                        leading: Radio<Cost>(
                          value: Cost.all,
                          groupValue: tripcost,
                          onChanged: (Cost value) {
                            setState(() {
                              tripcost = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('0 - 1,000'),
                        leading: Radio<Cost>(
                          value: Cost.one,
                          groupValue: tripcost,
                          onChanged: (Cost value) {
                            setState(() {
                              tripcost = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('1,000 - 2,000'),
                        leading: Radio<Cost>(
                          value: Cost.two,
                          groupValue: tripcost,
                          onChanged: (Cost value) {
                            setState(() {
                              tripcost = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('2,000 - 3,000'),
                        leading: Radio<Cost>(
                          value: Cost.three,
                          groupValue: tripcost,
                          onChanged: (Cost value) {
                            setState(() {
                              tripcost = value;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('3,000 +'),
                        leading: Radio<Cost>(
                          value: Cost.more,
                          groupValue: tripcost,
                          onChanged: (Cost value) {
                            setState(() {
                              tripcost = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ))
                ])),
          ])),
      Expanded(
          flex: 7,
          child: Material(
            type: MaterialType.transparency,
            child: SingleChildScrollView(

              child: Container(

                  // margin: EdgeInsetsDirectional.only(top:120),
                width: screenwidth * 0.05,
                // height: 600,
                decoration:
                    BoxDecoration(color: Color(0xfffd4f0f7).withOpacity(0.3)),
                child: Column(
                  children: [
                    SectionTitle(
                      title: "All Trips",
                      color: Color(0xFFFF78a2cc),
                    ),
                    SizedBox(height: 40),
                    // Text(trips.length.toString()),
                    SizedBox(
                      width: 1110,
                      child: FutureBuilder(
                        future: getTrip(),
                        // searchData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            // debugPrint(
                            //     'Step 3, build widget: ${snapshot.data}');
                            // Build the widget with data.
                            return Center(
                                child: Container(
                                    child: Wrap(
                                        spacing: 20,
                                        runSpacing: 40,
                                        children: List.generate(
                                          _foundtrip.length,
                                          (index) => Center(
                                            child: InfoCard(
                                              index: index,
                                            ),
                                          ),
                                        ))));
                            //Text('hasData: ${snapshot.data}')));
                          } else {
                            // We can show the loading view until the data comes back.
                            // debugPrint('Step 1, build loading widget');
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                    // Text(trips[trips.length].diveMasters.toString()),
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


  void _runFilter() {
    print("Date diff: "+_diff);
   // print("Dropdownvalue2:"+dropdownValue2);
   // print("Dropdownvalue:"+dropdownValue);
    List<TripWithTemplate> results = [];
   // print("_diff: " + _diff.toString());
    if (dropdownValue == "All" &&
        dropdownValue2 == "All" &&
        _dateFrom == null &&
        _dateTo == null &&
        guestvalue == null &&
        _diff == "" &&
        tripcost == Cost.all) {
     // print("Filtering 1");

      // if the search field is empty or only contains white-space, we'll display all users
      results = trips;
      //print("Date diff of trip 0: "+results[1].startDate.toDateTime().difference(results[1].toDate.toDateTime()).inDays.abs().toString());
    //print(results[0].tripTemplate.tripType.toString());
      //results[0].tripTemplate.tripType.toString();
      setState(() {
        _foundtrip = results;
      });
    } else {
      //print("Guestvalue" + guestvalue.toString());
      results = trips;
      setState(() {
        _foundtrip =  results;
      });
      //print(_dateFrom);
      //print(results[0].fromDate.toDateTime());
      //print(results[1].fromDate.toDateTime());

      if (dropdownValue != "All") {
       // print("Filtering 2");
        results = results
            .where((trip) =>
                trip.tripTemplate.address.city.contains(dropdownValue))
            .toList();
      }
      if (_dateFrom != null) {
        results = results
            .where((trip) => trip.fromDate.toDateTime().isAfter(_dateFrom))
            .toList();
        //print(_dateFrom);
        //print(results[0].fromDate.toDateTime());
        //print(results[0].fromDate.toDateTime().isAfter(_dateFrom));
      }
      if (_dateTo != null) {
        results = results
            .where((trip) => trip.toDate
                .toDateTime()
                .subtract(Duration(days: 1))
                .isBefore(_dateTo))
            .toList();
      }

      if (guestvalue != null) {
        results = results.where((trip) => trip.maxGuest <= guestvalue).toList();
        //print(results[0].maxGuest);
      }
      if (dropdownValue2 != "All") {
        if (dropdownValue2 == "Onshore") {
         // print("dropdownValue 2 (Should be onshore):"+dropdownValue2);
          results = results
              .where(
                  (trip) => trip.tripTemplate.tripType.toString() == "ONSHORE")
              .toList();
          print(results[0].tripTemplate.tripType.toString());
        } else {
          //print("dropdownValue 2 (Should be Offshore):"+dropdownValue2);
          results = results
              .where(
                  (trip) => trip.tripTemplate.tripType.toString() == "OFFSHORE")
              .toList();
          print(results[0].tripTemplate.tripType.toString());
        }
      }
      if (_diff != "") {
        print(_diff);

        results = results
            .where((trip) =>
                (trip.fromDate
                        .toDateTime()
                        .difference(trip.toDate.toDateTime())
                        .inDays)
                    .abs() ==
                int.parse(_diff))
            .toList();
        //print((results[1].fromDate.toDateTime().difference(results[1].toDate.toDateTime()).inDays).abs());
        //print(_diff);
      }
// Edit cost filter
      if (tripcost != Cost.all) {
        if (tripcost == Cost.one) {
          results = results.where((trip) => (trip.price > 0 && trip.price <= 1000)).toList();
        } else if (tripcost == Cost.two) {
          results = results.where((trip) => (trip.price > 1000 && trip.price <= 2000)).toList();
        } else if (tripcost == Cost.three) {
          results = results.where((trip) => (trip.price > 2000 && trip.price <= 3000)).toList();
        } else if (tripcost == Cost.more) {
          results = results.where((trip) => (trip.price > 3000)).toList();
        }
      }

      setState(() {
        _foundtrip = results;
      });
    }
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
                child: _foundtrip[widget.index].tripTemplate.images.length == 0
                    ? new Container(
                        color: Colors.pink,
                      )
                    : Image.network(
                      // 'http://139.59.101.136/static/'+
                        // 'http:/139.59.101.136/static/1bb37ca5171345af86ff2e052bdf7dee.jpg'
                        _foundtrip[widget.index]
                            .tripTemplate
                            .images[0]
                            .link
                            .toString()

                        // _foundtrip[widget.index].tripTemplate.images[0].toString()
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
                        Text('Trip name : ' +
                            _foundtrip[widget.index].tripTemplate.name),

                        SizedBox(
                          height: 10,
                        ),
                        Text('Location : ' +
                            _foundtrip[widget.index].tripTemplate.address.city +
                            ', ' +
                            _foundtrip[widget.index]
                                .tripTemplate
                                .address
                                .country),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Start date : ' +
                            _foundtrip[widget.index]
                                .fromDate
                                .toDateTime()
                                .toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Text('End date : ' +
                            _foundtrip[widget.index]
                                .toDate
                                .toDateTime()
                                .toString()),
                        SizedBox(
                          height: 10,
                        ),

                        // SizedBox(
                        //   height: 10,
                        // ),
                        // Text(LiveAboardDatas[widget.index].description),
                        Text('Total people : ' +
                            _foundtrip[widget.index].maxGuest.toString()),
                        SizedBox(
                          height: 10,
                        ),

                        Text('Trip type : ' +
                            _foundtrip[widget.index]
                                .tripTemplate
                                .tripType
                                .toString()),
                        SizedBox(
                          height: 10,
                        ),
                        Align(
                            alignment: Alignment.centerRight,
                            child: Text('Price : ' +
                                _foundtrip[widget.index].price.toString())),
                        SizedBox(
                          height: 20,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: RaisedButton(
                            onPressed: () {
                              // print(_foundtrip[widget.index]

                              //   .tripTemplate
                              //   .tripType
                              //   .toString());
                              if (_foundtrip[widget.index]
                                      .tripTemplate
                                      .tripType
                                      .toString() ==
                                  "ONSHORE") {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DiveResortDetailScreen(
                                                widget.index, trips)));
                              } else {
                                // print(_foundtrip[widget.index]);
                                // print('------------------');
                                // print(widget.index);
                                // print('***');
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            LiveaboardDetailScreen(
                                                widget.index, trips)));
                              }
                            },
                            color: Colors.amber,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Text("View package"),
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
