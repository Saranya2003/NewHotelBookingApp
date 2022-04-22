
import 'package:flutter/material.dart';

final kHintTextStyle = TextStyle(
  color: Colors.white54,
  // fontFamily: 'OpenSans',
);

final kLabelStyle = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.bold,
  // fontFamily: 'OpenSans',
    shadows: [
      Shadow( // bottomLeft
          offset: Offset(-1.5, -1.5),
          color: Colors.black
      ),
      Shadow( // bottomRight
          offset: Offset(1.5, -1.5),
          color: Colors.black
      ),
      Shadow( // topRight
          offset: Offset(1.5, 1.5),
          color: Colors.black
      ),
      Shadow( // topLeft
          offset: Offset(-1.5, 1.5),
          color: Colors.black
      ),
    ],
);

final kBoxDecorationStyle = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(10.0),
  boxShadow: [
    BoxShadow(
      color: Colors.black12,
      blurRadius: 6.0,
      offset: Offset(0, 2),
    ),
  ],
);