import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/hotel.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/reservation.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/reservation.pbgrpc.dart';
import 'package:diving_trip_agency/screens/diveresort/dialog.dart';
import 'package:diving_trip_agency/screens/diveresort/diveresort.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/main/components/header_company.dart';
import 'package:diving_trip_agency/screens/main/components/side_menu.dart';
import 'package:diving_trip_agency/screens/payment/payment_screen.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:fixnum/fixnum.dart';
import 'package:diving_trip_agency/screens/weatherforecast/forecast_widget.dart';
import 'package:weather/weather.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_map/flutter_map.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:intl/intl.dart';

import 'package:diving_trip_agency/screens/ShopCart/ShopcartWidget.dart';

List<RoomType> roomtypes = [];
List<ReportTrip> details;
GetHotelResponse hotelDetial = new GetHotelResponse();
var hotel;

class CompanyResort extends StatefulWidget {
  int index;
  List<ReportTrip> details;
  CompanyResort(int index, List<ReportTrip> details) {
    this.details = details;
    this.index = index;
  }

  @override
  State<CompanyResort> createState() =>
      _CompanyResortState(this.index, this.details);
}

class _CompanyResortState extends State<CompanyResort> {
  // final MenuController _controller = Get.put(MenuController());
  int index;
  List<ReportTrip> details;
  _CompanyResortState(int index, List<ReportTrip> details) {
    this.index = index;
    this.details = details;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // key: _controller.scaffoldkey,
          endDrawer: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 300
        ),
        child: SideMenu(),
      ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                HeaderCompany(),
                SizedBox(height: 30),
                detail(this.index, this.details),
              ],
            ),
          ),
        ));
  }
}

class detail extends StatefulWidget {
  int index;
  List<ReportTrip> details;
  detail(int index, List<ReportTrip> details) {
    this.index = index;
    this.details = details;
  }

  @override
  State<detail> createState() => _detailState(this.index, this.details);
}

class _detailState extends State<detail> {
  int index;
  List<ReportTrip> details;

  _detailState(int index, List<ReportTrip> details) {
    this.index = index;
    this.details = details;
  }

