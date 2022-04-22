import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/signup/company/staff_form.dart';
import 'package:flutter/material.dart';

class AddMoreStaff extends StatefulWidget {
  List<Staff> staffValue;
  List<String> errors = [];
  AddMoreStaff(List<Staff> staffValue, List<String> errors) {
    this.staffValue = staffValue;
    this.errors = errors;
  }
  @override
  _AddMoreStaffState createState() =>
      _AddMoreStaffState(this.staffValue, this.errors);
}

class _AddMoreStaffState extends State<AddMoreStaff> {
  int count = 1;
  List<Staff> staffValue = [];
  List<String> errors = [];
  _AddMoreStaffState(List<Staff> staffValue, List<String> errors) {
    this.staffValue = staffValue;
    this.errors = errors;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Column(children: [
        ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            shrinkWrap: true,
            itemCount: count,
            itemBuilder: (BuildContext context, int index) {
              return StaffForm(count, this.staffValue, this.errors);
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                setState(() {
                  count += 1;
                  staffValue.add(new Staff());
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
               staffValue.remove(new Staff());
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
