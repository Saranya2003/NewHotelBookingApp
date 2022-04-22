import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pbenum.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';

class StaffForm extends StatefulWidget {
  int count;
  List<Staff> staffValue;
  List<String> errors = [];
  StaffForm(int count, List<Staff> staffValue, List<String> errors) {
    this.count = count;
    this.staffValue = staffValue;
    this.errors = errors;
  }
  @override
  _StaffFormState createState() =>
      _StaffFormState(this.count, this.staffValue, this.errors);
}

class _StaffFormState extends State<StaffForm> {
  String name;
  String lastname;
  String position;
  int count;
  List<Staff> staffValue;
  String levelSelected = null;
  Map<String, int> genderTypeMap = {};
  List<DropdownMenuItem<String>> listGender = [];
  List<GenderType> gender = [GenderType.MALE, GenderType.FEMALE];
  List<String> errors = [];
  _StaffFormState(int count, List<Staff> staffValue, List<String> errors) {
    this.count = count;
    this.staffValue = staffValue;
    this.errors = errors;
  }

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerLastname = TextEditingController();
  final TextEditingController _controllerPosition = TextEditingController();

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

  void loadData() async {
    gender.forEach((element) {
      // print(element);
    });
    //listDrop = [];
    listGender = gender
        .map((val) => DropdownMenuItem<String>(
            child: Text(val.toString()), value: val.value.toString()))
        .toList();

    String value;

    for (var i = 0; i < GenderType.values.length; i++) {
      value = GenderType.valueOf(i).toString();
      genderTypeMap[value] = i;
    }

    // print(genderTypeMap);
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(height: 20),
          buildNameFormField(),
          SizedBox(height: 20),
          buildLastnameFormField(),
          SizedBox(height: 20),
          buildPositionFormField(),
          SizedBox(height: 20),

          Container(
            color: Colors.white,
            //color: Color(0xFFFd0efff),
            child: Center(
              child: DropdownButtonFormField(
                isExpanded: true,
                value: levelSelected,
                items: listGender,
                hint: Text('  Select gender'),
                iconSize: 40,
                validator: (value) {
                  if (value == null) {
                    addError(error: "Please select gender");
                    return "";
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value != null) {
                    removeError(error: "Please select gender");
                    setState(() {
                      levelSelected = value;
                      GenderType.values.forEach((genderType) {
                        if (genderTypeMap[genderType.toString()] ==
                            int.parse(levelSelected)) {
                          staffValue[count - 1].gender = genderType;
                        }
                      });
                      print(value);
                    });
                  }
                },
              ),
            ),
          ),
          //   FormError(errors: errors),
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
        staffValue[count - 1].firstName = value;
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
          //      hintText: "Name",
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
        // print('lname  start');
        // print(count);
        // print('lname  end');
        staffValue[count - 1].lastName = value;
        // print(value);
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

  TextFormField buildPositionFormField() {
    return TextFormField(
      controller: _controllerPosition,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => position = newValue,
      onChanged: (value) {
        // print('pos  start');
        // print(count);
        // print('pos  end');
        staffValue[count - 1].position = value;
        // print(value);
        if (value.isNotEmpty) {
          removeError(error: "Please Enter staff position");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please Enter staff position");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        //   hintText: "Position",
        labelText: "Position",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
