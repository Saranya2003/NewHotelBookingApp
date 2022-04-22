import 'package:flutter/material.dart';

class highlightForm extends StatefulWidget {
  String count;
  highlightForm(String count){
    this.count=count;
  }
  @override
  _highlightFormState createState() => _highlightFormState(this.count);
}

class _highlightFormState extends State<highlightForm> {
  String highlight;
  String count;
  _highlightFormState(String count){
    this.count=count;
  }

  final List<String> errors = [];
    final TextEditingController _controllerHighlight = TextEditingController();

  void addError({String error}) {
    if (!errors.contains(error))
      setState(() {
        errors.add(error);
      });
  }

  void removeError({String error}) {
    if (errors.contains(error))
      setState(() {
        errors.remove(error);
      });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
          SizedBox(height: 20),
          buildHighlightFormField(),
          SizedBox(height: 20),

        ]),
      ),
    );
  }
  TextFormField buildHighlightFormField() {
    return TextFormField(
      controller: _controllerHighlight,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => highlight = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter highlight");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter highlight");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: "Highlight",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

}


class AddMoreHighlight extends StatefulWidget {
  @override
  _AddMoreHighlightState createState() => _AddMoreHighlightState();
}

class _AddMoreHighlightState extends State<AddMoreHighlight> {
  int count = 1;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
          child: Column(children: [
        ListView.separated(
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
            shrinkWrap: true,
            itemCount: count,
            itemBuilder: (BuildContext context, int index) {
              return highlightForm(count.toString());
            }),
        MaterialButton(
          onPressed: () {
            setState(() {
              count += 1;
            });
          },
          color: Color(0xfff8fcaca),
          textColor: Colors.white,
          child: Icon(
            Icons.add,
            size: 20,
          ),
        ),
         SizedBox(height: 30),
      ])),
    );
  }
}
