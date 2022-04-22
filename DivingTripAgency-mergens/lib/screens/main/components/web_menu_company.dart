// import 'package:diving_trip_agency/controllers/menuCompany.dart';
// import 'package:diving_trip_agency/controllers/menuController.dart';
// import 'package:diving_trip_agency/screens/aboutus/about_us_page.dart';
// import 'package:diving_trip_agency/screens/aboutus/aboutus_screen.dart';
// import 'package:diving_trip_agency/screens/create_boat/create_boat_screen.dart';
// import 'package:diving_trip_agency/screens/create_liveaboard/add_liveabord_screen.dart';
// import 'package:diving_trip_agency/screens/create_trip/create_trip_screen.dart';
// import 'package:diving_trip_agency/screens/create_hotel/add_hotel_screen.dart';
// import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
// import 'package:diving_trip_agency/screens/profile/company/company_profile_screen.dart';
// import 'package:diving_trip_agency/screens/report/company_report.dart';
// import 'package:diving_trip_agency/screens/signup/company/signup_divemaster.dart';
// import 'package:diving_trip_agency/screens/signup/company/signup_staff.dart';

// import 'package:flutter/material.dart';
// import 'package:diving_trip_agency/constants.dart';
// import 'package:get/get.dart';
// import 'package:diving_trip_agency/screens/detail/package_screen.dart';
// import 'package:diving_trip_agency/screens/main/mainScreen.dart';

// class WebMenuCompany extends StatelessWidget {
//   // final MenuCompany _controller = Get.put(MenuCompany());

//   @override
//   Widget build(BuildContext context) {
//     return Obx(() => Row(
//           children: List.generate(
//             _controller.menuItems.length,
//             (index) => WebMenuCompanyItem(
//                 text: _controller.menuItems[index],
//                 isActive: index == _controller.selectedIndex,
//                 press: () {
//                   _controller.setMenuIndex(index);
//                   // if (_controller.selectedIndex == 0) {

//                   //   Navigator.push(
//                   //       context,
//                   //       MaterialPageRoute(
//                   //           builder: (context) => MainCompanyScreen()));
//                   // }
//                   if (_controller.selectedIndex == 0) {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => CreateTrip()));
//                   }
//                   if (_controller.selectedIndex == 1) {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => HotelScreen()));
//                   }

//                   if (_controller.selectedIndex == 2) {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => CreateLiveaboardScreen()));
//                   }
//                   if (_controller.selectedIndex == 3) {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => CreateBoat()));
//                   }
//                   if (_controller.selectedIndex == 4) {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => SignupDiveMaster()));
//                   }
//                   if (_controller.selectedIndex == 5) {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) => SignupStaff()));
//                   }
//                   if (_controller.selectedIndex == 6) {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => CompanyProfileScreen()));
//                   }
//                   if (_controller.selectedIndex == 7) {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => CompanyReportScreen()));
//                   }
//                 }),
//           ),
//         ));
//   }
// }

// class WebMenuCompanyItem extends StatefulWidget {
//   const WebMenuCompanyItem({
//     Key key,
//     @required this.isActive,
//     @required this.text,
//     @required this.press,
//   }) : super(key: key);

//   final bool isActive;
//   final String text;
//   final VoidCallback press;

//   @override
//   _WebMenuCompanyItemState createState() => _WebMenuCompanyItemState();
// }

// class _WebMenuCompanyItemState extends State<WebMenuCompanyItem> {
//   bool _isHover = false;
//   Color _borderColor() {
//     if (widget.isActive) {
//       return Color(0xFFFfb6f92);
//     } else if (!widget.isActive & _isHover) {
//       return Color(0xFFFfb6f92).withOpacity(0.4);
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
//                 color: Color(0xFFFb94543),
//                 fontSize: 12,
//                 fontWeight:
//                     widget.isActive ? FontWeight.w600 : FontWeight.normal)),
//       ),
//     );
//   }
// }
