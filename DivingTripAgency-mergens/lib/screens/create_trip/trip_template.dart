import 'package:diving_trip_agency/form_error.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';

import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:multi_image_picker2/multi_image_picker2.dart';

class Triptemplate extends StatefulWidget {
  TripTemplate triptemplate;
  // HotelAndBoatId hotelandboatID = new HotelAndBoatId();
  Address addressform = new Address();
  List<String> errors = [];
  Triptemplate(TripTemplate triptemplate, List<String> errors) {
    this.triptemplate = triptemplate;
    // this.triptemplate.hotelAndBoatId = hotelandboatID;
    this.triptemplate.address = addressform;
    this.errors = errors;
  }
  @override
  _TriptemplateState createState() =>
      _TriptemplateState(this.triptemplate, this.errors);
}

class _TriptemplateState extends State<Triptemplate> {
  String tripname;
  String description;
  io.File Pictrip;
  io.File Pictrip2;
  io.File Pictrip3;
  io.File Pictrip4;
  io.File Pictrip5;
  io.File Pictrip6;
  io.File Pictrip7;
  io.File Pictrip8;
  io.File Boatpic;
  io.File Schedule;

  XFile pt;
  XFile bt;
  XFile sc;
  String selected = null;

  Map<String, int> tripTypeMap = {};
  Map<String, dynamic> hotelTypeMap = {};
  Map<String, dynamic> liveaboardTypeMap = {};
  List<DropdownMenuItem<String>> listBoat = [];
  List<String> boat = [];
  String boatSelected;
  Map<String, dynamic> boatMap = {};

  List<DropdownMenuItem<String>> listTrip = [];
  List<TripType> trip = [TripType.ONSHORE, TripType.OFFSHORE];

  List<String> hotel = [];
  List<String> liveaboard = [];
  List<String> triptypee = [];
  String selectedTriptype;
  String selectedsleep;

  String address1;
  String address2;
  String postalCode;
  String country;
  String region;
  String city;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() async {
    trip.forEach((element) {
      // print(element);
    });
    await getData();
    setState(() {
      listBoat = [];
      listBoat = boat
          .map((val) => DropdownMenuItem<String>(child: Text(val), value: val))
          .toList();

      listTrip = [];
      listTrip = trip
          .map((val) => DropdownMenuItem<String>(
              child: Text(val.toString()), value: val.value.toString()))
          .toList();
      String value;

      for (var i = 0; i < TripType.values.length; i++) {
        value = TripType.valueOf(i).toString();
        tripTypeMap[value] = i;
      }
    });

    // print(tripTypeMap);
  }

  List<String> errors = [];
  String triptype = '';
  String boatname;
  TripTemplate triptemplate;
  // HotelAndBoatId hotelandboatID = new HotelAndBoatId();
  Address addressform = new Address();
  _TriptemplateState(TripTemplate triptemplate, List<String> errors) {
    this.triptemplate = triptemplate;
    // this.triptemplate.hotelAndBoatId = hotelandboatID;
    this.addressform = addressform;
    this.errors = errors;
  }
  final TextEditingController _controllerTripname = TextEditingController();
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerBoatname = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerAddress2 = TextEditingController();
  final TextEditingController _controllerPostalcode = TextEditingController();
  final TextEditingController _controllerCountry = TextEditingController();
  final TextEditingController _controllerRegion = TextEditingController();
  final TextEditingController _controllerCity = TextEditingController();

  /// Get from gallery
  _getPictrip(int num) async {
    pt = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    var f = File();
    f.filename = pt.name;
    //f2.filename = 'image.jpg';
    List<int> a = await pt.readAsBytes();
    f.file = a;
    //this.imagelist.add(f);
    this.triptemplate.images.add(f);

    if (pt != null) {
      setState(() {
        // imagelist.add(io.File(pt.path));
        if (num == 1) Pictrip = io.File(pt.path);
        if (num == 2) Pictrip2 = io.File(pt.path);
        if (num == 3) Pictrip3 = io.File(pt.path);
        if (num == 4) Pictrip4 = io.File(pt.path);
        if (num == 5) Pictrip5 = io.File(pt.path);
        if (num == 6) Pictrip6 = io.File(pt.path);
        if (num == 7) Pictrip7 = io.File(pt.path);
        if (num == 8) Pictrip8 = io.File(pt.path);
      });
    }
  }

