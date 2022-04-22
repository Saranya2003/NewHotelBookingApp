import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/create_hotel/addMoreAmenity.dart';
import 'package:diving_trip_agency/screens/create_hotel/amenity.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:flutter/services.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';

class RoomForm extends StatefulWidget {
  int pinkcount;
  List<RoomType> pinkValue;
  List<List<Amenity>> blueValue;
  List<String> errors = [];

  RoomForm(int pinkcount, List<RoomType> pinkValue,
      List<List<Amenity>> blueValue, List<String> errors) {
    this.pinkcount = pinkcount;
    this.pinkValue = pinkValue;
    this.blueValue = blueValue;
    this.errors = errors;
  }
  @override
  _RoomFormState createState() => _RoomFormState(
      this.pinkcount, this.pinkValue, this.blueValue, this.errors);
}

class _RoomFormState extends State<RoomForm> {
  int pinkcount;
  String room_description;
  String max_capa;
  String price;
  // String amenity;
  String selected = null;
  io.File roomimg;
  String room_type;
  String room_name;
  String quantity;
  List<RoomType> pinkValue;
  List<List<Amenity>> blueValue;

  XFile rroom;
  List<String> errors = [];
  _RoomFormState(int pinkcount, List<RoomType> pinkValue,
      List<List<Amenity>> blueValue, List<String> errors) {
    this.pinkcount = pinkcount;
    this.pinkValue = pinkValue;
    this.blueValue = blueValue;
    this.errors = errors;
  }

  final TextEditingController _controllerRoomdescription =
      TextEditingController();
  final TextEditingController _controllerMax = TextEditingController();
  final TextEditingController _controllerPrice = TextEditingController();
  // final TextEditingController _controllerAmenity = TextEditingController();
  final TextEditingController _controllerRoomtype = TextEditingController();
  final TextEditingController _controllerRoomname = TextEditingController();
  final TextEditingController _controllerQuantity = TextEditingController();

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

  _getroomimg() async {
    rroom = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 5000,
      maxHeight: 5000,
    );
    var f2 = File();
    f2.filename = rroom.name;
    //f2.filename = 'image.jpg';
    List<int> a = await rroom.readAsBytes();
    f2.file = a;

    this.pinkValue[this.pinkcount - 1].roomImages.add(f2);

