import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/main/components/side_menu.dart';
import 'package:diving_trip_agency/screens/payment/payment.dart';
import 'package:diving_trip_agency/screens/profile/diver/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PaymentScreen extends StatefulWidget {
  int reservation_id;
  double total_price;
  TripWithTemplate trips;

  @override
  PaymentScreen(
      int reservation_id, double total_price, TripWithTemplate trips) {
    this.reservation_id = reservation_id;
    this.total_price = total_price;
    this.trips = trips;
  }
  State<PaymentScreen> createState() =>
      _PaymentScreenState(this.reservation_id, this.total_price, this.trips);
}

class _PaymentScreenState extends State<PaymentScreen> {
  int reservation_id;
  double total_price;
  TripWithTemplate trips;

  // final MenuController _controller = Get.put(MenuController());
  _PaymentScreenState(this.reservation_id, this.total_price, this.trips);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _controller.scaffoldkey,
        endDrawer: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 300
        ),
        child: SideMenu(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            PaymentUpload(reservation_id, total_price, trips)
          ],
        ),
      ),
    );
  }
}
