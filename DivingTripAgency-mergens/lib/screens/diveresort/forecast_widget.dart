import 'dart:async';

import 'package:diving_trip_agency/screens/main/components/header.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:weather/weather.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_map/flutter_map.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';


enum AppState { NOT_DOWNLOADED, DOWNLOADING, FINISHED_DOWNLOADING }
class WForecast extends StatefulWidget {
  @override
  _WForecastState createState() => _WForecastState();
}

class _ChartData {
  _ChartData(this.day, this.temp);
  final String day;
  final double temp;
}

class _WForecastState extends State<WForecast> {
  @override
  String cityname = "";
  String key = "cc27393688bcc7bbe2999c2e9366c65d";
  String dropdownValue = 'Bangkok'; //Default value for the dropdown


  WeatherFactory ws;
  List<_ChartData> tempdata = [];
  List<Weather> _data = [];
  AppState _state = AppState.NOT_DOWNLOADED;

  double latc, lonc;


  @override
  void initState() {
    super.initState();
    ws = new WeatherFactory(key);
  }


  void queryForecast() async {
    /// Removes keyboard
    FocusScope.of(context).requestFocus(FocusNode());
    setState(() {
      _state = AppState.DOWNLOADING;
    });

    List<Weather> forecasts = await ws.fiveDayForecastByCityName(cityname);

    setState(() {

      _data = forecasts;
      _state = AppState.FINISHED_DOWNLOADING;
    });
  }

