import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/create_hotel/room_form.dart';
import 'package:diving_trip_agency/screens/create_trip/divesite_form.dart';
import 'package:flutter/material.dart';

class AddMoreDiveSite extends StatefulWidget {
  List<DiveSite> pinkValue = [];
  List<String> errors = [];

  AddMoreDiveSite(List<DiveSite> pinkValue, List<String> errors) {
    this.pinkValue = pinkValue;
    this.errors = errors;
  }
  @override
  _AddMoreDiveSiteState createState() =>
      _AddMoreDiveSiteState(this.pinkValue, this.errors);
}

class _AddMoreDiveSiteState extends State<AddMoreDiveSite> {
  int pinkcount = 1;
  List<String> errors = [];
  List<DiveSite> pinkValue = [];
  _AddMoreDiveSiteState(List<DiveSite> pinkValue, List<String> errors) {
    this.pinkValue = pinkValue;
    this.errors = errors;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Column(children: [
        ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
                  thickness: 5,
                  indent: 20,
                  endIndent: 20,
                ),
            shrinkWrap: true,
            itemCount: pinkcount,
            itemBuilder: (BuildContext context, int index) {
              return DiveSiteForm(pinkcount, this.pinkValue, this.errors);
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                setState(() {
                  pinkcount += 1;
                  pinkValue.add(new DiveSite());
                });
              },
              color: Color(0xfffff968a),
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
                  pinkcount -= 1;
                  pinkValue.remove(new DiveSite());
                });
              },
              color: Color(0xfffff968a),
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
