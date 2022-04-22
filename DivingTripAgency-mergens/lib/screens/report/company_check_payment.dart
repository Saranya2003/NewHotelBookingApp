import 'package:diving_trip_agency/controllers/menuCompany.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/liveaboard.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/payment.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/reservation.pbgrpc.dart';
import 'package:diving_trip_agency/screens/diveresort/diveresort.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard.dart';
import 'package:diving_trip_agency/screens/main/components/hamburger_company.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/main/components/header_company.dart';
import 'package:diving_trip_agency/screens/main/components/side_menu.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:diving_trip_agency/screens/payment/payment_screen.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';
import 'package:diving_trip_agency/screens/ShopCart/ShopcartWidget.dart';
import 'package:intl/intl.dart';

GetPaymentByReservationResponse paymentDetial =
    new GetPaymentByReservationResponse();
var payment;
bool isChecked = false;

class CompanyCheckpayment extends StatefulWidget {
  List<Diver> diver = [];
  List<Reservation> reservation = [];
  int index;
  List<ReportTrip> trips = [];
  CompanyCheckpayment(List<Diver> diver, int index,
      List<Reservation> reservation, List<ReportTrip> trips) {
    this.diver = diver;
    this.index = index;
    this.reservation = reservation;
    this.trips = trips;
    // print(reservation);
    // print(index);
  }
  @override
  State<CompanyCheckpayment> createState() => _CompanyCheckpaymentState(
      this.diver, this.index, this.reservation, this.trips);
}

class _CompanyCheckpaymentState extends State<CompanyCheckpayment> {
  // final MenuCompany _controller = Get.put(MenuCompany());
  List<Diver> diver = [];
  int index;
  List<Reservation> reservation = [];
  List<ReportTrip> trips = [];
  _CompanyCheckpaymentState(List<Diver> diver, int index,
      List<Reservation> reservation, List<ReportTrip> trips) {
    this.diver = diver;
    this.index = index;
    this.reservation = reservation;
    this.trips = trips;
  }

