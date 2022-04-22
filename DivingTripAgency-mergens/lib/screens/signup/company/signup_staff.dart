import 'package:diving_trip_agency/controllers/menuCompany.dart';
import 'package:diving_trip_agency/form_error.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/create_trip/create_trip_screen.dart';
import 'package:diving_trip_agency/screens/main/components/hamburger_company.dart';
import 'package:diving_trip_agency/screens/main/components/header_company.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:diving_trip_agency/screens/signup/company/addStaff.dart';
import 'package:diving_trip_agency/screens/signup/company/staff_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';

class SignupStaff extends StatefulWidget {
  List<String> errors = [];
  @override
  State<SignupStaff> createState() => _SignupStaffState(this.errors);
}

class _SignupStaffState extends State<SignupStaff> {
  // final MenuCompany _controller = Get.put(MenuCompany());
  List<Staff> staffValue = [new Staff()];
  List<String> errors = [];
  final _formKey = GlobalKey<FormState>();
  _SignupStaffState(this.errors);
  GetProfileResponse user_profile = new GetProfileResponse();
  var profile;
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
    // return profile;

    if (profile.hasAgency()) {
      user_profile = profile;
      return user_profile;
    }
  }

  void addStaff() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = AgencyServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var staff = Staff();
    for (int i = 0; i < staffValue.length; i++) {
      staff.firstName = staffValue[i].firstName;
      // print(staffValue[i].firstName);
      staff.lastName = staffValue[i].lastName;
      staff.position = staffValue[i].position;
      staff.gender = staffValue[i].gender;
      var staffRequest = AddStaffRequest();
      staffRequest.staff = staff;

      try {
        var response = await stub.addStaff(staffRequest);
        print('response: ${response}');
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: _controller.scaffoldkey,
      endDrawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 300),
        child: CompanyHamburger(),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            width: double.infinity,
            // height: 600,
            // decoration: BoxDecoration(color: Color(0xfffe6e6ca).withOpacity(0.3)),
            decoration:
                BoxDecoration(color: Color(0xFFFFfd8be).withOpacity(0.3)),
            child: Column(
              children: [
                HeaderCompany(),
                SizedBox(height: 50),
                SectionTitle(
                  title: "Create staff",
                  color: Color(0xFFFF78a2cc),
                ),
                SizedBox(
                  height: 30,
                ),

                SizedBox(
                  width: 1110,
                  child: FutureBuilder(
                    future: getProfile(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: AddMoreStaff(this.staffValue, this.errors),
                            ),
                            SizedBox(height: 20),
                            FormError(errors: errors),
                            FlatButton(
                              onPressed: () => {
                                if (_formKey.currentState.validate())
                                  {
                                    addStaff(),
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                MainCompanyScreen()))
                                  }
                              },
                              color: Color(0xfff75BDFF),
                              child: Text(
                                'Confirm',
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Center(child: Text('User is not logged in'));
                      }
                    },
                  ),
                ),

                SizedBox(height: 30),
                // FlatButton(
                //   onPressed: () => {print(staffValue), print(staffValue.length)},
                //   color: Color(0xfff75BDFF),
                //   child: Text(
                //     'check',
                //     style: TextStyle(fontSize: 15),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
      // body: SizedBox(
      //   width: double.infinity,
      //   child: SingleChildScrollView(
      //     child: Container(
      //       height: MediaQuery.of(context).size.height,
      //       width: MediaQuery.of(context).size.width,
      //       decoration: BoxDecoration(
      //           gradient: LinearGradient(
      //               begin: Alignment.topLeft,
      //               end: Alignment.bottomRight,
      //               colors: [
      //             Color(0xffff598a8),
      //             Color(0xffff6edb2),
      //             Color(0xfffc5f7eb),
      //           ])),
      //       child: SingleChildScrollView(
      //         child: Column(
      //           children: [
      //             SizedBox(height: 50),
      //             Text(
      //               "Staff ",
      //               style: TextStyle(fontSize: 20),
      //             ),
      //             SizedBox(height: 50),
      //             Container(
      //               width: MediaQuery.of(context).size.width / 1.5,
      //               decoration: BoxDecoration(
      //                   color: Colors.white,
      //                   borderRadius: BorderRadius.circular(10)),
      //               child: AddMoreStaff(this.staffValue),
      //             ),
      //             SizedBox(height: 30),
      //             SizedBox(height: 20),
      //             FlatButton(
      //               onPressed: () => {
      //                 Navigator.push(
      //                     context,
      //                     MaterialPageRoute(
      //                         builder: (context) => MainCompanyScreen()))
      //               },
      //               color: Color(0xfff75BDFF),
      //               child: Text(
      //                 'Confirm',
      //                 style: TextStyle(fontSize: 15),
      //               ),
      //             ),
      //             SizedBox(height: 20),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ),
      // ),
    );
  }
}
