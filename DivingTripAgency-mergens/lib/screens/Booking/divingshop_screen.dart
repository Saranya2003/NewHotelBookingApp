import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/screens/Booking/divingshop.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/main/components/side_menu.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DivingshopScreen extends StatelessWidget {
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
         
            SizedBox(height: 50),
                SectionTitle(
                  title: "Packages",
                  color: Color(0xFFFF78a2cc),
                ),
                 SizedBox(
                height: 30,
              ),
          // Text(
          //   'Packages',
          //   style: TextStyle(fontSize: 20),
          // ),
          DivingShop(),
        ],
      ),
      )
    );
  }
}
