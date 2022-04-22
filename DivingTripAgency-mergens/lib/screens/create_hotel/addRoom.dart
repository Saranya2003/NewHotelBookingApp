import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/create_hotel/room_form.dart';
import 'package:flutter/material.dart';

class AddMoreRoom extends StatefulWidget {
  List<RoomType> pinkValue = [];
  List<String> errors = [];

  List<List<Amenity>> blueValue;
  AddMoreRoom(List<RoomType> pinkValue, List<List<Amenity>> blueValue,
      List<String> errors) {
    this.pinkValue = pinkValue;
    this.blueValue = blueValue;
    this.errors = errors;
  }
  @override
  _AddMoreRoomState createState() =>
      _AddMoreRoomState(this.pinkValue, this.blueValue, this.errors);
}

class _AddMoreRoomState extends State<AddMoreRoom> {
  int pinkcount = 1;
  List<List<Amenity>> blueValue;
  List<RoomType> pinkValue = [];
  List<String> errors = [];
  _AddMoreRoomState(List<RoomType> pinkValue, List<List<Amenity>> blueValue,
      List<String> errors) {
    this.pinkValue = pinkValue;
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
                const Divider(
                  thickness: 5,
                  indent: 20,
                  endIndent: 20,
                ),
            shrinkWrap: true,
            itemCount: pinkcount,
            itemBuilder: (BuildContext context, int index) {
              return RoomForm(
                  pinkcount, this.pinkValue, this.blueValue, this.errors);
            }),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MaterialButton(
              onPressed: () {
                setState(() {
                  pinkcount += 1;
                  pinkValue.add(new RoomType());
                  blueValue.add([new Amenity()]);
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
                  pinkValue.remove(new RoomType());
                  blueValue.remove([new Amenity()]);
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
