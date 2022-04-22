// import 'package:diving_trip_agency/controllers/menuController.dart';
// import 'package:diving_trip_agency/screens/aboutus/about_us_page.dart';
// import 'package:diving_trip_agency/screens/aboutus/aboutus_screen.dart';
// import 'package:diving_trip_agency/screens/Booking/divingshop_screen.dart';
// import 'package:diving_trip_agency/screens/detail/trip_detail_screen.dart';
// import 'package:diving_trip_agency/screens/diveresort/dive_resort_screen.dart';
// import 'package:diving_trip_agency/screens/liveaboard/liveaboard_screen.dart';
// import 'package:diving_trip_agency/screens/profile/diver/profile_screen.dart';
// import 'package:diving_trip_agency/screens/weatherforecast/forecast_screen.dart';
// import 'package:diving_trip_agency/screens/ShopCart/ShopcartScreen.dart';
// import 'package:flutter/material.dart';
// import 'package:diving_trip_agency/constants.dart';
// import 'package:get/get.dart';
// import 'package:diving_trip_agency/screens/detail/package_screen.dart';
// import 'package:diving_trip_agency/screens/main/mainScreen.dart';

// class WebMenu extends StatelessWidget {
//   // final MenuController _controller = Get.put(MenuController());

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Row(
//           children: List.generate(
//             _controller.menuItems.length,
//             (index) => WebMenuItem(
//                 text: _controller.menuItems[index],
//                 isActive: index == _controller.selectedIndex,
//                 press: () {
//                   _controller.setMenuIndex(index);
//                   if (_controller.selectedIndex == 0) {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => MainScreen()));
//                   }
//                     if (_controller.selectedIndex == 1) {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => TripDetailScreen()));
//                   }
//                   // if (_controller.selectedIndex == 1) {
//                   //   Navigator.push(
//                   //       context,
//                   //       MaterialPageRoute(
//                   //           builder: (context) => LiveaboardScreen()));
//                   // }
//                   // if (_controller.selectedIndex == 2) {
//                   //   Navigator.push(
//                   //       context,
//                   //       MaterialPageRoute(
//                   //           builder: (context) => DiveResortScreen()));
//                   // }
//                   // if (_controller.selectedIndex == 3) {
//                   //   Navigator.push(
//                   //       context,
//                   //       MaterialPageRoute(
//                   //           builder: (context) => PackageScreen()));
//                   // }
//                   if (_controller.selectedIndex == 2) {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => WForecastScreen()));
//                   } if (_controller.selectedIndex == 3) {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => UserProfileScreen()));
//                   }

//                   if (_controller.selectedIndex == 4) {
//                     print("Shopping cart");
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) =>
//                                 ShopCart()));
//                   }
                  
//                   // if (_controller.selectedIndex == 5) {
//                   //   Navigator.push(
//                   //       context,
//                   //       MaterialPageRoute(
//                   //           builder: (context) => AboutusScreen()));
//                   // }
//                   // if (_controller.selectedIndex == 6) {
//                   //   Navigator.push(
//                   //       context,
//                   //       MaterialPageRoute(
//                   //           builder: (context) => DivingshopScreen()));
//                   // }
//                 }),
//           ),
//         ));
//   }
// }

// class WebMenuItem extends StatefulWidget {
//   const WebMenuItem({
//     Key key,
//     @required this.isActive,
//     @required this.text,
//     @required this.press,
//   }) : super(key: key);

//   final bool isActive;
//   final String text;
//   final VoidCallback press;

//   @override
//   _WebMenuItemState createState() => _WebMenuItemState();
// }

// class _WebMenuItemState extends State<WebMenuItem> {
//   bool _isHover = false;
//   Color _borderColor() {
//     if (widget.isActive) {
//       return Color(0xFFF3c89d0);
//     } else if (!widget.isActive & _isHover) {
//       return Color(0xFFF3c89d0).withOpacity(0.4);
//     }
//     return Colors.transparent;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: widget.press,
//       onHover: (value) {
//         // print(value);
//         setState(() {
//           _isHover = value;
//         });
//       },
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 250),
//         margin: EdgeInsets.symmetric(horizontal: 20),
//         padding: EdgeInsets.symmetric(vertical: 20 / 2),
//         decoration: BoxDecoration(
//           border: Border(
//               bottom: BorderSide(
//                   color: _borderColor(),
//                   //widget.isActive ? kPrimaryColor : Colors.transparent
//                   width: 3)),
//         ),
//         child: Text(widget.text,
//             style: TextStyle(
//                 color: Color(0xfff3944BC),
//                 fontWeight:
//                     widget.isActive ? FontWeight.w600 : FontWeight.normal)),
//       ),
//     );
//   }
// }
