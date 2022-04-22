import 'dart:convert';

import 'package:diving_trip_agency/controllers/menuController.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/liveaboard.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/reservation.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/roomtype.pbgrpc.dart';
import 'package:diving_trip_agency/screens/diveresort/diveresort.dart';
import 'package:diving_trip_agency/screens/liveaboard/liveaboard.dart';
import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:diving_trip_agency/screens/main/components/side_menu.dart';
import 'package:diving_trip_agency/screens/payment/payment_screen.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:weather/weather.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:fixnum/fixnum.dart';
import 'package:diving_trip_agency/screens/ShopCart/ShopcartWidget.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

GetLiveaboardResponse liveaboardDetial = new GetLiveaboardResponse();
var liveaboard;
List<RoomType> roomtypes = [];
final TextEditingController _textEditingQuantity = TextEditingController();
final TextEditingController _textEditingDiver = TextEditingController();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }
int reservation_id;
double total_price;
GetProfileResponse user_profile = new GetProfileResponse();
var profile;

class _ChartData {
  _ChartData(this.day, this.temp);
  final String day;
  final double temp;
}

class LiveaboardDetailScreen extends StatefulWidget {
  int index;
  List<TripWithTemplate> details;
  LiveaboardDetailScreen(int index, List<TripWithTemplate> details) {
    this.details = details;
    this.index = index;
  }
  @override
  State<LiveaboardDetailScreen> createState() =>
      _LiveaboardDetailScreenState(this.index, this.details);
}

class _LiveaboardDetailScreenState extends State<LiveaboardDetailScreen> {
  int index;
  List<TripWithTemplate> details;
  _LiveaboardDetailScreenState(int index, List<TripWithTemplate> details) {
    this.index = index;
    this.details = details;
    //  print(index.toString());
    //   print('detail');
    // print(details);
  }
  // final MenuController _controller = Get.put(MenuController());

  @override
  Widget build(BuildContext context) {
    // print('build'+index.toString());
    return Scaffold(
        // key: _controller.scaffoldkey,
        drawer: SideMenu(),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Header(),
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
  List<TripWithTemplate> details;
  detail(int index, List<TripWithTemplate> details) {
    this.index = index;
    this.details = details;
    // print('detail');
    // print(details);
    // print("index");
    // print(index.toString());
  }
  @override
  State<detail> createState() => _detailState(this.index, this.details);
}

class _detailState extends State<detail> {
  String cityname = "";
  String key = "cc27393688bcc7bbe2999c2e9366c65d";
  WeatherFactory ws;
  AppState _state = AppState.NOT_DOWNLOADED;
  List<Weather> _data = [];
  double latc, lonc;
  int index;
  List<TripWithTemplate> details;
  double txtsize = 15;
  List<_ChartData> tempdata = [];
  _detailState(int index, List<TripWithTemplate> details) {
    this.index = index;
    this.details = details;
  }

  @override
  void initState() {
    super.initState();
    ws = new WeatherFactory(key);
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

    final stub = RoomTypeServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));

    var listroomrequest = ListRoomTypesByTripRequest();
    listroomrequest.limit = Int64(20);
    listroomrequest.offset = Int64(0);
    listroomrequest.liveaboardId =
        details[widget.index].tripTemplate.liveaboardId;
    listroomrequest.tripId = details[widget.index].id;
    // Int64(2);

    roomtypes.clear();

    try {
      await for (var feature in stub.listRoomTypesByTrip(listroomrequest)) {
        roomtypes.add(feature.roomType);
        print(roomtypes);
      }
    } catch (e) {
      print('ERROR: $e');
    }

    return roomtypes;
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
    liveaboardrequest.id = details[widget.index].tripTemplate.liveaboardId;

    liveaboard = await stub.getLiveaboard(liveaboardrequest);
    liveaboardDetial = liveaboard;
    // print('dd');
    // print(liveaboardDetial.liveaboard.name);
    return liveaboardDetial.liveaboard.name;
  }