  Widget _CityInputs() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
              margin: EdgeInsets.all(5),
              child: TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(), hintText: 'Enter City'),

                  keyboardType: TextInputType.text,
                  onChanged: _saveCity,
                  onSubmitted: _saveCity)),
        ),
        Icon(Icons.search_outlined)
      ],
    );
  }
  void _saveCity(String input) {
    cityname = input;
    print(cityname);
  }

  void queryWeather() async {
    /// Removes keyboard
    ///

    FocusScope.of(context).requestFocus(FocusNode());
    var url = "http://api.openweathermap.org/geo/1.0/direct?q="+cityname+
        "&limit=1&appid="+key;
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200){
      var jsonbody = json.decode(response.body);
      print(jsonbody);
     // var parsedData =
      List loclist = jsonbody;
      //print(loclist[0]['lat']);
      //print(loclist[0]['lon']);
      latc = loclist[0]['lat'];
      lonc = loclist[0]['lon'];
      print(latc);
      print(lonc);
     // print(json.decode(response.body));
    }
    setState(() {
      _state = AppState.DOWNLOADING;

    });

    Weather weather = await ws.currentWeatherByCityName(cityname);

    setState(() {
      _data = [weather];

      _state = AppState.FINISHED_DOWNLOADING;
    });
  }




  Widget contentFinishedDownload() {
    String Weathercode = "wi-day-snow";

    double txtsize;
    if (kIsWeb){
      txtsize = 20.0;
    }else{
      txtsize = 15.0;
    }
    tempdata =[];
    for(int i=0;i<_data.length;i++) {
      //print(_data[0].date.day);
      tempdata.add(_ChartData(_data[i].date.day.toString(), _data[i].temperature.celsius));
      //tempdata.add(_ChartData("2", 36));
      //tempdata.add(_ChartData("3", 14));
      //tempdata.add(_ChartData("4", 36));
      //tempdata.add(_ChartData("5", 14));
    }
    print(tempdata);

    //if _data[index].weatherDescription
    return Center(
      child: Column(
        children:[
          Container(
              child: Text(_data[0].areaName, style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w100,
              )
              )
          ),
          Container(

              child:
                    Column(children: [
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
            height:150,
            child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _data.length,
            itemBuilder: (context, index) {
              return //ListTile(
                //title: //Text(_data[index].toString()),
                //Text("Hello Boy!!!"),
                Container(
                  width:100,
                  decoration: BoxDecoration(
                    //color: Colors.grey,
                    image : DecorationImage(image: AssetImage('assets/images/'+_data[index].weatherIcon+'.jpg'),fit: BoxFit.cover
                      //image : DecorationImage(image: AssetImage('assets/images/03d.jpg'),fit: BoxFit.cover

                      ),
                    border:Border.all(color:Colors.indigo,width:1)
                  ),
                  child:

                              Column(
                                    children: [
                                      //Icon(WeatherIcons.fromString(Weathercode),size:80,color:Colors.blue),
                                      Image(image:NetworkImage('http://openweathermap.org/img/w/'+_data[index].weatherIcon+'.png')),
                                      //Text(_loc[index].toString(),  style:TextStyle(fontSize:80, fontWeight:FontWeight.w100)),

                                        /*Stack(
                                            children: [

                                              Text(_data[index].areaName, style: TextStyle(
                                                  fontSize: txtsize,
                                                  fontWeight: FontWeight.w100,
                                                  foreground: Paint()
                                                    ..style = PaintingStyle.stroke
                                                    ..strokeWidth = 6
                                                    ..color = Colors.black)),
                                              Text(_data[index].areaName, style: TextStyle(
                                                  fontSize: txtsize,
                                                  fontWeight: FontWeight.w100,
                                                  color: Colors.white))
                                            ]
                                        ),*/
                                        /*Stack(
                                            children: [
                                              Text(_data[index].weatherDescription,
                                                  style: TextStyle(fontSize: txtsize/1.5,
                                                      fontWeight: FontWeight.w100,
                                                      foreground: Paint()
                                                        ..style = PaintingStyle.stroke
                                                        ..strokeWidth = 6
                                                        ..color = Colors.black)),
                                              Text(_data[index].weatherDescription,
                                                  style: TextStyle(fontSize: txtsize/1.5,
                                                      fontWeight: FontWeight.w100,
                                                      color: Colors.white))
                                            ]
                                        ),*/
                                      Stack(
                                          children: [
                                            Text(DateFormat.Hm().format(
                                                _data[index].date).toString(),
                                                style: TextStyle(fontSize: txtsize/1.5,
                                                    fontWeight: FontWeight.w100,
                                                    foreground: Paint()
                                                      ..style = PaintingStyle.stroke
                                                      ..strokeWidth = 6
                                                      ..color = Colors.black)),
                                            Text(DateFormat.Hm().format(
                                                _data[index].date).toString(),
                                                style: TextStyle(fontSize: txtsize/1.5,
                                                    fontWeight: FontWeight.w100,
                                                    color: Colors.white))
                                          ]
                                      ),
                                        Stack(
                                            children: [
                                              Text(DateFormat.E().format(
                                                  _data[index].date).toString(),
                                                  style: TextStyle(fontSize: txtsize/1.5,
                                                      fontWeight: FontWeight.w100,
                                                      foreground: Paint()
                                                        ..style = PaintingStyle.stroke
                                                        ..strokeWidth = 6
                                                        ..color = Colors.black)),
                                              Text(DateFormat.E().format(
                                                  _data[index].date).toString(),
                                                  style: TextStyle(fontSize: txtsize/1.5,
                                                      fontWeight: FontWeight.w100,
                                                      color: Colors.white))
                                            ]
                                        ),
                                        /*Stack(
                                            children: [
                                              Text(DateFormat.jm()
                                                  .format(_data[index].date)
                                                  .toString(), style: TextStyle(fontSize: txtsize/1.5,
                                                  fontWeight: FontWeight.w100,
                                                  foreground: Paint()
                                                    ..style = PaintingStyle.stroke
                                                    ..strokeWidth = 6
                                                    ..color = Colors.black)),
                                              Text(DateFormat.jm()
                                                  .format(_data[index].date)
                                                  .toString(), style: TextStyle(fontSize: txtsize/1.5,
                                                  fontWeight: FontWeight.w100,
                                                  color: Colors.white))
                                            ]
                                        ),*/
                                        Stack(
                                            children: [
                                              Text(_data[index].temperature.toString(),
                                                  style: TextStyle(fontSize: txtsize/1.5,
                                                      fontWeight: FontWeight.w100,
                                                      foreground: Paint()
                                                        ..style = PaintingStyle.stroke
                                                        ..strokeWidth = 6
                                                        ..color = Colors.black)),
                                              Text(_data[index].temperature.toString(),
                                                  style: TextStyle(fontSize: txtsize/1.5,
                                                      fontWeight: FontWeight.w100,
                                                      color: Colors.white))
                                            ]
                                        ),
                                      Stack(
                                          children: [
                                            Text(
                                                _data[index].windGust.toString(),
                                                style: TextStyle(fontSize: txtsize/1.5,
                                                    fontWeight: FontWeight.w100,
                                                    foreground: Paint()
                                                      ..style = PaintingStyle.stroke
                                                      ..strokeWidth = 6
                                                      ..color = Colors.black)),
                                            Text(_data[index].windGust.toString(),
                                                style: TextStyle(fontSize: txtsize/1.5,
                                                    fontWeight: FontWeight.w100,
                                                    color: Colors.white))
                                          ]
                                      ),
                                        /*Stack(
                                            children: [
                                              Text("Humidity: " +
                                                  _data[index].humidity.toString(),
                                                  style: TextStyle(fontSize: txtsize/2.5,
                                                      fontWeight: FontWeight.w100,
                                                      foreground: Paint()
                                                        ..style = PaintingStyle.stroke
                                                        ..strokeWidth = 6
                                                        ..color = Colors.black)),
                                              Text("Humidity: " +
                                                  _data[index].humidity.toString(),
                                                  style: TextStyle(fontSize: txtsize/2.5,
                                                      fontWeight: FontWeight.w100,
                                                      color: Colors.white))
                                            ]
                                        )*/
                                      //,SizedBox(height:10),
                           /* Container(
                              decoration: BoxDecoration(color: Colors.greenAccent),
                              width:MediaQuery.of(context).size.width * 0.9,
                              height: 50,
                              child:FlutterMap(
                                options: MapOptions(
                                  center: LatLng(latc, lonc),
                                  zoom: 13.0,
                                ),
                                layers: [
                                  TileLayerOptions(
                                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
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
                                        builder: (ctx) =>
                                            Container(
                                              child: FlutterLogo(),
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            )*/

                    ]
                  )

                );
            },
            separatorBuilder: (context, index) {
              return Divider();
            },
          ),
          ),
          Container(
              decoration: BoxDecoration(color: Colors.greenAccent),
              width:MediaQuery.of(context).size.width * 0.9,
              height: 70,
              child:FlutterMap(
                options: MapOptions(
                  center: LatLng(latc, lonc),
                  zoom: 13.0,
                ),
                layers: [
                  TileLayerOptions(
                    urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
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
                        builder: (ctx) =>
                            Container(
                              child: FlutterLogo(),
                            ),
                      ),
                    ],
                  ),
                ],
              )
          )
        ]
      )
        );
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

  Widget _CityDropdown(){
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String newValue) {
        setState(() {
          dropdownValue = newValue;
        },
        );
        _saveCity(dropdownValue);
      },
      items: <String>['Bangkok', 'Phuket', 'Ko Samui', 'Chiang Mai']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buttons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(5),
          child: TextButton(
            child: Text(
              'Fetch weather',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: queryWeather,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue)),
          ),
        ),
        Container(
          margin: EdgeInsets.all(5),
          child: TextButton(
            child: Text(
              'Fetch forecast',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: queryForecast,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue)),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width * 0.9;
    return Container(
      child: Column(
          children: [
          Column(
            children: [//<Widget>[
              _CityInputs(),
              //_CityDropdown(),
              _buttons(),
            Text(
              'Output:',
              style: TextStyle(fontSize: 20),
            ),
            Divider(
              height: 20.0,
              thickness: 2.0,
            ),
            //Expanded(child: _resultView())
                  Container(
                    child: _resultView(),
                      height: 800,
                      width: width,
                  )

          ],
        ),
      ]
      ),
    );
  }
}
