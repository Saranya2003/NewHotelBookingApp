import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/diver.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/timestamp.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/hotel.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/hotel.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/liveaboard.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/liveaboard.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/payment.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/payment.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/roomtype.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/roomtype.pbgrpc.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:diving_trip_agency/screens/profile/diver/edit_profile_diver.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io' as io;
import 'package:flutter/foundation.dart' show kIsWeb;

GetProfileResponse user_profile = new GetProfileResponse();
var profile;
io.File slip;
PickedFile slipPayment;

ReservationRoom room;
GetHotelResponse hotelDetial = new GetHotelResponse();
var hotel;
GetRoomTypeResponse roomDetial = new GetRoomTypeResponse();
var room_name;
GetLiveaboardResponse liveaboardDetial = new GetLiveaboardResponse();
var liveaboard;

class PaymentUpload extends StatefulWidget {
  int reservation_id;
  double total_price;
  TripWithTemplate trips;

  PaymentUpload(int reservation_id,double total_price,TripWithTemplate trips) {
    this.reservation_id = reservation_id;
    this.total_price=total_price;
  this.trips=trips;
  }
  @override
  _PaymentUploadState createState() => _PaymentUploadState(this.reservation_id,this.total_price,this.trips);
}

class _PaymentUploadState extends State<PaymentUpload> {
  int reservation_id;
   double total_price;
   TripWithTemplate trips;

  _PaymentUploadState(this.reservation_id,this.total_price,this.trips);
  makePayment() async {
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

    var payment = Payment();

    var f = File();
    f.filename = 'Image.jpg';
    List<int> b = await slipPayment.readAsBytes();
    f.file = b;
    payment.paymentSlip = f;
    payment.verified = false;
    payment.reservationId = Int64(reservation_id);

    var makePayament = MakePaymentRequest();
    makePayament.payment = payment;

    try {
      var response = await stub.makePayment(makePayament);
      print('response: ${response}');
    } catch (e) {
      print(e);
    }
  }

  _getSlip() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 5000,
      maxHeight: 5000,
    );
    if (pickedFile != null) {
      setState(() {
        slip = io.File(pickedFile.path);
        slipPayment = pickedFile;
      });
      print(pickedFile.path.split('/').last);
    }
  }
getRoom() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');
    final stub = RoomTypeServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var roomDetail = ListRoomsOfReservationRequest();
    roomDetail.reservationId = Int64(reservation_id);
    try {
      await for (var feature in stub.listRoomsOfReservation(roomDetail)) {
        room = feature.room;
      }
    } catch (e) {
      print('ERROR: $e');
    }
    // print(room);
    return room;
  }

  getRoomName() async {
    await getRoom();
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');
    final stub = RoomTypeServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var roomName = GetRoomTypeRequest();
    roomName.roomTypeId = room.roomTypeId;

    room_name = await stub.getRoomType(roomName);
    roomDetial = room_name;
    return roomDetial.roomType.name;
  }

  getHotelDetail() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = HotelServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var hotelrequest = GetHotelRequest();
    hotelrequest.id = trips.tripTemplate.hotelId;
    // print(hotelrequest.id);
    hotel = await stub.getHotel(hotelrequest);
    hotelDetial = hotel;
    return hotelDetial.hotel.name;
  }

  getLiveaboardDetail() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = LiveaboardServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));
    var liveaboardrequest = GetLiveaboardRequest();
    liveaboardrequest.id = trips.tripTemplate.liveaboardId;
    liveaboard = await stub.getLiveaboard(liveaboardrequest);
    liveaboardDetial = liveaboard;
    return liveaboardDetial.liveaboard.name;
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Container(
        // height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(color: Color(0xfffd4f0f7).withOpacity(0.3)),
        child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            SectionTitle(
              title: "Payment",
              color: Color(0xFFFF78a2cc),
            ),
            SizedBox(
              height: 50,
            ),
             Text(
              "Trip name : " + trips.tripTemplate.name,
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("From : " +
                    DateFormat("dd/MM/yyyy")
                        .format(trips.fromDate.toDateTime())),
                SizedBox(
                  width: 10,
                ),
                Text("To : " +
                    DateFormat("dd/MM/yyyy").format(trips.toDate.toDateTime())),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text("Trip type : " + trips.tripTemplate.tripType.toString()),
            SizedBox(
              height: 10,
            ),
            Text("Address : " + trips.tripTemplate.address.addressLine1),
            SizedBox(
              height: 10,
            ),
            Text("Address2 : " + trips.tripTemplate.address.addressLine2),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('City : ' + trips.tripTemplate.address.city),
                SizedBox(
                  width: 20,
                ),
                Text("Country : " + trips.tripTemplate.address.country),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Region : ' + trips.tripTemplate.address.region),
                SizedBox(
                  width: 20,
                ),
                Text('Postcode : ' + trips.tripTemplate.address.postcode),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            trips.tripTemplate.tripType.toString() == "ONSHORE"
                ? SizedBox(
                    width: 1110,
                    child: FutureBuilder(
                      future: getHotelDetail(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              Center(
                                child: Text('Name : ' + hotelDetial.hotel.name),
                              ),
                            ],
                          );
                        } else {
                          return Align(
                              alignment: Alignment.center,
                              child: Text('No data'));
                        }
                      },
                    ),
                  )
                : SizedBox(
                    width: 1110,
                    child: FutureBuilder(
                      future: getLiveaboardDetail(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Column(
                            children: [
                              Center(
                                child: Text('Name : ' +
                                    liveaboardDetial.liveaboard.name),
                              ),
                            ],
                          );
                        } else {
                          return Align(
                              alignment: Alignment.center,
                              child: Text('No data'));
                        }
                      },
                    ),
                  ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 1110,
              child: FutureBuilder(
                future: getRoomName(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Center(
                            child: Text(
                                'Room name : ' + roomDetial.roomType.name)),
                      ],
                    );
                  } else {
                    return Align(
                        alignment: Alignment.center, child: Text('No data'));
                  }
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: 1110,
              child: FutureBuilder(
                future: getRoom(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Center(
                            child: Container(
                                child: Column(
                          children: [
                            Text('Room quantity : ' + room.quantity.toString()),
                            SizedBox(
                              height: 10,
                            ),
                            Text('Total people : ' + room.noDivers.toString()),
                          ],
                        ))),
                      ],
                    );
                  } else {
                    return Align(
                        alignment: Alignment.center, child: Text('No data'));
                  }
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text("Total price :"+total_price.toString()),
            SizedBox(
              height: 50,
            ),
            Center(
              child: Container(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Payment slip'),
                        SizedBox(
                          width: 40,
                        ),
                        FlatButton(
                          color: Color(0xfffa2c8ff),
                          child: Text(
                            'Upload',
                            style: TextStyle(fontSize: 15),
                          ),
                          onPressed: () {
                            _getSlip();
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Center(
                      child: slip == null
                          ? Text('')
                          : kIsWeb
                              ? Image.network(
                                  slip.path,
                                  fit: BoxFit.cover,
                                  width: screenwidth * 0.2,
                                )
                              : Image.file(
                                  io.File(slip.path),
                                  fit: BoxFit.cover,
                                  width: screenwidth * 0.05,
                                ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    FlatButton(
                      onPressed: () async => {
                        await makePayment(),
                        print('payment done'),
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => MainScreen(),
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
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