  void queryWeather() async {
    /// Removes keyboard
    ///

    cityname = details[widget.index].tripTemplate.address.city;

    FocusScope.of(context).requestFocus(FocusNode());
    var url = "http://api.openweathermap.org/geo/1.0/direct?q=" +
        cityname +
        "&limit=1&appid=" +
        key;
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var jsonbody = json.decode(response.body);
      print(jsonbody);
      // var parsedData =
      List loclist = jsonbody;
      //print(loclist[0]['lat']);
      //print(loclist[0]['lon']);
      latc = loclist[0]['lat'];
      lonc = loclist[0]['lon'];
      //print(cityname);
      // print(latc);
      // print(lonc);
      // print(json.decode(response.body));
    }
    setState(() {
      _state = AppState.DOWNLOADING;
    });

    List<Weather> weather = await ws.fiveDayForecastByCityName(cityname);
    //print("_data");
    // print([weather]);
    setState(() {
      _data = weather;

      _state = AppState.FINISHED_DOWNLOADING;
    });
  }

  Widget contentFinishedDownload() {
    String Weathercode = "wi-day-snow";

    double txtsize;
    if (kIsWeb) {
      txtsize = 20.0;
    } else {
      txtsize = 15.0;
    }
    tempdata = [];
    for (int i = 0; i < _data.length; i++) {
      //print(_data[0].date.day);
      tempdata.add(_ChartData(
          _data[i].date.day.toString(), _data[i].temperature.celsius));
      //tempdata.add(_ChartData("2", 36));
      //tempdata.add(_ChartData("3", 14));
      //tempdata.add(_ChartData("4", 36));
      //tempdata.add(_ChartData("5", 14));
    }
    print(tempdata);

    //if _data[index].weatherDescription
    return Center(
        child: Column(children: [
      Container(
          child: Text(_data[0].areaName,
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w100,
              ))),
      Container(
        child: Column(children: [
          //Initialize the chart widget
          SfCartesianChart(
              primaryXAxis: CategoryAxis(),
              // Chart title
              title: ChartTitle(text: 'Temperature forecast'),
              // Enable legend
              legend: Legend(isVisible: true),
              // Enable tooltip
              tooltipBehavior: TooltipBehavior(enable: true),
              series: <ChartSeries<_ChartData, String>>[
                LineSeries<_ChartData, String>(
                    dataSource: tempdata,
                    xValueMapper: (_ChartData sales, _) => sales.day,
                    yValueMapper: (_ChartData sales, _) => sales.temp,
                    name: 'Temp',
                    // Enable data label
                    dataLabelSettings: DataLabelSettings(isVisible: true))
              ]),
        ]),
      ),
      Container(
        height: 150,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _data.length,
          itemBuilder: (context, index) {
            return Container(
                width: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/' +
                            _data[index].weatherIcon +
                            '.jpg'),
                        fit: BoxFit.cover),
                    border: Border.all(color: Colors.indigo, width: 1)),
                child: Column(children: [
                  Image(
                      image: NetworkImage('http://openweathermap.org/img/w/' +
                          _data[index].weatherIcon +
                          '.png')),
                  Stack(children: [
                    Text(DateFormat.Hm().format(_data[index].date).toString(),
                        style: TextStyle(
                            fontSize: txtsize / 1.5,
                            fontWeight: FontWeight.w100,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black)),
                    Text(DateFormat.Hm().format(_data[index].date).toString(),
                        style: TextStyle(
                            fontSize: txtsize / 1.5,
                            fontWeight: FontWeight.w100,
                            color: Colors.white))
                  ]),
                  Stack(children: [
                    Text(DateFormat.E().format(_data[index].date).toString(),
                        style: TextStyle(
                            fontSize: txtsize / 1.5,
                            fontWeight: FontWeight.w100,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black)),
                    Text(DateFormat.E().format(_data[index].date).toString(),
                        style: TextStyle(
                            fontSize: txtsize / 1.5,
                            fontWeight: FontWeight.w100,
                            color: Colors.white))
                  ]),
                  Stack(children: [
                    Text(_data[index].temperature.toString(),
                        style: TextStyle(
                            fontSize: txtsize / 1.5,
                            fontWeight: FontWeight.w100,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black)),
                    Text(_data[index].temperature.toString(),
                        style: TextStyle(
                            fontSize: txtsize / 1.5,
                            fontWeight: FontWeight.w100,
                            color: Colors.white))
                  ]),
                  Stack(children: [
                    Text(_data[index].windGust.toString(),
                        style: TextStyle(
                            fontSize: txtsize / 1.5,
                            fontWeight: FontWeight.w100,
                            foreground: Paint()
                              ..style = PaintingStyle.stroke
                              ..strokeWidth = 6
                              ..color = Colors.black)),
                    Text(_data[index].windGust.toString(),
                        style: TextStyle(
                            fontSize: txtsize / 1.5,
                            fontWeight: FontWeight.w100,
                            color: Colors.white))
                  ]),
                ]));
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
        ),
      ),
      Container(
          decoration: BoxDecoration(color: Colors.greenAccent),
          width: MediaQuery.of(context).size.width * 0.9,
          height: 70,
          child: FlutterMap(
            options: MapOptions(
              center: LatLng(latc, lonc),
              zoom: 13.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
                attributionBuilder: (_) {
                  return Text("© OpenStreetMap contributors");
                },
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                    width: 80.0,
                    height: 80.0,
                    point: LatLng(51.5, -0.09),
                    builder: (ctx) => Container(
                      child: FlutterLogo(),
                    ),
                  ),
                ],
              ),
            ],
          ))
    ]));
  }

  Widget contentDownloading() {
    return Container(
      margin: EdgeInsets.all(25),
      child: Column(children: [
        Text(
          'Fetching Weather...',
          style: TextStyle(fontSize: 20),
        ),
        Container(
            margin: EdgeInsets.only(top: 50),
            child: Center(child: CircularProgressIndicator(strokeWidth: 10)))
      ]),
    );
  }

  Widget contentNotDownloaded() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Press the button to download the Weather forecast',
          ),
        ],
      ),
    );
  }

  Widget _resultView() => _state == AppState.FINISHED_DOWNLOADING
      ? contentFinishedDownload()
      : _state == AppState.DOWNLOADING
          ? contentDownloading()
          : contentNotDownloaded();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle(
          title: "Liveaboard",
          color: Color(0xFFFF78a2cc),
        ),
        Text("Trip name : " + details[widget.index].tripTemplate.name),
        SizedBox(
          height: 10,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          child: FutureBuilder(
            future: getLiveaboardDetail(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                  child:
                      Text("Liveaboard : " + liveaboardDetial.liveaboard.name),
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
                    .format(details[widget.index].fromDate.toDateTime())),
            SizedBox(
              width: 10,
            ),
            Text("To : " +
                DateFormat("dd/MM/yyyy")
                    .format(details[widget.index].toDate.toDateTime())),
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
        Text('Total capacity : ' + details[widget.index].maxGuest.toString()),
        SizedBox(
          height: 10,
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Container(
        //         width: MediaQuery.of(context).size.width / 3.5,
        //         height: MediaQuery.of(context).size.width / 3.5,
        //         child: details[widget.index].tripTemplate.images.length == 0
        //             ? new Container(
        //                 color: Colors.pink,
        //               )
        //             : Image.network(
        //                 // 'http://139.59.101.136/static/'+
        //                 details[widget.index]
        //                     .tripTemplate
        //                     .images[0]
        //                     .link
        //                     .toString())),
        //     SizedBox(
        //       width: 10,
        //     ),
        //     Container(
        //         width: MediaQuery.of(context).size.width / 3.5,
        //         height: MediaQuery.of(context).size.width / 3.5,
        //         child: details[widget.index].tripTemplate.images.length == 0
        //             ? new Container(
        //                 color: Colors.pink,
        //               )
        //             : Image.network(
        //                 // 'http://139.59.101.136/static/'+
        //                 details[widget.index]
        //                     .tripTemplate
        //                     .images[1]
        //                     .link
        //                     .toString())),
        //     SizedBox(
        //       width: 10,
        //     ),
        //     Container(
        //         width: MediaQuery.of(context).size.width / 3.5,
        //         height: MediaQuery.of(context).size.width / 3.5,
        //         child: details[widget.index].tripTemplate.images.length == 0
        //             ? new Container(
        //                 color: Colors.pink,
        //               )
        //             : Image.network(
        //                 // 'http://139.59.101.136/static/'+
        //                 details[widget.index]
        //                     .tripTemplate
        //                     .images[2]
        //                     .link
        //                     .toString())),
        //   ],
        // ),
         SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 10,
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 4,
                  height: MediaQuery.of(context).size.width / 4,
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
                  width: MediaQuery.of(context).size.width / 4,
                  height: MediaQuery.of(context).size.width / 4,
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
                  width: MediaQuery.of(context).size.width / 4,
                  height: MediaQuery.of(context).size.width / 4,
                  child: details[widget.index].tripTemplate.images.length == 0
                      ? new Container(
                          color: Colors.pink,
                        )
                      : Image.network(
                          // 'http://139.59.101.136/static/'+
                          details[widget.index]
                              .tripTemplate
                              .images[2]
                              .link
                              .toString())),
              SizedBox(
                width: 10,
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 4,
                  height: MediaQuery.of(context).size.width / 4,
                  child: details[widget.index].tripTemplate.images.length == 0
                      ? new Container(
                          color: Colors.pink,
                        )
                      : Image.network(
                          // 'http://139.59.101.136/static/'+
                          details[widget.index]
                              .tripTemplate
                              .images[3]
                              .link
                              .toString())),
              SizedBox(
                width: 10,
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 4,
                  height: MediaQuery.of(context).size.width / 4,
                  child: details[widget.index].tripTemplate.images.length == 0
                      ? new Container(
                          color: Colors.pink,
                        )
                      : Image.network(
                          // 'http://139.59.101.136/static/'+
                          details[widget.index]
                              .tripTemplate
                              .images[4]
                              .link
                              .toString())),
              SizedBox(
                width: 10,
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 4,
                  height: MediaQuery.of(context).size.width / 4,
                  child: details[widget.index].tripTemplate.images.length == 0
                      ? new Container(
                          color: Colors.pink,
                        )
                      : Image.network(
                          // 'http://139.59.101.136/static/'+
                          details[widget.index]
                              .tripTemplate
                              .images[5]
                              .link
                              .toString())),
              SizedBox(
                width: 10,
              ),
              Container(
                  width: MediaQuery.of(context).size.width / 4,
                  height: MediaQuery.of(context).size.width / 4,
                  child: details[widget.index].tripTemplate.images.length == 0
                      ? new Container(
                          color: Colors.pink,
                        )
                      : Image.network(
                          // 'http://139.59.101.136/static/'+
                          details[widget.index]
                              .tripTemplate
                              .images[6]
                              .link
                              .toString())),
            ],
          ),
        ),

        SizedBox(
          height: 20,
        ),
        Container(
          // decoration: BoxDecoration(
          //     color: Color(0xFFFF89cfef),
          //     borderRadius: BorderRadius.circular(10)),
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
                        // getLiveaboardDetail();
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
        Container(
            decoration: BoxDecoration(
                // color: Colors.white,
               color: Color(0xFFFdaf0ff),
                borderRadius: BorderRadius.circular(10)),
            width: MediaQuery.of(context).size.width,
            child: Expanded(
                child: Container(
              child: Column(children: [
                Text("5-day weather forecast"),
                Text("Weather example"),
                Container(
                  margin: EdgeInsets.all(5),
                  child: TextButton(
                    child: Text(
                      'Fetch forecast',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: queryWeather,
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.blue)),
                  ),
                ),
                Container(
                  child: _resultView(),
                )
              ]),
            )))
      ],
    );
  }
}

