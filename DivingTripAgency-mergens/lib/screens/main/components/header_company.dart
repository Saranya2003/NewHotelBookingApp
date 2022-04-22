import 'package:diving_trip_agency/constants.dart';
import 'package:diving_trip_agency/controllers/menuCompany.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/responsive.dart';
import 'package:diving_trip_agency/screens/create_boat/create_boat_screen.dart';
import 'package:diving_trip_agency/screens/create_hotel/add_hotel_screen.dart';
import 'package:diving_trip_agency/screens/create_liveaboard/add_liveabord_screen.dart';
import 'package:diving_trip_agency/screens/create_trip/create_trip_screen.dart';
import 'package:diving_trip_agency/screens/main/components/navitem.dart';
import 'package:diving_trip_agency/screens/main/components/responsive.dart';
import 'package:diving_trip_agency/screens/main/components/web_menu.dart';
import 'package:diving_trip_agency/screens/login/login.dart';
import 'package:diving_trip_agency/screens/main/components/web_menu_company.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:diving_trip_agency/screens/profile/company/company_profile_screen.dart';
import 'package:diving_trip_agency/screens/report/company_report.dart';
import 'package:diving_trip_agency/screens/signup/company/signup_divemaster.dart';
import 'package:diving_trip_agency/screens/signup/company/signup_staff.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';

GetProfileResponse user_profile = new GetProfileResponse();
var profile;

class HeaderCompany extends StatelessWidget {
  // final MenuCompany _controller = Get.put(MenuCompany());

  @override
  Widget build(BuildContext context) {
    return Container(

        width: double.infinity,
        height: 100,
        // color: Color(0xfff96dfd8),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              // Color(0xfffaea4e3),
              // Color(0xfffd3ffe8),
              Color(0xfffcfecd0),
              Color(0xfffffc5ca),
            ])),
        child: Row(
          children: <Widget>[
            SizedBox(width: 10),
            Text(
              "DivingTripAgency",
            ),
            Spacer(),
            if (!isMobile(context))
              Row(
                children: [
                  NavItem(
                    title: 'Home',
                    tapEvent: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainCompanyScreen()));
                    },
                  ),
                  NavItem(
                    title: 'Create trip',
                    tapEvent: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateTrip()));
                    },
                  ),
                  NavItem(
                    title: 'Create hotel',
                    tapEvent: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HotelScreen()));
                    },
                  ),
                  NavItem(
                    title: 'Create liveaboard',
                    tapEvent: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateLiveaboardScreen()));
                    },
                  ),
                  NavItem(
                    title: 'Create boat',
                    tapEvent: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateBoat()));
                    },
                  ),
                  NavItem(
                    title: 'Create dive master',
                    tapEvent: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupDiveMaster()));
                    },
                  ),
                  NavItem(
                    title: 'Create staff',
                    tapEvent: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignupStaff()));
                    },
                  ),
                  NavItem(
                    title: 'Profile',
                    tapEvent: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CompanyProfileScreen()));
                    },
                  ),
                  NavItem(
                    title: 'Report',
                    tapEvent: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CompanyReportScreen()));
                    },
                  ),
                  Container(
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          //checkLogin();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                        },
                        style: TextButton.styleFrom(
                            backgroundColor: Color(0xfffff8fab),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20 * 1.5, vertical: 20)),
                        child: FutureBuilder(
                          future: getProfile(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return (checkLogin()&&user_profile.hasAgency())
                                  ? Text(
                                      "Log out",
                                      style: TextStyle(color: Colors.black),
                                    )
                                  : Text(
                                      "Log in",
                                      style: TextStyle(color: Colors.black),
                                    );
                            } else {
                              return Align(
                                  alignment: Alignment.center,
                                  child: Text('Log in', style: TextStyle(color: Colors.black),));
                            }
                          },
                        ),
                      )),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            if (isMobile(context))
              IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  })
          ],
        ));
  }

  //  SafeArea(
  //   child: Column(
  //     children: [
  //       Container(
  //         padding: EdgeInsets.all(20),
  //         constraints: BoxConstraints(maxWidth: 1232),
  //         child: Column(
  //           children: [
  //             Row(
  //               children: [
  //                 //if (!Responsive.isDesktop(context))
  //                 if (!Responsive.isDesktop(context) || MediaQuery.of(context).size.width <1232)
  //                   IconButton(
  //                       icon: Icon(Icons.menu),
  //                       onPressed: () {
  //                         _controller.openOrCloseDrawer();
  //                       }),
  //                 FlatButton(
  //                     onPressed: () {
  //                       Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                               builder: (context) => MainCompanyScreen()));
  //                     },
  //                     child: Text('DivingTripAgency')),
  //                 Spacer(),
  //                // if (Responsive.isDesktop(context)) WebMenuCompany(),
  //                 if (Responsive.isDesktop(context) && MediaQuery.of(context).size.width >1232) WebMenuCompany(),
  //                 Spacer(),
  //                 SizedBox(
  //                   width: 20,
  //                 ),
  //                 ElevatedButton(
  //                     onPressed: () {
  //                       //checkLogin();
  //                       Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                               builder: (context) => LoginScreen()));
  //                     },
  //                     style: TextButton.styleFrom(
  //                         backgroundColor: Color(0xfffff8fab),
  //                         padding: EdgeInsets.symmetric(
  //                             horizontal: 20 * 1.5, vertical: 20)),
  //                     child: (checkLogin())
  //                         ? Text("Log out",style: TextStyle(color:Colors.black),)
  //                         : Text("Log in",style: TextStyle(color:Colors.black),)),
  //                 //  (checkLogin()) ? FlatButton(child: Text("Log out")) : FlatButton(child: Text("Log in"))
  //               ],
  //             ),
  //             SizedBox(
  //               height: 40,
  //             ),
  //           ],
  //         ),
  //       )
  //     ],
  //   ),
  // ),
  // );
}

getProfile() async {
  final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
      host: '139.59.101.136',
      grpcPort: 50051,
      grpcTransportSecure: false,
      grpcWebPort: 8080,
      grpcWebTransportSecure: false);
  final box = Hive.box('userInfo');
  String token = box.get('token');
  final pf = AccountClient(channel,
      options: CallOptions(metadata: {'Authorization': '$token'}));
  profile = await pf.getProfile(new Empty());
  // print(profile);
  user_profile = profile;
  return user_profile;
}

bool checkLogin() {
  try {
    var box = Hive.box('userInfo');
    Hive.openBox('userInfo');
    String token = box.get('token');
    bool login = box.get('login');
    if (login == true) {
      print(login);
      return true;
    } else {
      print(login);
      return false;

    }
  } on GrpcError catch (e) {
  } catch (e) {
    print('Exception: $e');
  }

}