import 'package:diving_trip_agency/constants.dart';
import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/screens/main/components/center.dart';
import 'package:diving_trip_agency/screens/main/components/side_menu.dart';
import 'package:diving_trip_agency/screens/main/components/top_section.dart';
import 'package:diving_trip_agency/screens/main/components/web_menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:diving_trip_agency/screens/main/CarouselTest.dart';
import 'CarouselTest.dart';
import 'components/header.dart';

final List<String> imgList = [
  'assets/images/S__83271685.jpg',
  'assets/images/S__77250562.jpg',
  'assets/images/S__83271682.jpg',
  'assets/images/S__83271684.jpg',
  'assets/images/S__83271687.jpg',
  'assets/images/S__83271688.jpg',
];

class MainScreen extends StatelessWidget {
  // final MenuController _controller = Get.put(MenuController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _controller.scaffoldkey,
      // drawer: SideMenu(),
      endDrawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300),
        child: SideMenu(),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Header(),
            TopSection(),
            // CenterSection(),
            SizedBox(
              height: 20,
            ),
            Text('Recommended Trip'),
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