  _getBoatpic() async {
    bt = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    var f2 = File();
    f2.filename = bt.name;
    //f2.filename = 'image.jpg';
    List<int> b = await bt.readAsBytes();
    f2.file = b;

    this.triptemplate.images.add(f2);

    if (bt != null) {
      setState(() {
        Boatpic = io.File(bt.path);
      });
    }
  }

  // Widget buildGridView() {
  // return Column(
  // children:[
  // Text("Gallery here:"),
  //Container(
  //height:100,
  //width:400,
  //             child:
  //  GridView.count(
  //  crossAxisCount: 3,
  //children: List.generate(imagelist.length, (index) {
  //Asset asset = imagelist[index];
  //return AssetThumb(
  // asset: asset,
  //width: 20,
  //height: 20,
  //);
  //}),
  //)
  //),

  // ]
  //) ;
  //}

  _getSchedule() async {
    sc = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );

    var f3 = File();
    f3.filename = sc.name;
    //f2.filename = 'image.jpg';
    List<int> c = await sc.readAsBytes();
    f3.file = c;

    this.triptemplate.images.add(f3);
    if (sc != null) {
      setState(() {
        Schedule = io.File(sc.path);
      });
    }
  }

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  getData() async {
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
    var hotelrequest = ListHotelsRequest();
    var liveaboardrequest = ListLiveaboardsRequest();
    var boatrequest = ListBoatsRequest();

    try {
      // var response = await stub.listBoats(boatrequest);
      // print(token);
      // print(response);

      await for (var feature in stub.listBoats(boatrequest)) {
        //   print(feature.boat.name);
        boat.add(feature.boat.name);
        boatMap[feature.boat.name] = feature.boat.id;
      }
      // print(boat);
      // print(boat.runtimeType);

      await for (var feature in stub.listHotels(hotelrequest)) {
        //  print(feature.hotel.name);
        hotel.add(feature.hotel.name);
        hotelTypeMap[feature.hotel.name] = feature.hotel.id;
      }
      await for (var feature in stub.listLiveaboards(liveaboardrequest)) {
        //print(feature.liveaboard.name);
        liveaboard.add(feature.liveaboard.name);
        liveaboardTypeMap[feature.liveaboard.name] = feature.liveaboard.id;
      }
    } catch (e) {
      print('ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    //loadData();
    // getData();
    return Container(
      color: Color(0xfffd4f0f0),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(height: 20),
          buildTripNameFormField(),
          SizedBox(height: 20),
          buildDescriptionFormField(),
          SizedBox(height: 20),
          buildAddressFormField(),
          SizedBox(height: 20),
          buildAddress2FormField(),
          SizedBox(height: 20),
          Row(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width / 3.6,
                  child: buildCountryFormField()),
              Spacer(),
              // Spacer(flex: 1,),
              Container(
                  width: MediaQuery.of(context).size.width / 3.6,
                  child: buildCityFormField()),
            ],
          ),

          SizedBox(height: 20),
          Row(
            children: [
              Container(
                  width: MediaQuery.of(context).size.width / 3.6,
                  child: buildRegionFormField()),
              Spacer(),
              Container(
                  width: MediaQuery.of(context).size.width / 3.6,
                  child: buildPostalCodeFormField()),
            ],
          ),
          SizedBox(height: 20),
          Container(
            //color: Colors.white,
            child: Center(
              child: DropdownButtonFormField(
                isExpanded: true,
                value: boatSelected,
                items: listBoat,
                //     boat.map((String value) {
                //   return DropdownMenuItem<String>(
                //     value: value,
                //     child: Text(value),
                //   );
                // }).toList(),

                hint: Text('  Select boat'),
                iconSize: 40,
                validator: (value) {
                  if (value == null) {
                    addError(error: "Please select boat");
                    return "";
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value != null) {
                    removeError(error: "Please select boat");
                    setState(() {
                      boatSelected = value;
                      print(value);
                      //  hotelandboatID.boatId = boatMap[boatSelected];

                      triptemplate.boatId = boatMap[boatSelected];

                      // triptemplate.hotelAndBoatId=hotelandboatID;
                      //   triptemplate.divingBoatId=boatMap[boatSelected];
                    });
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          // buildBoatNameFormField(),
          // SizedBox(height: 20),
          //radio
          // Row(children: [
          //   Text('Trip Type '),
          //   Spacer(),
          // ]),
          // Row(children: [
          //   Radio(
          //       value: 'On shore (Hotel)',
          //       groupValue: triptype,
          //       onChanged: (val) {
          //         // triptype = val;
          //         setState(() {
          //            triptype = val;
          //             print(val);

          //         });
          //       }),
          //   Text('On shore (Hotel)'),
          // ]),

          // Row(
          //   children: [
          //     Radio(
          //         value: 'Off shore (Live on boat)',
          //         groupValue: triptype,
          //         onChanged: (val) {
          //           // triptype = val;
          //           setState(() {
          //              triptype = val;
          //               print(val);
          //           });
          //         }),
          //     Text('Off shore (Live on boat)'),
          //   ],
          // ),

          // Container(
          //   color: Color(0xfffd4f0f0),
          //   child: Center(
          //     child: DropdownButton(
          //       isExpanded: true,
          //       value: selected,
          //       items: listTrip,
          //       hint: Text('  Select trip type'),
          //       iconSize: 40,
          //       onChanged: (value) {
          //         setState(() {
          //           selected = value;
          //           TripType.values.forEach((tripType) {
          //             if (tripTypeMap[tripType.toString()] ==
          //                 int.parse(selected)) {
          //               triptemplate.tripType = tripType;
          //             }
          //           });
          //           print(value);
          //         });
          //       },
          //     ),
          //   ),
          // ),

          DropdownButtonFormField(
            hint: Text('Trip type'),
            value: selectedTriptype,
            isExpanded: true,
            items: listTrip,
            validator: (value) {
              if (value == null) {
                addError(error: "Please select trip type");
                return "";
              }
              return null;
            },
            onChanged: (trip_type) {
              if (trip_type != null) {
                removeError(error: "Please select trip type");
                if (trip_type == '0') {
                  triptypee = hotel;
                } else if (trip_type == '1') {
                  triptypee = liveaboard;
                } else {
                  // print('x');
                  // print(trip_type);
                  // print(trip_type.runtimeType);
                  triptypee = [];
                }
                setState(() {
                  // print(triptypee);
                  // print('--');
                  selectedTriptype = trip_type;
                  selectedsleep = null;
                  TripType.values.forEach((tripType) {
                    if (tripTypeMap[tripType.toString()] ==
                        int.parse(selectedTriptype)) {
                      triptemplate.tripType = tripType;
                    }
                  });
                });
              }
              // print('*');
              // print(trip_type);
              // print('*');
              // if (trip_type ==0 ) {
              //   triptypee = liveaboard;
              // } else if (trip_type == 1) {
              //   triptypee = hotel;
              // }
              // else {
              //   triptypee = [];
              // }
            },
          ),
          SizedBox(height: 20),
          DropdownButtonFormField<String>(
            value: selectedsleep,
            // hint: Text('Sleep'),
            isExpanded: true,
            items: triptypee.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            validator: (value) {
              if (value == null) {
                addError(error: "Please select name");
                return "";
              }
              return null;
            },
            onChanged: (sleep) {
              if (sleep != null) {
                removeError(error: "Please select name");
                setState(() {
                  selectedsleep = sleep;
                  if (triptypee == liveaboard) {
                    // print('liveabaord');
                    // print(liveaboardTypeMap[selectedsleep]);
                    triptemplate.liveaboardId =
                        liveaboardTypeMap[selectedsleep];
                    // print('keep');
                    // print( triptemplate.liveaboardId);
                  } else if (triptypee == hotel) {
                    // print('hotel');
                    // print(hotelTypeMap[selectedsleep]);

                    triptemplate.hotelId = hotelTypeMap[selectedsleep];

                    // hotelandboatID.hotelId = hotelTypeMap[selectedsleep];
                    //  triptemplate.hotelAndBoatId=hotelandboatID;
                    //   triptemplate.hotelAndBoatId.hotelId= hotelTypeMap[selectedsleep];
                  }
                });
              }
            },
          ),
          SizedBox(height: 20),
          Row(
            //Pic1
            children: [
              Center(
                  child: Pictrip == null
                      ? Text('Trip image')
                      : kIsWeb
                          ? Image.network(
                              Pictrip.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(Pictrip.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                color: Color(0xfffa2c8ff),
                child: Text(
                  'Upload',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  _getPictrip(1);
                },
              ),
            ],
          ),

          SizedBox(height: 20),
          Row(
            children: [
              Center(
                  child: Pictrip2 == null
                      ? Text('Trip image')
                      : kIsWeb
                          ? Image.network(
                              Pictrip2.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(Pictrip2.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                color: Color(0xfffa2c8ff),
                child: Text(
                  'Upload',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  _getPictrip(2);
                },
              ),
            ],
          ),

          SizedBox(height: 20),
          Row(
            children: [
              Center(
                  child: Pictrip3 == null
                      ? Text('Trip image')
                      : kIsWeb
                          ? Image.network(
                              Pictrip3.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(Pictrip3.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                color: Color(0xfffa2c8ff),
                child: Text(
                  'Upload',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  _getPictrip(3);
                },
              ),
            ],
          ),

          SizedBox(height: 20),
          Row(
            children: [
              Center(
                  child: Pictrip4 == null
                      ? Text('Trip image')
                      : kIsWeb
                          ? Image.network(
                              Pictrip4.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(Pictrip4.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                color: Color(0xfffa2c8ff),
                child: Text(
                  'Upload',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  _getPictrip(4);
                },
              ),
            ],
          ),

          SizedBox(height: 20),
          Row(
            children: [
              Center(
                  child: Pictrip5 == null
                      ? Text('Trip image')
                      : kIsWeb
                          ? Image.network(
                              Pictrip5.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(Pictrip5.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                color: Color(0xfffa2c8ff),
                child: Text(
                  'Upload',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  _getPictrip(5);
                },
              ),
            ],
          ),

          SizedBox(height: 20),

          SizedBox(height: 20),
          Row(
            children: [
              Center(
                  child: Boatpic == null
                      ? Text('Boat image')
                      : kIsWeb
                          ? Image.network(
                              Boatpic.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(Boatpic.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                color: Color(0xfffa2c8ff),
                child: Text(
                  'Upload',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  _getBoatpic();
                },
              ),
            ],
          ),

          SizedBox(height: 20),
          Row(
            children: [
              Center(
                  child: Schedule == null
                      ? Text('Schedule')
                      : kIsWeb
                          ? Image.network(
                              Schedule.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(Schedule.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                color: Color(0xfffa2c8ff),
                child: Text(
                  'Upload',
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  _getSchedule();
                },
              ),
            ],
          ),

          // FormError(errors: errors),

          SizedBox(height: 20),

          //Container(
          // child:

          //buildGridView(),

          // )

          //  FlatButton(onPressed: getData, child: Text('check')),
        ]),
      ),
    );
  }

  TextFormField buildDescriptionFormField() {
    return TextFormField(
      controller: _controllerDescription,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => description = newValue,
      onChanged: (value) {
        triptemplate.description = value;
        // print(value);
        if (value.isNotEmpty) {
          removeError(error: "Please Enter Description");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter Description");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Description",
        filled: true,
        fillColor: Color(0xfffd4f0f0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildTripNameFormField() {
    return TextFormField(
      controller: _controllerTripname,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => tripname = newValue,
      onChanged: (value) {
        // print(triptemplate);
        // print(triptemplate.name);

        triptemplate.name = value;
        // print(value);
        if (value.isNotEmpty) {
          removeError(error: "Please Enter trip name");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter trip name");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Trip name",
        filled: true,
        fillColor: Color(0xfffd4f0f0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  // TextFormField buildBoatNameFormField() {
  //   return TextFormField(
  //     controller: _controllerBoatname,
  //     cursorColor: Color(0xFFf5579c6),
  //     onSaved: (newValue) => boatname = newValue,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: "Please Enter boat name");
  //       }
  //       return null;
  //     },
  //     validator: (value) {
  //       if (value.isEmpty) {
  //         addError(error: "Please Enter boat name");
  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: "Boat name",
  //       filled: true,
  //       fillColor: Color(0xfffd4f0f0),
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //     ),
  //   );
  // }

  TextFormField buildAddressFormField() {
    return TextFormField(
      controller: _controllerAddress,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => address1 = newValue,
      onChanged: (value) {
        //  addressform.addressLine1 = value;
        //   print(addressform.addressLine1);
        triptemplate.address.addressLine1 = value;
        if (value.isNotEmpty) {
          removeError(error: "Please enter address");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter address");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          //    hintText: "Address1",
          labelText: "Address 1",
          filled: true,
          fillColor: Color(0xfffd4f0f0),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.home)),
    );
  }

  TextFormField buildAddress2FormField() {
    return TextFormField(
      controller: _controllerAddress2,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => address2 = newValue,
      onChanged: (value) {
        // addressform.addressLine2 = value;
        triptemplate.address.addressLine2 = value;

        if (value.isNotEmpty) {
          removeError(error: "Please enter address");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter address");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          //   hintText: "Address2",
          labelText: "Address 2",
          filled: true,
          fillColor: Color(0xfffd4f0f0),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.home)),
    );
  }

  TextFormField buildCountryFormField() {
    return TextFormField(
      controller: _controllerCountry,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => country = newValue,
      onChanged: (value) {
        triptemplate.address.country = value;
        // addressform.country = value;
        if (value.isNotEmpty) {
          removeError(error: "Please enter country");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter country");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //   hintText: "Country",
        labelText: "Country",
        filled: true,
        fillColor: Color(0xfffd4f0f0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildCityFormField() {
    return TextFormField(
      controller: _controllerCity,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => city = newValue,
      onChanged: (value) {
        // addressform.city = value;
        triptemplate.address.city = value;
        if (value.isNotEmpty) {
          removeError(error: "Please enter city");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter city");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //   hintText: "City",
        labelText: "City",
        filled: true,
        fillColor: Color(0xfffd4f0f0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildRegionFormField() {
    return TextFormField(
      controller: _controllerRegion,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => region = newValue,
      onChanged: (value) {
        triptemplate.address.region = value;
        //  addressform.region = value;
        if (value.isNotEmpty) {
          removeError(error: "Please enter region");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter region");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //    hintText: "Region",
        labelText: "Region",
        filled: true,
        fillColor: Color(0xfffd4f0f0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildPostalCodeFormField() {
    return TextFormField(
      controller: _controllerPostalcode,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => postalCode = newValue,
      onChanged: (value) {
        triptemplate.address.postcode = value;
        //  addressform.postcode = value;
        if (value.isNotEmpty) {
          removeError(error: "Please enter postal code");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter postal code");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //   hintText: "Postal code",
        labelText: "Postal code",
        filled: true,
        fillColor: Color(0xfffd4f0f0),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