  updatePayment() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = PaymentServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));

    var diverInfo = Diver();
    diverInfo.id = diver[index].id;
    var paymentStatus = Payment()..diver = diverInfo;
    paymentStatus.id = paymentDetial.payment.id;
    paymentStatus.verified = isChecked;
    paymentStatus.paymentSlip = paymentDetial.payment.paymentSlip;
    paymentStatus.reservationId = reservation[index].id;

    var statusrequest = UpdatePaymentStatusRequest()..payment = paymentStatus;
    try {
      var response = stub.updatePaymentStatus(statusrequest);

      print('response: ${response}');
    } catch (e) {
      print(e);
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
          child: Center(
            child: Column(
              children: [
                HeaderCompany(),
                SizedBox(height: 30),
                SectionTitle(
                  title: "Review",
                  color: Color(0xFFFF78a2cc),
                ),
                SizedBox(
                  height: 20,
                ),
                trips[index].divers.length != 0
                    ? Column(
                        children: [
                          Center(
                              child: Container(
                                  child: SingleChildScrollView(
                            // scrollDirection: Axis.horizontal,
                            child: Wrap(
                                spacing: 20,
                                runSpacing: 40,
                                children: List.generate(
                                  trips[index].divers.length,
                                  (indexDiver) => Center(
                                    child: SingleChildScrollView(
                                       scrollDirection: Axis.horizontal,
                                      child: InfoCard(
                                        index,
                                        diver,
                                        reservation,
                                        indexDiver,
                                        trips,
                                      ),
                                    ),
                                  ),
                                )),
                          ))),
                          SizedBox(
                            height: 20,
                          ),
                          FlatButton(
                            onPressed: () async => {
                              await updatePayment(),
                              print('checking done'),
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      MainCompanyScreen(),
                                ),
                                (route) => false,
                              )
                            },
                            color: Color(0xfff75BDFF),
                            child: Text(
                              'Confirm',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(child: Text('No diver')),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ));
  }
}

class InfoCard extends StatefulWidget {
  int index;
  List<Diver> diver = [];
  List<Reservation> reservation = [];
  int indexDiver;
  List<ReportTrip> trips = [];
  InfoCard(int index, List<Diver> diver, List<Reservation> reservation,
      int indexDiver, List<ReportTrip> trips) {
    this.index = index;
    this.diver = diver;
    this.reservation = reservation;
    this.indexDiver = indexDiver;
    this.trips = trips;
    // print(index);
    // print(indexDiver);
    // print(trips[index].reservations[indexDiver].id);
  }

  @override
  State<InfoCard> createState() => _InfoCardState(
      this.index, this.diver, this.reservation, this.indexDiver, this.trips);
}

class _InfoCardState extends State<InfoCard> {
  List<Diver> diver = [];
  List<Reservation> reservation = [];
  int indexDiver;
  int index;
  List<ReportTrip> trips = [];
  _InfoCardState(int index, List<Diver> diver, List<Reservation> reservation,
      int indexDiver, List<ReportTrip> trips) {
    this.index = index;
    this.diver = diver;
    this.reservation = reservation;
    this.indexDiver = indexDiver;
    this.trips = trips;
    // print(index);
    // print(indexDiver);
    // print(trips[index].reservations[indexDiver].id);
  }

  getPaymentDetail() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = PaymentServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var paymentrequest = GetPaymentByReservationRequest();

    paymentrequest.reservationId = trips[index].reservations[indexDiver].id;

    payment = await stub.getPaymentByReservation(paymentrequest);
    // print(payment);
    paymentDetial = payment;
    isChecked = paymentDetial.payment.verified;
    // print(isChecked);
    // print(paymentDetial.payment.paymentSlip.link.toString());
    return [paymentDetial];
  }

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Container(
      // height: 320,
      width: 1000,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 50),
                Text(
                  'Diver',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(width: 50),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    diver.length == 0
                        ? new Text("No diver")
                        : new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Firstname : " +
                                  trips[widget.index]
                                      .divers[indexDiver]
                                      .firstName),
                              Text("Lastname : " +
                                  trips[widget.index]
                                      .divers[indexDiver]
                                      .lastName),
                              Text("Phone number :" +
                                  trips[widget.index].divers[indexDiver].phone),
                              Text("Level :" +
                                  trips[widget.index]
                                      .divers[indexDiver]
                                      .level
                                      .toString()),
                            ],
                          )
                  ],
                ),
                SizedBox(
                  width: 50,
                ),
                Column(
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Text(
                    //   'Payment',
                    //   style: TextStyle(fontSize: 20),
                    // ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        SizedBox(
                          child: FutureBuilder(
                            future: getPaymentDetail(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return Center(
                                    child: paymentDetial.payment.paymentSlip ==
                                            null
                                        ? new Container(
                                            color: Colors.pink,
                                          )
                                        : Row(
                                            children: [
                                              Container(
                                                width: 300,
                                                height: 300,
                                                child: Image.network(
                                                    paymentDetial.payment
                                                        .paymentSlip.link
                                                        .toString()),
                                              ),
                                              SizedBox(
                                                width: 20,
                                              ),
                                              StatefulBuilder(builder:
                                                  (BuildContext context,
                                                      StateSetter setState) {
                                                return Checkbox(
                                                  checkColor: Colors.white,
                                                  fillColor:
                                                      MaterialStateProperty
                                                          .resolveWith(
                                                              getColor),
                                                  value: isChecked,
                                                  onChanged: (bool value) {
                                                    setState(() {
                                                      // print(isChecked);
                                                      // print('bf');
                                                      isChecked = value;
                                                      // print(isChecked);
                                                      // print('af');
                                                    });
                                                  },
                                                );
                                              }),
                                            ],
                                          ));
                              } else {
                                return Align(
                                    alignment: Alignment.center,
                                    child: Text('No slip'));
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          width: 50,
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
