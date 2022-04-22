import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/screens/Booking/divingshop_screen.dart';
import 'package:diving_trip_agency/screens/aboutus/aboutus_screen.dart';
import 'package:diving_trip_agency/screens/detail/package_screen.dart';
import 'package:diving_trip_agency/screens/detail/trip_detail_screen.dart';
import 'package:diving_trip_agency/screens/diveresort/dive_resort_screen.dart';
import 'package:diving_trip_agency/screens/diveresort/diveresort.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard_data.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard_screen.dart';

import 'package:diving_trip_agency/screens/login/login.dart';

import 'package:diving_trip_agency/screens/main/components/navitem.dart';
import 'package:diving_trip_agency/screens/profile/diver/profile_screen.dart';
import 'package:diving_trip_agency/screens/review/Reviewscreen.dart';
import 'package:diving_trip_agency/screens/weatherforecast/forecast_screen.dart';
import 'package:diving_trip_agency/screens/ShopCart/ShopcartScreen.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';


GetProfileResponse user_profile = new GetProfileResponse();
var profile;
class SideMenu extends StatelessWidget {
  // final MenuController _controller = Get.put(MenuController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      // color: Colors.white,
       color: Color(0xfffb9deed),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              SizedBox(height: 20),
              NavItem(
                title: 'Home',
                tapEvent: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MainScreen()));
                },
              ),
              SizedBox(height: 20),
              NavItem(
                title: 'Trips',
                tapEvent: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TripDetailScreen()));
                },
              ),
              SizedBox(height: 20),
              NavItem(

                title: 'Reviews',
                tapEvent: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ReviewScreen()));
                },
              ),
              SizedBox(height: 20),
              NavItem(

                title: 'Weather Forecast',
                tapEvent: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => WForecastScreen()));
                },
              ),
              SizedBox(height: 20),
              NavItem(
                title: 'Profile',
                tapEvent: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserProfileScreen()));
                },
              ),
              SizedBox(height: 20),
              NavItem(
                title: 'Cart',
                tapEvent: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ShopCart()));
                },
              ),
              SizedBox(height: 20),
              FutureBuilder(
              future: getProfile(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  print("about to checkLogin\n--------------");

                  //return (checkLogin()&&user_profile.hasDiver())
                  return checkLogin() == true ?
                  ElevatedButton(


                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20 * 1.5, vertical: 20)),
                      child: Text("Sign out")
                  )
                      :
                  ElevatedButton(


                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                      style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20 * 1.5, vertical: 20)),
                      child: Text("Sign in")
                  );
                }
              }
              ),
              /*Container(
                height: 45,
                child: ElevatedButton(


                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()));
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20 * 1.5, vertical: 20)),

                    child: FutureBuilder(
                      future: getProfile(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          print("about to checkLogin\n--------------");

                          //return (checkLogin()&&user_profile.hasDiver())
                          return checkLogin() == true ?

                               Text(
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
                              child: Text(
                                'Log in',
                                style: TextStyle(color: Colors.black),
                              ));
                        }
                      },
                    ),
                  ),
                ),*/
                SizedBox(
                  height: 20,
                ),

            ],
          ),
        ),
      ),
    );


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
    print("getProfile Check");
     print(profile);
    print("------------");
    user_profile = profile;
    return user_profile;
  }


  bool checkLogin() {
    try {
      var box = Hive.box('userInfo');
      Hive.openBox('userInfo');
      String token = box.get('token');
      bool login = box.get('login');
      print("login");
      print("-----------");
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
}
