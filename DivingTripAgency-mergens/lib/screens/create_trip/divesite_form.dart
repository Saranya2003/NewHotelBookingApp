import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
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

class DiveSiteForm extends StatefulWidget {
  int pinkcount;
  List<DiveSite> pinkValue;
  List<String> errors = [];

  DiveSiteForm(int pinkcount, List<DiveSite> pinkValue, List<String> errors) {
    this.pinkcount = pinkcount;
    this.pinkValue = pinkValue;
    this.errors = errors;
    // this.blueValue = blueValue;
  }
  @override
  _DiveSiteFormState createState() =>
      _DiveSiteFormState(this.pinkcount, this.pinkValue, this.errors);
}

class _DiveSiteFormState extends State<DiveSiteForm> {
  int pinkcount;
  String name;
  String description;
  String min_depth;
  String max_depth;

  List<DiveSite> pinkValue;
  List<String> errors = [];
  _DiveSiteFormState(
      int pinkcount, List<DiveSite> pinkValue, List<String> errors) {
    this.pinkcount = pinkcount;
    this.pinkValue = pinkValue;
    this.errors = errors;
  }
  final TextEditingController _controllerDescription = TextEditingController();
  final TextEditingController _controllerMax = TextEditingController();
  final TextEditingController _controllerMin = TextEditingController();
  // final TextEditingController _controllerAmenity = TextEditingController();

  final TextEditingController _controllerName = TextEditingController();

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
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          SizedBox(height: 20),

          buildNameFormField(),
          SizedBox(height: 20),

          buildDescriptionFormField(),
          SizedBox(height: 20),
          buildMaxFormField(),
          SizedBox(height: 20),

          buildMinFormField(),
          SizedBox(height: 20),

          //  FormError(errors: errors),
          // SizedBox(height: 20),
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
        pinkValue[pinkcount - 1].description = value;

        if (value.isNotEmpty) {
          removeError(error: "Please enter description");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter description");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Description",
        filled: true,
        fillColor: Color(0xffffee1e8),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildMinFormField() {
    return TextFormField(
      controller: _controllerMin,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => min_depth = newValue,
      onChanged: (value) {
        pinkValue[pinkcount - 1].minDepth = int.parse(value);

        if (value.isNotEmpty) {
          removeError(error: "Please enter min depth");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter min depth");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Min depth",
        filled: true,
        fillColor: Color(0xffffee1e8),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildMaxFormField() {
    return TextFormField(
      controller: _controllerMax,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => max_depth = newValue,
      onChanged: (value) {
        // print('room max start');
        // print(pinkcount);
        // print('room max end');
        pinkValue[pinkcount - 1].maxDepth = int.parse(value);
        // print(value);
        // print("===");

        if (value.isNotEmpty) {
          removeError(error: "Please enter max depth");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter max depth");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Max depth",
        filled: true,
        fillColor: Color(0xffffee1e8),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      controller: _controllerName,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => name = newValue,
      onChanged: (value) {
        pinkValue[pinkcount - 1].name = value;

        if (value.isNotEmpty) {
          removeError(error: "Please enter name");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter name");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Name",
        filled: true,
        fillColor: Color(0xffffee1e8),
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}
