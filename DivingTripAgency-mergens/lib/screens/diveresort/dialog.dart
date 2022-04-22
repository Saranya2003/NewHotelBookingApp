import 'package:flutter/material.dart';

enum DialogAction { yes, abort }

class Dialogs {
  static Future<DialogAction> yesAbortDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          // backgroundColor: Color(0xfffb3e5fc),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          title: Text(title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xfffBE0C0C),
              )),
          content: Text(
            body,
            style: TextStyle(),
          ),
          actions: [
            FlatButton(
              onPressed: () => Navigator.of(context).pop(DialogAction.yes),
              child: Text(
                'Yes',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xfff091D67)),
              ),
            ),
            FlatButton(
              onPressed: () => Navigator.of(context).pop(DialogAction.abort),
              child: Text('No',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Color(0xfff091D67))),
            ),
          ],
        );
      },
    );
    return (action != null) ? action : DialogAction.abort;
  }
}