    if (rroom != null) {
      setState(() {
        roomimg = io.File(rroom.path);
        // rroom = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(height: 20),
          // Container(
          //   color: Color(0xffffee1e8),
          //   child: Center(
          //     child: DropdownButton(
          //       isExpanded: true,
          //       value: selected,
          //       items: listRoom,
          //       hint: Text('  Select room type'),
          //       iconSize: 40,
          //       onChanged: (value) {
          //         setState(() {
          //           selected = value;
          //           print(value);
          //         });
          //       },
          //     ),
          //   ),
          // ),
          buildRoomNameFormField(),
          SizedBox(height: 20),
          // buildRoomTypeFormField(),
          // SizedBox(height: 20),
          buildRoomDescriptionFormField(),
          SizedBox(height: 20),
          buildMaxCapacityFormField(),
          SizedBox(height: 20),
          // buildAmenityFormField(),
          Container(
            width: MediaQuery.of(context).size.width / 1.5,
            decoration: BoxDecoration(
                color: Color(0xfffd4f0f0),
                borderRadius: BorderRadius.circular(10)),
            child: AddMoreAmenity(this.pinkcount, this.blueValue, this.errors),
          ),
          SizedBox(height: 20),
          buildRoomQuantityFormField(),
          SizedBox(height: 20),
          buildPriceFormField(),
          SizedBox(height: 20),
          Row(
            children: [
              Column(
                children: [Text("Image")],
              ),
              Center(
                  child: roomimg == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              roomimg.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(roomimg.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                //color: Color(0xfffa2c8ff),
                child: Ink(
                    child: Container(
                        color: Color(0xfffa2c8ff),
                        constraints: const BoxConstraints(
                            minWidth: 70.0, minHeight: 36.0),
                        alignment: Alignment.center,
                        child: Text(
                          'Upload',
                          style: TextStyle(fontSize: 15),
                        ))),
                onPressed: () {
                  _getroomimg();
                },
              ),
            ],
          ),

          //   FormError(errors: errors),
          SizedBox(height: 20),
        ]),
      ),
    );
  }

  TextFormField buildRoomDescriptionFormField() {
    return TextFormField(
      controller: _controllerRoomdescription,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => room_description = newValue,
      onChanged: (value) {
        // print('room des start');
        // print(pinkcount);
        // print('room des end');
        pinkValue[pinkcount - 1].description = value;
        // print(value);
        // print("===");
        if (value.isNotEmpty) {
          removeError(error: "Please enter room description");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter room description");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Room description",
        filled: true,
        fillColor: Color(0xffffee1e8),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildPriceFormField() {
    return TextFormField(
      controller: _controllerPrice,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => price = newValue,
      onChanged: (value) {
        // print('room price start');
        // print(pinkcount);
        // print('room price end');
        pinkValue[pinkcount - 1].price = double.parse(value);
        // print(value);
        // print("===");
        if (value.isNotEmpty) {
          removeError(error: "Please enter price");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter price");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Price",
        filled: true,
        fillColor: Color(0xffffee1e8),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildMaxCapacityFormField() {
    return TextFormField(
      controller: _controllerMax,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => max_capa = newValue,
      onChanged: (value) {
        // print('room max start');
        // print(pinkcount);
        // print('room max end');
        pinkValue[pinkcount - 1].maxGuest = int.parse(value);
        // print(value);
        // print("===");

        if (value.isNotEmpty) {
          removeError(error: "Please enter max capacity");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter max capacity");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Max capacity",
        filled: true,
        fillColor: Color(0xffffee1e8),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  // TextFormField buildAmenityFormField() {
  //   return TextFormField(
  //     controller: _controllerAmenity,
  //     cursorColor: Color(0xFFf5579c6),
  //     onSaved: (newValue) => amenity = newValue,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: "Please enter amenity");
  //       }
  //       return null;
  //     },
  //     validator: (value) {
  //       if (value.isEmpty) {
  //         addError(error: "Please enter amenity");
  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: "Amenity",
  //       filled: true,
  //       fillColor: Color(0xffffee1e8),
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //     ),
  //   );
  // }

  // TextFormField buildRoomTypeFormField() {
  //   return TextFormField(
  //     controller: _controllerRoomtype,
  //     cursorColor: Color(0xFFf5579c6),
  //     onSaved: (newValue) => room_type = newValue,
  //     onChanged: (value) {
  //       if (value.isNotEmpty) {
  //         removeError(error: "Please enter room type");
  //       }
  //       return null;
  //     },
  //     validator: (value) {
  //       if (value.isEmpty) {
  //         addError(error: "Please enter room type");
  //         return "";
  //       }
  //       return null;
  //     },
  //     decoration: InputDecoration(
  //       labelText: "Room type",
  //       filled: true,
  //       fillColor: Color(0xffffee1e8),
  //       floatingLabelBehavior: FloatingLabelBehavior.always,
  //     ),
  //   );
  // }

  TextFormField buildRoomNameFormField() {
    return TextFormField(
      controller: _controllerRoomname,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => room_name = newValue,
      onChanged: (value) {
        // print('room name start');
        // print(pinkcount);
        // print('room name end');
        pinkValue[pinkcount - 1].name = value;
        // print(value);
        // print("===");
        // pinkValue.add(value);
        // print('room form');
        // print(pinkValue);
        // print('mon');
        if (value.isNotEmpty) {
          removeError(error: "Please enter room type");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter room type");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Room type",
        filled: true,
        fillColor: Color(0xffffee1e8),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildRoomQuantityFormField() {
    return TextFormField(
      controller: _controllerQuantity,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => quantity = newValue,
      onChanged: (value) {
        // print('room quantity start');
        // print(pinkcount);
        // print('room quantity end');
        pinkValue[pinkcount - 1].quantity = int.parse(value);
        // print(value);
        // print("===");
        if (value.isNotEmpty) {
          removeError(error: "Please enter room quantity");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter room quantity");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Room quantity",
        filled: true,
        fillColor: Color(0xffffee1e8),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
