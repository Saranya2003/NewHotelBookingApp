import 'package:diving_trip_agency/controllers/menuCompany.dart';
import 'package:diving_trip_agency/form_error.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pbenum.dart';
import 'package:diving_trip_agency/screens/main/components/hamburger_company.dart';
import 'package:diving_trip_agency/screens/main/components/header_company.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:diving_trip_agency/screens/signup/company/addDiverMaster.dart';
import 'package:diving_trip_agency/screens/signup/company/divermaster_form.dart';
import 'package:diving_trip_agency/screens/signup/company/signup_staff.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';

class SignupDiveMaster extends StatefulWidget {
  List<String> errors = [];
  @override
  State<SignupDiveMaster> createState() => _SignupDiveMasterState(this.errors);
}

class _SignupDiveMasterState extends State<SignupDiveMaster> {
  List<DiveMaster> divemasterValue = [new DiveMaster()];
  List<String> errors = [];
  final _formKey = GlobalKey<FormState>();
  _SignupDiveMasterState(this.errors);
  // final MenuCompany _controller = Get.put(MenuCompany());
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

  void addDivemaster() async {
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
    var divemaster = DiveMaster();

    for (int i = 0; i < divemasterValue.length; i++) {
      divemaster.firstName = divemasterValue[i].firstName;
      divemaster.lastName = divemasterValue[i].lastName;
      divemaster.level = divemasterValue[i].level;
      divemaster.documents.add(divemasterValue[i].documents[0]);
      divemaster.documents.add(divemasterValue[i].documents[1]);
      var divemasterRequest = AddDiveMasterRequest();
      divemasterRequest.diveMaster = divemaster;
      print('test master');
      try {
        var response = await stub.addDiveMaster(divemasterRequest);
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                  title: "Create Dive master",
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
                                child: AddmoreDiverMaster(
                                    this.divemasterValue, this.errors)),
                            SizedBox(height: 20),
                            FormError(errors: errors),
                            FlatButton(
                              onPressed: () => {
                                if (_formKey.currentState.validate())
                                  {
                                    addDivemaster(),
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

                SizedBox(
                  height: 30,
                ),
                // FlatButton(
                //   onPressed: () => {
                //     print(divemasterValue),
                //     print(divemasterValue.length),
                //   },
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
      //               "Dive Master ",
      //               style: TextStyle(fontSize: 20),
      //             ),
      //             SizedBox(height: 50),
      //             Container(
      //                 width: MediaQuery.of(context).size.width / 1.5,
      //                 decoration: BoxDecoration(
      //                     color: Colors.white,
      //                     borderRadius: BorderRadius.circular(10)),
      //                 child: AddmoreDiverMaster(this.divemasterValue)),
      //             SizedBox(height: 20),
      //             FlatButton(
      //               onPressed: () => {
      //                 addDivemaster(),
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
