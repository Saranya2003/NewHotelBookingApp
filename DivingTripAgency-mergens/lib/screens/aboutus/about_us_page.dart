import 'package:diving_trip_agency/screens/aboutus/about_data.dart';
import 'package:diving_trip_agency/screens/sectionTitile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SingleChildScrollView(
        child: Container(
          //   margin: EdgeInsetsDirectional.only(top:120),
          width: double.infinity,
          // height: 600,
          decoration: BoxDecoration(color: Color(0xfffc1bbdd).withOpacity(0.3)),
          child: Column(
            children: [
              // Transform.translate(
              //   offset: Offset(0, 0),
              //   child: aboutus(),
              // ),
              SectionTitle(
                title: "About us",
                color: Color(0xFFFF78a2cc),
              ),
              SizedBox(height: 40),
              SizedBox(
                  width: 1110,
                  child: Wrap(
                      spacing: 20,
                      runSpacing: 40,
                      children: List.generate(
                        AboutDatas.length,
                        (index) => InfoCard(
                          index: index,
                        ),
                      ))),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class InfoCard extends StatefulWidget {
  const InfoCard({
    Key key,
    this.index,
  }) : super(key: key);

  final int index;

  @override
  State<InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 320,
        width: 500,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            // Container(
            //     width: 200,
            //     height: 200,
            //     child: Image.asset(AboutDatas[widget.index].image)),
            Expanded(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(AboutDatas[widget.index].name),
                      SizedBox(
                        height: 10,
                      ),
                      Text(AboutDatas[widget.index].stdID),
                      SizedBox(
                        height: 20,
                      )
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }
}

