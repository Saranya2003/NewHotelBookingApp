import 'package:flutter/material.dart';

class CenterSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
        child: Container(
      child: Padding(
        padding: const EdgeInsets.only(top: 50, left: 150),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Welcome to diving trip agency',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Colors.black)),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Explore with us',
                style: TextStyle(fontSize: 16),
              ),
            ),
            MaterialButton(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              onPressed: () {},
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Text(
                  'Our package',
                  style: TextStyle(color: Colors.lightBlue, fontSize: 12),
                ),
              ),
            )
          ],
        ),
      ),
      constraints: BoxConstraints(maxHeight: 300, minHeight: 100),
      width: double.infinity,
      decoration: BoxDecoration(
          //color: Color(0xfffdcfffb)
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
            Color(0xfffb9deed),
            Color(0xfffefefef),
          ])),
    ));
  }
}
