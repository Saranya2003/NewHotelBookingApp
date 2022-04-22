import 'package:diving_trip_agency/screens/signup/company/company_form.dart';
import 'package:flutter/material.dart';

class SignupCompanyScreen extends StatelessWidget {

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
                  Color(0xffff598a8),
                  Color(0xffff6edb2),
                  Color(0xfffc5f7eb),
                ])),
                
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height:50),
                  Text("Register account (Company) ",style: TextStyle(fontSize: 20),),
                  Text(
                    "Complete your details",
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 50),
                  Container(
                     width: MediaQuery.of(context).size.width/1.5,
                     decoration: BoxDecoration(color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                    child: SignupCompanyForm()),
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