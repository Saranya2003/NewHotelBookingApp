// import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
// import 'package:flutter/material.dart';

// class LevelDropdown extends StatefulWidget {
//   // LevelDropdown() : super();
//   @override
//   _LevelDropdownState createState() => _LevelDropdownState();
// }

// class _LevelDropdownState extends State<LevelDropdown> {
//   List<DropdownMenuItem<String>> listDrop = [];
//   List<LevelType> drop = [
//     LevelType.MASTER,
//     LevelType.OPEN_WATER,
//     LevelType.RESCUE,
//     LevelType.INSTRUCTOR,
//     LevelType.ADVANCED_OPEN_WATER
//   ];
//   String selected = null;

//   void loadData() {
//     drop.forEach((element) {
//       //print(element);
//     });
//     listDrop = [];
//     listDrop = drop
//         .map((val) => DropdownMenuItem<String>(
//             child: Text(val.toString()), value: val.value.toString()))
//         .toList();
//   }

//   Widget build(BuildContext context) {
//     loadData();
//     return Container(
//       color: Color(0xFFFd0efff),
//       child: Center(
//         child: DropdownButton(
//           isExpanded: true,
//           value: selected,
//           items: listDrop,
//           hint: Text('  Select level'),
//           iconSize: 40,
//           onChanged: (value) {
//             selected = value;
//             // print(value);
//             setState(() {});
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class LevelDropdown extends StatefulWidget {
  // LevelDropdown() : super();
  @override
  _LevelDropdownState createState() => _LevelDropdownState();
}


class _LevelDropdownState extends State<LevelDropdown> {
  List<DropdownMenuItem<String>> listDrop = [];
  List<String> drop = ['1', '2', '3', '4', '5'];
  String selected = null;

  void loadData() {
    listDrop = [];
    listDrop = drop
        .map((val) => DropdownMenuItem<String>(child: Text(val), value: val))
        .toList();
  }
  

  Widget build(BuildContext context) {
    loadData();
    return Container(
      color: Color(0xFFFd0efff),
      child: Center(
        child: DropdownButton(
          isExpanded: true,
          value: selected,
          items: listDrop,
          hint: Text('  Select level'),
          iconSize: 40,
          onChanged: (value) {
        selected = value;
        setState(() {});
          },
        ),
      ),
    );
  }
}