  getData() async {
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

    var listroomrequest = ListRoomTypesRequest();
    listroomrequest.limit = Int64(20);
    listroomrequest.offset = Int64(0);
    listroomrequest.hotelId = details[widget.index].tripTemplate.hotelId;

    roomtypes.clear();

    try {
      await for (var feature in stub.listRoomTypes(listroomrequest)) {
        roomtypes.add(feature.roomType);
      }
    } catch (e) {
      print('ERROR: $e');
    }

    return roomtypes;
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
    hotelrequest.id = details[widget.index].tripTemplate.hotelId;
    // Int64(2);
    print(hotelrequest.id);
    hotel = await stub.getHotel(hotelrequest);
    hotelDetial = hotel;

    // print(hotelDetial.hotel.name);
    return hotelDetial.hotel.name;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          title: "Dive resorts",
          color: Color(0xFFFF78a2cc),
        ),
        Text("Trip name : " + details[widget.index].tripTemplate.name),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
            future: getHotelDetail(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child: Text("Hotel : " +
                      // details[widget.index].tripTemplate.hotelId.toString()),
                      hotelDetial.hotel.name),
                );
              } else {
                return Align(
                    alignment: Alignment.center, child: Text('No name'));
              }
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("From : " +
                DateFormat("dd/MM/yyyy")
                    .format(details[widget.index].startDate.toDateTime())),
            SizedBox(
              width: 10,
            ),
            Text("From : " +
                DateFormat("dd/MM/yyyy")
                    .format(details[widget.index].endDate.toDateTime())),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text("Address : " +
            details[widget.index].tripTemplate.address.addressLine1),
        SizedBox(
          height: 10,
        ),
        Text("Address2 : " +
            details[widget.index].tripTemplate.address.addressLine2),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('City : ' + details[widget.index].tripTemplate.address.city),
            SizedBox(
              width: 20,
            ),
            Text("Country : " +
                details[widget.index].tripTemplate.address.country),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Region : ' +
                details[widget.index].tripTemplate.address.region),
            SizedBox(
              width: 20,
            ),
            Text('Postcode : ' +
                details[widget.index].tripTemplate.address.postcode),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Text("Description : " + details[widget.index].tripTemplate.description),
        SizedBox(
          height: 10,
        ),
        Text("Price : " + details[widget.index].price.toString()),
        SizedBox(
          height: 10,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: MediaQuery.of(context).size.width / 3.5,
                  height: MediaQuery.of(context).size.width / 3.5,
                  child: details[widget.index].tripTemplate.images.length == 0
                      ? new Container(
                          color: Colors.pink,
                        )
                      : Image.network(
                          // 'http://139.59.101.136/static/'+
                          details[widget.index]
                              .tripTemplate
                              .images[0]
                              .link
                              .toString())),
              SizedBox(
                width: 10,
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 3.5,
                  height: MediaQuery.of(context).size.width / 3.5,
                  child: details[widget.index].tripTemplate.images.length == 0
                      ? new Container(
                          color: Colors.pink,
                        )
                      : Image.network(
                          // 'http://139.59.101.136/static/'+
                          details[widget.index]
                              .tripTemplate
                              .images[1]
                              .link
                              .toString())),
              SizedBox(
                width: 10,
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 3.5,
                  height: MediaQuery.of(context).size.width / 3.5,
                  child: details[widget.index].tripTemplate.images.length == 0
                      ? new Container(
                          color: Colors.pink,
                        )
                      : Image.network(details[widget.index]
                          .tripTemplate
                          .images[2]
                          .link
                          .toString())),
            ],
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                SizedBox(
                  width: 1110,
                  child: FutureBuilder(
                    future: getData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Center(
                            child: Container(
                                child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Wrap(
                              spacing: 20,
                              runSpacing: 40,
                              children: List.generate(
                                roomtypes.length,
                                (candy) => Center(
                                  child: InfoCard(candy, details, index),
                                ),
                              )),
                        )));
                      } else {
                        return Align(
                            alignment: Alignment.center,
                            child: Text('No data'));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

class InfoCard extends StatefulWidget {
  List<ReportTrip> details;
  int indexRoom;
  int indexDetail;
  InfoCard(int indexRoom, List<ReportTrip> details, int indexDetail) {
    this.indexRoom = indexRoom;
    this.details = details;
    this.indexDetail = indexDetail;
  }

  @override
  State<InfoCard> createState() =>
      _InfoCardState(this.indexRoom, this.details, this.indexDetail);
}

class _InfoCardState extends State<InfoCard> {
  List<ReportTrip> details;
  int indexRoom;
  int indexDetail;
  _InfoCardState(this.indexRoom, this.details, this.indexDetail);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 320,
        width: 500,
        decoration: BoxDecoration(
            color: Color(0xFFFF89cfef),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            SizedBox(width: 20),
            Container(
                width: 200,
                height: 200,
                child: roomtypes[widget.indexRoom].roomImages.length == 0
                    ? new Container(
                        color: Colors.green,
                      )
                    : Image.network(roomtypes[widget.indexRoom]
                        .roomImages[0]
                        .link
                        .toString())),
            SizedBox(
              width: 20,
            ),
            Column(
              children: [
                SizedBox(
                  height: 40,
                ),
                Text('Room type : ' + roomtypes[widget.indexRoom].name),
                SizedBox(
                  height: 20,
                ),
                Text('Room description: ' +
                    roomtypes[widget.indexRoom].description),
                SizedBox(
                  height: 20,
                ),
                Text('Max capacity : ' +
                    roomtypes[widget.indexRoom].maxGuest.toString()),
                SizedBox(
                  height: 20,
                ),
                Text('Room quantity : ' +
                    roomtypes[widget.indexRoom].quantity.toString()),
                SizedBox(
                  height: 20,
                ),
                Text('Price : ' + roomtypes[widget.indexRoom].price.toString()),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
