import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/signup/company/divermaster_form.dart';
import 'package:flutter/material.dart';

class AddmoreDiverMaster extends StatefulWidget {
  List<DiveMaster> divemasterValue;
  List<String> errors = [];
  AddmoreDiverMaster(List<DiveMaster> divemasterValue, List<String> errors) {
    this.divemasterValue = divemasterValue;
    this.errors = errors;
  }
  @override
  _AddmoreDiverMasterState createState() =>
      _AddmoreDiverMasterState(this.divemasterValue, this.errors);
}

class _AddmoreDiverMasterState extends State<AddmoreDiverMaster> {
  int count = 1;
  List<DiveMaster> divemasterValue;
  List<String> errors = [];
  _AddmoreDiverMasterState(
      List<DiveMaster> divemasterValue, List<String> errors) {
    this.divemasterValue = divemasterValue;
    this.errors = errors;
  }
  @override
  Widget build(BuildContext context) {
    // print(divemasterValue);
    return Container(
      child: SingleChildScrollView(
          child: Column(children: [
        ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            shrinkWrap: true,
            itemCount: count,
            itemBuilder: (BuildContext context, int index) {
              return DiveMasterForm(count, this.divemasterValue, this.errors);
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                setState(() {
                  count += 1;
                  divemasterValue.add(new DiveMaster());
                });
              },
              color: Colors.blue,
              textColor: Colors.white,
              child: Icon(
                Icons.add,
                size: 20,
              ),
            ),
            SizedBox(width: 30),
            MaterialButton(
              onPressed: () {
                setState(() {
                  count -= 1;
                   divemasterValue.remove(new DiveMaster());
                });
              },
              color: Colors.red,
              textColor: Colors.white,
              child: Icon(
                Icons.remove,
                size: 20,
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
      ])),
    );
  }
}
