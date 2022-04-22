import 'package:diving_trip_agency/controllers/menuCompany.dart';
import 'package:diving_trip_agency/screens/main/CarouselTest.dart';
import 'package:diving_trip_agency/screens/main/components/center_comp.dart';
import 'package:diving_trip_agency/screens/main/components/hamburger_company.dart';
import 'package:diving_trip_agency/screens/main/components/header_company.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

final List<String> imgList = [
  'assets/images/S__83271685.jpg',
  'assets/images/S__77250562.jpg',
  'assets/images/S__83271682.jpg',
  'assets/images/S__83271684.jpg',
  'assets/images/S__83271687.jpg',
  'assets/images/S__83271688.jpg',
];

class MainCompanyScreen extends StatelessWidget {
  // final MenuCompany _controller = Get.put(MenuCompany());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _controller.scaffoldkey,
      // drawer: CompanyHamburger(),
      endDrawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300),
        child: CompanyHamburger(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            HeaderCompany(),
            CenterCompanySection(),
            SizedBox(
              height: 20,
            ),
            CarouselWithDotsPage(imgList: imgList),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback press;

  const DrawerItem({
    Key key,
    @required this.title,
    @required this.isActive,
    @required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
      selected: isActive,
      selectedTileColor: Color(0xfffB4CFEC),
      onTap: press,
      title: Text(
        title,
        style: TextStyle(color: Color(0xfff281E5D)),
      ),
    );
  }
}
