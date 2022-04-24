import 'package:diving_trip_agency/screens/signup/diver/diver_form.dart';
import 'package:flutter/material.dart';

class SignUpDiverScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                  // Color(0xfffa2e1db),
                  //  Color(0xfffabdee6)
                  Color(0xff4e342e),
                  Color(0xff6d4c41),
                  Color(0xff8d6e63),
                  Color(0xffbcaaa4),
                  //   Color(0xffff0fdfa),
                  Color(0xffefebe9),
                ])),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Text(
                    "Register account (Customer) ",
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    "Complete your details",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  Container(
                      width: MediaQuery.of(context).size.width / 1.5,
                      decoration: BoxDecoration(color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                      child: SignupDiverForm(),
                      ),
                      SizedBox(height: 30,)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
