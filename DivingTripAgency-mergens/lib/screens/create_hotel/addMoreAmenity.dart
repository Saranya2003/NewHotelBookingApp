import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/create_hotel/amenity.dart';
import 'package:flutter/material.dart';

class AddMoreAmenity extends StatefulWidget {
  List<List<Amenity>> blueValue;
  List<String> errors = [];
  int pinkcount;
  AddMoreAmenity(
      int pinkcount, List<List<Amenity>> blueValue, List<String> errors) {
    this.pinkcount = pinkcount;
    this.blueValue = blueValue;
    this.errors = errors;
  }
  @override
  _AddMoreAmenityState createState() =>
      _AddMoreAmenityState(this.pinkcount, this.blueValue, this.errors);
}

class _AddMoreAmenityState extends State<AddMoreAmenity> {
  int bluecount = 1;
  int pinkcount;
  List<List<Amenity>> blueValue;
  List<String> errors = [];
  _AddMoreAmenityState(
      int pinkcount, List<List<Amenity>> blueValue, List<String> errors) {
    this.pinkcount = pinkcount;
    this.blueValue = blueValue;
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
            itemCount: bluecount,
            itemBuilder: (BuildContext context, int index) {
              return amenityForm(
                  bluecount, pinkcount, this.blueValue, this.errors);
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                setState(() {
                  bluecount += 1;
                  blueValue[pinkcount - 1].add(new Amenity());
                });
              },
              color: Color(0xfff8fcaca),
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
                  bluecount -= 1;
                  blueValue[pinkcount - 1].remove(new Amenity());
                });
              },
              color: Color(0xfff8fcaca),
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
