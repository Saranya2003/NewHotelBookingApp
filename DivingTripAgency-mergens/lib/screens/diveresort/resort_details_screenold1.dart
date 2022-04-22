import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/screens/diveresort/ResortDetailWidgetbak.dart';
import 'package:diving_trip_agency/screens/main/components/side_menu.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';


class DiveResortDetailScreen extends StatelessWidget {
  // final MenuController _controller = Get.put(MenuController());
  double latc, lonc;
  int index;
  List<TripWithTemplate> details;
  DiveResortDetailScreen(int index, List<TripWithTemplate> details) {
    this.details = details;
    this.index = index;
  }
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
            SizedBox(
              height: 50,
            ),
            //Icon(
            // Icons.image,
            //  size: 100,
            // ),
            HotelDetail(index,details),
          ],
        ),
      ),
    );
  }
}