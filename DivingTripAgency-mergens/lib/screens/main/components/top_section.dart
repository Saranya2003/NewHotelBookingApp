 import 'dart:ui';
import 'package:diving_trip_agency/screens/main/components/people.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TopSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 30),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
            //color: Color(0xfffdcfffb)
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color(0xffA1887F),
              Color(0xffD7CCC8),
            ])),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          // child: ConstrainedBox(
          //     constraints: BoxConstraints(
          //       maxWidth: MediaQuery.of(context).size.width,
          //     ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Hotel".toUpperCase(),
                    style: Theme.of(context).textTheme.headline2.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur \nadipiscing elit, sed do eiusmod tempor \nincididunt ut labor",
                    style: TextStyle(
                      fontSize: 21,
                    ),
                  ),
                ],
              ),
              // Spacer(
              // flex: 2,
              // ),
              SizedBox(width: MediaQuery.of(context).size.width/5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Text('img'),
                  Container(
                    // width: 400,
                    // height:350,
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 2.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage('assets/images/scuba-diving.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20),
            ],
          ),
        )
        // )
        );
  }
}
