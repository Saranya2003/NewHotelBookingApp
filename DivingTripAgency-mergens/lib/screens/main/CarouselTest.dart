import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class CarouselWithDotsPage extends StatefulWidget {
  List<String> imgList;
  CarouselWithDotsPage({this.imgList});
  @override
  _CarouselWithDotsPageState createState() => _CarouselWithDotsPageState();
}


class _CarouselWithDotsPageState extends State<CarouselWithDotsPage> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = widget.imgList
        .map((item) => Container(
      child: ClipRRect(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
        child: Stack(
          children: [
            !kIsWeb ?
              Image.asset(item,
                fit: BoxFit.cover,
                width: 1000,
                //height: 100,
              ) :
              Image.network(item,
              fit: BoxFit.cover,
              width: 1000,
              //height: 100,
              )
            ,

            /*Positioned(
              bottom: 0.0,
              left: 10.0,
              right: 10.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(200, 0, 0, 0),
                      Color.fromARGB(0, 0, 0, 0),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),*/
               /* padding: EdgeInsets.symmetric(
                  horizontal: 2,
                  vertical: 2,
                ),
                child: Text(
                  'No. ${widget.imgList.indexOf(item)} image',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),*/
             // ),
          //  ),
          ],
        ),
      ),
    ))
        .toList();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(5), //Inset from the top
          /*child: Text(
            "Carousel With Image, Text & Dots",
            style: TextStyle(
              color: Colors.green[700],
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),*/
        ),
        CarouselSlider(
          items: imageSliders,
          options: CarouselOptions(
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 5.0,
              viewportFraction:0.3,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              }),
        ),
      ],
    );
  }
}
