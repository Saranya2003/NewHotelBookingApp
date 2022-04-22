import 'package:diving_trip_agency/controllers/menuCompany.dart';
import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/screens/main/components/hamburger_company.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/main/components/header_company.dart';
import 'package:diving_trip_agency/screens/main/components/side_menu.dart';
import 'package:diving_trip_agency/screens/profile/company/company_profile.dart';
import 'package:diving_trip_agency/screens/profile/diver/user_profile.dart';
import 'package:diving_trip_agency/screens/report/report_detail_company.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CompanyReportScreen extends StatelessWidget {
  // final MenuCompany _controller = Get.put(MenuCompany());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _controller.scaffoldkey,
      endDrawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300),
        child: CompanyHamburger(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderCompany(),
            CompanyReport()
            ],
        ),
      ),
    );
  }
}
