import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/main/components/side_menu.dart';
import 'package:diving_trip_agency/screens/payment/payment.dart';
import 'package:diving_trip_agency/screens/payment/reviewtrip.dart';
import 'package:diving_trip_agency/screens/profile/diver/user_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewTripScreen extends StatefulWidget {
  int reservation_id;
  double total_price;
  TripWithTemplate trips;


  @override
  ReviewTripScreen(
      int reservation_id, double total_price, TripWithTemplate trips) {
    this.reservation_id = reservation_id;
    this.total_price = total_price;
    this.trips = trips;
  }
  State<ReviewTripScreen> createState() =>
      _ReviewTripScreenState(this.reservation_id, this.total_price, this.trips);

}

class _ReviewTripScreenState extends State<ReviewTripScreen> {
  int reservation_id;
  double total_price;
  TripWithTemplate trips;


  // final MenuController _controller = Get.put(MenuController());
  _ReviewTripScreenState(this.reservation_id, this.total_price, this.trips);

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

            PaymentReview(reservation_id, total_price, trips)

          ],
        ),
      ),
    );
  }
}
