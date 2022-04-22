import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/screens/detail/package_list.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/main/components/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PackageScreen extends StatelessWidget {
  // final MenuController _controller = Get.put(MenuController());
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
      body: SingleChildScrollView(child:
        Column(
        children: [
          Header(),
          SizedBox(height: 20),
          Text(
            'Packages',
            style: TextStyle(fontSize: 20),
          ),
          ListViewTripDetail(),
        ],
      ),
      )
    );
  }
}
