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
  double fontsize = 20;
  @override
  initState() {
    // at the beginning, all users are shown
    super.initState();

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

  searchData() async {
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

    searchtrips.divers = 1;

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
    double screenwidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenwidth,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 2,
                child: Container(
                    margin: EdgeInsets.all(10.0),
                    padding: EdgeInsets.all(10.0),
                    //height: 1080,

                    decoration: BoxDecoration(color: Colors.red[50]),
                    child: Column(children: [
                      Wrap(spacing: 10, children: [
                        AutoSizeText(
                          "SEARCH",
                          maxFontSize: fontsize,
                          minFontSize: 10,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        ElevatedButton(
                            style: TextButton.styleFrom(
                              textStyle: const TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              _runFilter();
                            },
                            child: AutoSizeText(
                              "Search",
                              maxFontSize: fontsize,
                              minFontSize: 5,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ))
                      ]),
                      SizedBox(height: 20),
                      Wrap(
                        spacing: 10,
                        children: [
                          Text('Start Date'),
                          //Spacer(),
                          // Text(_dateFrom == null ? '' : _dateFrom.toString()),
                          AutoSizeText(_dateFrom == null
                              ? ''
                              : DateFormat("dd/MM/yyyy").format(_dateFrom)),
                          //Spacer(),
                          RaisedButton(
                              color: Color(0xfff8dd9cc),
                              child: AutoSizeText('Pick a date'),
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: DateTime(2023))
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
                      Wrap(
                        spacing: 10,
                        children: [
                          Text('To'),
                         // Spacer(),
                          // Text(_dateTo == null ? '' : _dateTo.toString()),
                          Text(_dateTo == null
                              ? ''
                              : DateFormat("dd/MM/yyyy").format(_dateTo)),
                          //Spacer(),
                          RaisedButton(
                              color: Color(0xfff8dd9cc),
                              child: Text('Pick a date'),
                              onPressed: () {
                                showDatePicker(
                                        context: context,
                                        initialDate: _dateFrom,
                                        firstDate: _dateFrom,
                                        lastDate: DateTime(2023))
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
                      Wrap(
                        spacing: 10,
                        children: [
                          Text('Location'),
                         // Spacer(),
                          DropdownButton<String>(
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
                              'Pattaya',
                              'Chumphon',
                              'Chanthaburi',
                              'Surat Thani',
                              'Koh Tao',
                              'Krabi'
                            ].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Wrap(
                        spacing: 10,
                        children: [
                          Text('Number of customers'),
                          //Spacer(),
                          TextField(
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
                        ],
                      ),
                      SizedBox(height: 20),
                      Wrap(
                        spacing: 10,
                        children: [
                          AutoSizeText('Trip Duration (days)'),
                         // Spacer(),
                          TextField(
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
                        ],
                      ),
                      SizedBox(height: 20),
                      Wrap(
                        spacing: 10,
                        children: [
                          AutoSizeText('Trip type'),
                          //Spacer(),
                          DropdownButton<String>(
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
                        ],
                      ),
                      SizedBox(height: 20),
                      Align(
                          alignment: Alignment.topLeft,
                          child: Text("Price (per person/trip)")),
                      Container(
                          child: Wrap(
                        children: <Widget>[
                          ListTile(
                              contentPadding: EdgeInsets.only(left: 0),
                              title: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Radio<Cost>(
                                      value: Cost.all,
                                      groupValue: tripcost,
                                      onChanged: (Cost value) {
                                        setState(() {
                                          tripcost = value;
                                        });
                                      },
                                    ),
                                    Text(
                                      'all',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              )),
                          ListTile(
                              contentPadding: EdgeInsets.only(left: 0),
                              title: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    Radio<Cost>(
                                      value: Cost.one,
                                      groupValue: tripcost,
                                      onChanged: (Cost value) {
                                        setState(() {
                                          tripcost = value;
                                        });
                                      },
                                    ),
                                    Text('0 - 1,000'),
                                  ],
                                ),
                              )),
                          ListTile(
                            contentPadding: EdgeInsets.only(left: 0),
                            title: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(children: [
                                  Radio<Cost>(
                                    value: Cost.two,
                                    groupValue: tripcost,
                                    onChanged: (Cost value) {
                                      setState(() {
                                        tripcost = value;
                                      });
                                    },
                                  ),
                                  Text('1,000 - 2,000'),
                                ])),
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.only(left: 0),
                            title: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(children: [
                                  Radio<Cost>(
                                    value: Cost.three,
                                    groupValue: tripcost,
                                    onChanged: (Cost value) {
                                      setState(() {
                                        tripcost = value;
                                      });
                                    },
                                  ),
                                  Text('2,000 - 3,000'),
                                ])),
                          ),
                          ListTile(
                              contentPadding: EdgeInsets.only(left: 0),
                              title: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(children: [
                                    Radio<Cost>(
                                      value: Cost.more,
                                      groupValue: tripcost,
                                      onChanged: (Cost value) {
                                        setState(() {
                                          tripcost = value;
                                        });
                                      },
                                    ),
                                    Text('3,000 +'),
                                  ]))),
                        ],
                      ))
                    ] //Container of left side
                        ))),
            Expanded(
                flex: 6,
                child: Container(
                    child: Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          type: MaterialType.transparency,
                          child: SingleChildScrollView(
                            child: Container(
                              // margin: EdgeInsetsDirectional.only(top:120),

                              decoration: BoxDecoration(
                                  color: Color(0xfffd4f0f7).withOpacity(0.3)),
                              child: Wrap(
                                children: [
                                  SectionTitle(
                                    title: "Upcoming Trips",
                                    color: Color(0xFFFF78a2cc),
                                  ),
                                  SizedBox(height: 40),
                                  // Text(trips.length.toString()),
                                  SizedBox(
                                    child: FutureBuilder(
                                      future: getTrip(),
                                      // searchData(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          // debugPrint(
                                          //     'Step 3, build widget: ${snapshot.data}');
                                          // Build the widget with data.
                                          if (_foundtrip.length == 0) {
                                            return Text("No Data Available");
                                          } else {
                                            return ListView.builder(
                                                scrollDirection: Axis.vertical,
                                                shrinkWrap: true,
                                                itemCount: _foundtrip.length,
                                                itemBuilder: (context, index) {
                                                  return InfoCard(
                                                    index: index,
                                                  );
                                                });
                                          }
                                        } else {
                                          // We can show the loading view until the data comes back.
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
                        )))),
          ]),
    );
  }

  void _runFilter() {
    // print("Date diff: " + _diff);
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
        _foundtrip = results;
      });

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
        //results = results.where((trip) => trip.maxGuest >= guestvalue).toList();
        results = results
            .where((trip) => trip.maxGuest - trip.curentGuest >= guestvalue)
            .toList();
        //print(results[0].maxGuest);
      }
      if (dropdownValue2 != "All") {
      //  print("DropdownValue2");
      //  print(dropdownValue2);
        if (dropdownValue2 == "Onshore") {
          // print("dropdownValue 2 (Should be onshore):"+dropdownValue2);
          results = results
              .where(
                  (trip) => trip.tripTemplate.tripType.toString() == "ONSHORE")
              .toList();

        } else if (dropdownValue2 == "Offshore") {
          print("dropdownValue 2 (Should be Offshore):" + dropdownValue2);
          results = results
              .where(
                  (trip) => trip.tripTemplate.tripType.toString() == "OFFSHORE")
              .toList();

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
          results = results
              .where((trip) => (trip.price > 0 && trip.price <= 1000))
              .toList();
        } else if (tripcost == Cost.two) {
          results = results
              .where((trip) => (trip.price > 1000 && trip.price <= 2000))
              .toList();
        } else if (tripcost == Cost.three) {
          results = results
              .where((trip) => (trip.price > 2000 && trip.price <= 3000))
              .toList();
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
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                    child: _foundtrip[widget.index]
                                .tripTemplate
                                .images
                                .length ==
                            0
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
                            ))),

            // child: Image.asset(LiveAboardDatas[widget.index].image)),
            Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
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
                          DateFormat("dd/MM/yyyy").format(
                              _foundtrip[widget.index].fromDate.toDateTime())),
                      SizedBox(
                        height: 10,
                      ),
                      Text('End date : ' +
                          DateFormat("dd/MM/yyyy").format(
                              _foundtrip[widget.index].toDate.toDateTime())),
                      SizedBox(
                        height: 10,
                      ),

                      Text('Total people : ' +
                          _foundtrip[widget.index].maxGuest.toString()),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Place Left : ' +
                            (_foundtrip[widget.index].maxGuest -
                                    _foundtrip[widget.index].curentGuest)
                                .toString(),
                      ),
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
          ],
        ),
      ),
    );
  }
}