class InfoCard extends StatefulWidget {
  List<TripWithTemplate> details;
  int indexRoom;
  int indexDetail;

  //  InfoCard({
  //   this.index,
  // });
  InfoCard(int indexRoom, List<TripWithTemplate> details, int indexDetail) {
    this.indexRoom = indexRoom;
    this.details = details;
    this.indexDetail = indexDetail;
  }
//   const InfoCard({
//     Key key,
//     this.index,
//   }) : super(key: key);

//   final int index;

  @override
  State<InfoCard> createState() =>
      _InfoCardState(this.indexRoom, this.details, this.indexDetail);
}

class _InfoCardState extends State<InfoCard> {
  List<TripWithTemplate> details;
  int indexRoom;
  int indexDetail;
  _InfoCardState(this.indexRoom, this.details, this.indexDetail);

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

    user_profile = profile;
    return user_profile;
  }

  bookTrips() async {
    await getProfile();
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');

    final stub = ReservationServiceClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));

    var room = Reservation_Room();
    for (int i = 0; i < roomtypes.length; i++) {
      room.quantity = int.parse(_textEditingQuantity.text);
      room.roomTypeId = roomtypes[indexRoom].id;
      room.noDivers = int.parse(_textEditingDiver.text);
      // print(room.quantity);
      // print(room.noDivers);
    }

    var reservation = Reservation()..rooms.add(room);
    reservation.tripId = details[indexDetail].id;
    // Int64(28);
    reservation.diverId = user_profile.diver.id;
    reservation.price =
        (roomtypes[indexRoom].price * int.parse(_textEditingQuantity.text)) +
            details[indexDetail].price;
    reservation.totalDivers = Int64(int.parse(_textEditingDiver.text));

    var bookRequest = CreateReservationRequest()..reservation = reservation;

    try {
      var response = await stub.createReservation(bookRequest);
      print('response: ${response}');
      // print('id');
      // print(bookRequest.reservation.id);
      // print(response.reservation.id);
      reservation_id = int.parse(response.reservation.id.toString());
      total_price = response.reservation.price;
      // print(reservation_id);
      return [reservation_id, total_price];
    } catch (e) {
      print(e);
    }
  }

  Future<void> showInformationDialog(BuildContext context) async {
    // print(details.length);
    return await showDialog(
        context: context,
        builder: (context) {
          // bool isChecked = false;
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _textEditingQuantity,
                        validator: (value) {
                          return value.isNotEmpty ? null : "Invalid Field";
                        },
                        decoration:
                            InputDecoration(hintText: "Enter room quantity"),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        controller: _textEditingDiver,
                        validator: (value) {
                          return value.isNotEmpty ? null : "Invalid Field";
                        },
                        decoration:
                            InputDecoration(hintText: "Enter number of diver"),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //   children: [
                      //     Text("Confirmation"),
                      //     Checkbox(
                      //         value: isChecked,
                      //         onChanged: (checked) {
                      //           setState(() {
                      //             isChecked = checked;
                      //           });
                      //         })
                      //   ],
                      // )
                    ],
                  )),
              actions: <Widget>[
                TextButton(
                  child: Text('Add room to cart'),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      Cartlist.add([
                        details[indexDetail].tripTemplate.images.length == 0
                            ? new Container(
                                color: Colors.pink,
                              )
                            : Image.network(details[indexDetail]
                                .tripTemplate
                                .images[0]
                                .link
                                .toString()),
                        details[indexDetail].tripTemplate.name,
                        liveaboardDetial.liveaboard.name,
                        roomtypes[indexRoom].name,
                        (roomtypes[indexRoom].price *
                                int.parse(_textEditingQuantity.text)) +
                            details[indexDetail].price,
                        details,
                        roomtypes,
                        indexRoom,
                        indexDetail,
                        int.parse(_textEditingQuantity.text),
                        int.parse(_textEditingDiver.text)
                      ]);

                      // Do something like updating SharedPreferences or User Settings etc.
                      Navigator.of(context).pop();
                      print('done');
                    }
                  },
                ),
                TextButton(
                  child: Text('Book'),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      // print(details[indexDetail].price);
                      // print('--');
                      // print((roomtypes[indexRoom].price *
                      //     int.parse(_textEditingQuantity.text)));
                      // print((roomtypes[indexRoom].price *
                      //         int.parse(_textEditingQuantity.text)) +
                      //     details[indexDetail].price);
                      await bookTrips();
                      // showDialog(
                      //     context: context,
                      //     builder: (BuildContext context) {
                      //       return AlertDialog(
                      //         title: Text("Booking"),
                      //         content: Text("done"),
                      //         actions: <Widget>[
                      //           // FlatButton(
                      //           //     child: Text("OK"),
                      //           //     ),
                      //         ],
                      //       );
                      //     });
                      // Navigator.of(context).pop();
                      print('book');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PaymentScreen(
                                  reservation_id,
                                  total_price,
                                  details[indexDetail])));
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        constraints: BoxConstraints(
          maxHeight: double.infinity,
          maxWidth: double.infinity,
          minHeight: 320, //minimum height
          minWidth: 500, // minimum width
        ),
        // height: 320,
        // width: 500,
        decoration: BoxDecoration(
            // color: Colors.white,
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
                    : Image.network(
                        // 'http://139.59.101.136/static/' +
                        roomtypes[widget.indexRoom]
                            .roomImages[0]
                            .link
                            .toString()
                        // trips[widget.index].tripTemplate.images[0].toString()
                        )),
            SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                RaisedButton(
                  onPressed: roomtypes[widget.indexRoom].quantity==0? null:  () {},
                  color: Colors.amber,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Text("Book room"),
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
