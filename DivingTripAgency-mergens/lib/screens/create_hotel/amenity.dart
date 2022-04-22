import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/amenity.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';

class amenityForm extends StatefulWidget {
  int bluecount;
  int pinkcount;
  List<List<Amenity>> blueValue;
  List<String> errors = [];

  amenityForm(int blue, int pinkcount, List<List<Amenity>> blueValue,
      List<String> errors) {
    this.bluecount = blue;
    this.pinkcount = pinkcount;
    this.blueValue = blueValue;
    this.errors = errors;
  }
  @override
  _amenityFormState createState() => _amenityFormState(
      this.bluecount, this.pinkcount, this.blueValue, this.errors);
}

class _amenityFormState extends State<amenityForm> {
  String amenity_name;
  String amenity_descption;
  int bluecount;
  int pinkcount;
  List<List<Amenity>> blueValue;
  //load
  List<DropdownMenuItem<String>> listAmenity = [];
  List<String> amenity = [];
  String amenitySelected;
  Map<String, dynamic> amenityMap = {};
  List<String> errors = [];
  _amenityFormState(int bluecount, int pinkcount, List<List<Amenity>> blueValue,
      List<String> errors) {
    this.bluecount = bluecount;
    this.pinkcount = pinkcount;
    this.blueValue = blueValue;
    this.errors = errors;
  }

  final TextEditingController _controllerAmenityName = TextEditingController();
  final TextEditingController _controllerAmenityDescription =
      TextEditingController();

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() async {
    await getAmenity();
    setState(() {
      listAmenity = [];
      listAmenity = amenity
          .map((val) => DropdownMenuItem<String>(child: Text(val), value: val))
          .toList();
    });
    // print('amenity');
    // amenity.forEach((element) {
    //   print(element);
    // });
  }

  getAmenity() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = AmenityServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var listamenityrequest = ListAmenitiesRequest();
    listamenityrequest.limit = Int64(20);
    listamenityrequest.offset = Int64(0);

    try {
      await for (var feature in stub.listAmenities(listamenityrequest)) {
        amenity.add(feature.amenities.name);
        amenityMap[feature.amenities.name] = feature.amenities.id;
        // print(amenityMap);
      }
    } catch (e) {
      print('ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(height: 20),
          Container(
            color: Color(0xfffd4f0f0),
            //color: Color(0xFFFd0efff),
            child: Center(
              child: DropdownButtonFormField(
                isExpanded: true,
                value: amenitySelected,
                items: listAmenity,
                dropdownColor: Color(0xfffd4f0f0),
                hint: Text('  Select amenity'),
                iconSize: 40,
                validator: (value) {
                  if (value == null) {
                    addError(error: "Please select amenity");
                    return "";
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value != null) {
                    removeError(error: "Please select amenity");
                    setState(() {
                      amenitySelected = value;
                      // print(amenitySelected);
                      // print(amenity);
                      amenity.forEach((element) {
                        // print(amenity);
                        // print('d');
                        // print(element);
                        // print(amenityMap[element]);
                        // print(amenitySelected);
                        if (element == amenitySelected) {
                          // print(amenityMap[element]);
                          blueValue[pinkcount - 1][bluecount - 1].name =
                              amenitySelected;
                          blueValue[pinkcount - 1][bluecount - 1].id =
                              amenityMap[element];
                        }
                      });

                      // print(blueValue);
                      // print('------');
                      // print(value);
                    });
                  }
                },
              ),
            ),
          ),
          // buildAmenityNameFormField(),
          // SizedBox(height: 20),
          // buildAmenityDescriptionFormField(),
          SizedBox(height: 20),
        ]),
      ),
    );
  }

  TextFormField buildAmenityNameFormField() {
    return TextFormField(
      controller: _controllerAmenityName,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => amenity_name = newValue,
      onChanged: (value) {
        // print(' amenity name start');
        // print(bluecount);
        // print(pinkcount);
        // print(' amnity name end');
        blueValue[pinkcount - 1][bluecount - 1].name = value;
        // print(value);
        // print("===");
        if (value.isNotEmpty) {
          removeError(error: "Please enter amenity name");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter amenity name");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Amenity name",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildAmenityDescriptionFormField() {
    return TextFormField(
      controller: _controllerAmenityDescription,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => amenity_descption = newValue,
      onChanged: (value) {
        // print(' amenity desc start');
        // print(bluecount);
        // print(pinkcount);
        // print(' amnity desc end');
        blueValue[pinkcount - 1][bluecount - 1].description = value;
        // print(value);
        // print("===");
        if (value.isNotEmpty) {
          removeError(error: "Please enter amenity description");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter amenity description");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Amenity description",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
