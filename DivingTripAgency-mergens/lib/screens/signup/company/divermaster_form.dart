import 'package:diving_trip_agency/form_error.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pbenum.dart';
import 'package:diving_trip_agency/screens/signup/company/signup_staff.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io' as io;
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'dart:convert';

class DiveMasterForm extends StatefulWidget {
  int count;
  List<DiveMaster> divemasterValue;
  List<String> errors = [];
  DiveMasterForm(
      int count, List<DiveMaster> divemasterValue, List<String> errors) {
    this.divemasterValue = divemasterValue;
    this.count = count;
    this.errors = errors;
  }
  @override
  _DiveMasterFormState createState() =>
      _DiveMasterFormState(this.count, this.divemasterValue, this.errors);
}

class _DiveMasterFormState extends State<DiveMasterForm> {
  bool _isObscure = true;
  String name;
  String lastname;
  String email;
  String phoneNumber;
  io.File CardFile;
  XFile cb;
  String levelSelected = null;
  List<DiveMaster> divemasterValue;
  int count;
  io.File CardFileBack;
  XFile ca;
  Map<String, int> levelTypeMap = {};
  List<String> errors = [];
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerLastname = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();

  _DiveMasterFormState(int count, this.divemasterValue, List<String> errors) {
    this.count = count;
    this.divemasterValue = divemasterValue;
    this.errors = errors;
  }

  List<DropdownMenuItem<String>> listLevel = [];
  List<LevelType> level = [
    LevelType.MASTER,
    LevelType.OPEN_WATER,
    LevelType.RESCUE,
    LevelType.INSTRUCTOR,
    LevelType.ADVANCED_OPEN_WATER
  ];

  void loadData() async {
    level.forEach((element) {
      //print(element);
    });
    // listLevel = [];
    listLevel = level
        .map((val) => DropdownMenuItem<String>(
            child: Text(val.toString()), value: val.value.toString()))
        .toList();

    String value;

    for (var i = 0; i < LevelType.values.length; i++) {
      value = LevelType.valueOf(i).toString();
      levelTypeMap[value] = i;
    }

    //  print("LevelType-----------------");
    //  print(levelTypeMap);
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

  _getCard() async {
    ca = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 5000,
      maxHeight: 5000,
    );
    var f2 = File();
    f2.filename = ca.name;
    //f2.filename = 'image.jpg';
    List<int> b = await ca.readAsBytes();
    f2.file = b;
    //this.imagelist.add(f);
    this.divemasterValue[count - 1].documents.add(f2);

    if (ca != null) {
      setState(() {
        CardFile = io.File(ca.path);
      });
    }
    if (CardFile == null) {
      addError(error: "Please upload image");
    }
  }

  _getCardBack() async {
    cb = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 5000,
      maxHeight: 5000,
    );
    var f = File();
    f.filename = cb.name;
    //f2.filename = 'image.jpg';
    List<int> a = await cb.readAsBytes();
    f.file = a;
    //this.imagelist.add(f);
    this.divemasterValue[count - 1].documents.add(f);

    if (cb != null) {
      setState(() {
        CardFileBack = io.File(cb.path);
      });
    }
    if (CardFileBack == null) {
      addError(error: "Please upload image");
    }
    //setState(() {
    //CardFileBack = io.File(pickedFile.path);
    //print("CardFileBack");
    //divemasterValue[count - 1].documents.add(CardFileBack);
    //});
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(height: 20),
          buildNameFormField(),
          SizedBox(height: 20),
          buildLastnameFormField(),
          SizedBox(height: 20),
          Container(
            color: Colors.white,
            //color: Color(0xFFFd0efff),
            child: Center(
              child: DropdownButtonFormField(
                isExpanded: true,
                value: levelSelected,
                items: listLevel,
                hint: Text('  Select level'),
                iconSize: 40,
                validator: (value) {
                  if (value == null) {
                    addError(error: "Please enter level");
                    return "";
                  }
                  return null;
                },
                onChanged: (value) {
                  //   divemasterValue[count - 1].level = value;
                  if (value != null) {
                    removeError(error: "Please enter level");
                    setState(() {
                      levelSelected = value;
                      LevelType.values.forEach((levelType) {
                        if (levelTypeMap[levelType.toString()] ==
                            int.parse(levelSelected)) {
                          divemasterValue[count - 1].level = levelType;
                        }
                      });
                      print('------');
                      print(value);
                    });
                  }
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          // FormError(errors: errors),
          Row(
            children: [
              Column(
                children: [Text("Divemaster"), Text('Card'), Text('(Front)')],
              ),
              Center(
                  child: CardFile == null
                      ? Column(
                          children: [
                            Text(''),
                            Text(''),
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              CardFile.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(CardFile.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                color: Color(0xfffa2c8ff),
                child: Container(
                  constraints:
                      const BoxConstraints(minWidth: 20.0, minHeight: 10.0),
                  child: Text(
                    'Upload',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                onPressed: () {
                  _getCard();
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Column(
                children: [Text("Divemaster"), Text('Card'), Text("(Back)")],
              ),
              Center(
                  child: CardFileBack == null
                      ? Column(
                          children: [
                            //Text('Divemaster Card '),
                            // Text('(Back)')
                          ],
                        )
                      : kIsWeb
                          ? Image.network(
                              CardFileBack.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
                            )
                          : Image.file(
                              io.File(CardFileBack.path),
                              fit: BoxFit.cover,
                              width: screenwidth * 0.05,
                            )),
              Spacer(),
              FlatButton(
                color: Color(0xfffa2c8ff),
                child: Container(
                  constraints:
                      const BoxConstraints(minWidth: 20.0, minHeight: 10.0),
                  child: Text(
                    'Upload',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
                onPressed: () {
                  _getCardBack();
                },
              ),
            ],
          ),
          SizedBox(height: 20),
        ]),
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      controller: _controllerName,
      cursorColor: Color(0xFFf5579c6),
      keyboardType: TextInputType.name,
      onSaved: (newValue) => name = newValue,
      onChanged: (value) {
        // print('name  start');
        // print(count);
        // print('name end');
        divemasterValue[count - 1].firstName = value;
        // print(value);
        if (value.isNotEmpty) {
          removeError(error: "Please Enter your name");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter your name");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          //  hintText: "Name",
          labelText: "First Name",
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.person)),
    );
  }

  TextFormField buildLastnameFormField() {
    return TextFormField(
      controller: _controllerLastname,
      cursorColor: Color(0xFFf5579c6),
      keyboardType: TextInputType.name,
      onSaved: (newValue) => lastname = newValue,
      onChanged: (value) {
        // print('lastname  start');
        // print(count);
        // print('lastname end');
        divemasterValue[count - 1].lastName = value;
        //  print(value);
        if (value.isNotEmpty) {
          removeError(error: "Please Enter your lastname");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter your lastname");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          //    hintText: "Lastname",
          labelText: "Last Name",
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.person)),
    );
  }
}
