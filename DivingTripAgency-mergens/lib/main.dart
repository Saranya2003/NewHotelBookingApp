import 'package:diving_trip_agency/screens/create_trip/testDropdownw.dart';
import 'package:diving_trip_agency/screens/detail/testComment.dart';
import 'package:diving_trip_agency/screens/diveresort/resort_details_screen.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard_details.dart';
import 'package:diving_trip_agency/screens/login/login.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:diving_trip_agency/screens/payment/payment_screen.dart';
import 'package:diving_trip_agency/screens/signup/test.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:grpc/grpc_connection_interface.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
void main() async{
  await Hive.initFlutter();
  await Hive.openBox('userInfo');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //for state management
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hotel Booking',
      theme: ThemeData(
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: TextButton.styleFrom(backgroundColor: Color(0xFFBCAAA4)),
          ),
          fontFamily: 'Poppins'),
  //home: MainCompanyScreen(),
     home: MainScreen(), //Original
  //  home: PaymentScreen(),
    );
  }

}
