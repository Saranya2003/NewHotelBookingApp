 import 'dart:ui';
import 'package:diving_trip_agency/screens/main/components/people.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// class TopSection extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return SingleChildScrollView(
//       child: Container(
//         constraints: BoxConstraints(maxHeight: 400, minHeight: 100),
//         width: double.infinity,
//         decoration: BoxDecoration(
//             //  color: Color(0xfffdcfffb)
//             image: DecorationImage(
//                 fit: BoxFit.cover,
//                 image: AssetImage('assets/images/scuba-diving.jpg'))),
//         child: Container(
//           width: 500,
//           child: Column(
//             children: [
//               // Text('a'),
//               SizedBox(height: 50),
//               GlassContent(size: size),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class GlassContent extends StatefulWidget {
//   const GlassContent({
//     Key key,
//     @required this.size,
//   }) : super(key: key);

//   final Size size;

//   @override
//   _GlassContentState createState() => _GlassContentState();
// }

// class _GlassContentState extends State<GlassContent> {
//   DateTimeRange dateRange;

//   String getFrom() {
//     if (dateRange == null) {
//       return 'From';
//     } else {
//       return DateFormat('MM/dd/yyyy').format(dateRange.start);
//     }
//   }

//   String getTo() {
//     if (dateRange == null) {
//       return 'To';
//     } else {
//       return DateFormat('MM/dd/yyyy').format(dateRange.end);
//     }
//   }

//   @override
//   String search;
//   final TextEditingController _controllerSearch = TextEditingController();
//   Widget build(BuildContext context) {
//     return            ClipRRect(
//               borderRadius: BorderRadius.circular(10),
//               child: BackdropFilter(
//                 filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
//                 child: Container(
//                   padding: EdgeInsets.all(24),
//                   color: Colors.white.withOpacity(0),
//                   //  color: Colors.pink,
//                   constraints: BoxConstraints(
//                       maxWidth: MediaQuery.of(context).size.width, maxHeight: widget.size.height * 0.25),

//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Stack(children:[
//                         Text("Welcome to the Diving Trip website",
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 60,
//                               // fontFamily: 'PT Sans Narrow',
//                               foreground:Paint()
//                                 ..style = PaintingStyle.stroke
//                                 ..strokeWidth = 6
//                                 ..color = Colors.white
//                             ),
//                           softWrap: false,
//                         ),
//                         Text("Welcome to the Diving Trip website",
//                           style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 60,
//                               // fontFamily: 'PT Sans Narrow',

//                           ),
//                           softWrap: false,
//                         )
//                       ]),
//                     ],
//                   ),
//                 ),
//               ),
//             );

//   }

//   Future pickDateRange(BuildContext context) async {
//     final initialDateRange = DateTimeRange(
//         start: DateTime.now(),
//         end: DateTime.now().add(Duration(hours: 24 * 3)));
//     final newDateRange = await showDateRangePicker(
//         context: context,
//         firstDate: DateTime(DateTime.now().year - 5),
//         lastDate: DateTime(DateTime.now().year + 5));
//     initialDateRange:
//     dateRange ?? initialDateRange;
//     if (newDateRange == null) return;
//     setState(() => dateRange = newDateRange);
//   }

//   TextFormField buildSearchFormField() {
//     return TextFormField(
//       controller: _controllerSearch,
//       onSaved: (newValue) => search = newValue,
//       decoration: InputDecoration(
//         hintText: "  Search",
//         filled: true,
//         fillColor: Colors.white,
//         suffixIcon: Icon(Icons.search),
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//       ),
//     );
//   }

//   TextFormField buildPeopleFormField() {
//     return TextFormField(
//       controller: _controllerSearch,
//       onSaved: (newValue) => search = newValue,
//       decoration: InputDecoration(
//         hintText: "  Search",
//         filled: true,
//         fillColor: Colors.white,
//         suffixIcon: Icon(Icons.search),
//         floatingLabelBehavior: FloatingLabelBehavior.always,
//       ),
//     );
//   }
// }

class TopSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 30),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 2,
        decoration: BoxDecoration(
            //color: Color(0xfffdcfffb)
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
              Color(0xfffb9deed),
              Color(0xfffefefef),
            ])),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          // child: ConstrainedBox(
          //     constraints: BoxConstraints(
          //       maxWidth: MediaQuery.of(context).size.width,
          //     ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Text(
                    "Hotel".toUpperCase(),
                    style: Theme.of(context).textTheme.headline2.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    "Lorem ipsum dolor sit amet, consectetur \nadipiscing elit, sed do eiusmod tempor \nincididunt ut labor",
                    style: TextStyle(
                      fontSize: 21,
                    ),
                  ),
                ],
              ),
              // Spacer(
              // flex: 2,
              // ),
              SizedBox(width: MediaQuery.of(context).size.width/5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Text('img'),
                  Container(
                    // width: 400,
                    // height:350,
                    width: MediaQuery.of(context).size.width / 2,
                    height: MediaQuery.of(context).size.height / 2.2,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage('assets/images/scuba-diving.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(width: 20),
            ],
          ),
        )
        // )
        );
  }
}
