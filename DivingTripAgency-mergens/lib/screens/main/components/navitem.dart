import 'package:flutter/material.dart';

class NavItem extends StatelessWidget {
  const NavItem({Key key, this.title, this.tapEvent}) : super(key: key);

  final String title;
  final GestureTapCallback tapEvent;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: tapEvent,
      hoverColor: Colors.transparent,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
      ),
    );
  }
}
