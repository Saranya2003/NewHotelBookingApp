import 'package:flutter/material.dart';

class peopleDropdown extends StatefulWidget {
  // peopleDropdown() : super();
  @override
  _peopleDropdownState createState() => _peopleDropdownState();
}

class _peopleDropdownState extends State<peopleDropdown> {
  List<DropdownMenuItem<String>> listDrop = [];
  List<String> drop = ['1', '2', '3', '4'];
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
      child: Center(
        child: DropdownButton(
          value: selected,
          items: listDrop,
          hint: Text('   1  '),
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
