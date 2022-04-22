import 'dart:io' as io;
import 'package:diving_trip_agency/form_error.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/timestamp.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:diving_trip_agency/screens/signup/company/signup_divemaster.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../../nautilus/proto/dart/model.pb.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';

GetProfileResponse user_profile = new GetProfileResponse();
var profile;
final TextEditingController _controllerName =
    TextEditingController(text: user_profile.diver.firstName);
final TextEditingController _controllerLastname =
    TextEditingController(text: user_profile.diver.lastName);
final TextEditingController _controllerUsername =
    TextEditingController(text: user_profile.diver.account.username);
final TextEditingController _controllerPassword = TextEditingController();
final TextEditingController _controllerOldPassword = TextEditingController();
final TextEditingController _controllerEmail =
    TextEditingController(text: user_profile.diver.account.email);
final TextEditingController _controllerPhone =
    TextEditingController(text: user_profile.diver.phone);

class EditDiverForm extends StatefulWidget {
  @override
  _EditDiverFormState createState() => _EditDiverFormState();
}

class _EditDiverFormState extends State<EditDiverForm> {
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  String username;
  String name;
  String lastname;
  // String level;
  String phoneNumber;
  String email;
  String password;
  String oldpassword;
  final List<String> errors = [];

  io.File DiverImage;
  io.File DiveBack;
  DateTime _dateTime;
  String selected = null;
  String DivFimagename = null;
  Map<String, int> levelTypeMap = {};

  PickedFile divfront;
  PickedFile card;

  List<DropdownMenuItem<String>> listDrop = [];
  List<LevelType> drop = [
    LevelType.MASTER,
    LevelType.OPEN_WATER,
    LevelType.RESCUE,
    LevelType.INSTRUCTOR,
    LevelType.ADVANCED_OPEN_WATER
  ];

  getData() async {
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
    // print(profile);
    user_profile = profile;
    print(user_profile.diver.level.toString());
    return user_profile;
  }

  void loadData() async {
    drop.forEach((element) {
      // print(element);
    });
    //listDrop = [];
    listDrop = drop
        .map((val) => DropdownMenuItem<String>(
            child: Text(val.toString()), value: val.value.toString()))
        .toList();

    String value;

    for (var i = 0; i < LevelType.values.length; i++) {
      value = LevelType.valueOf(i).toString();
      levelTypeMap[value] = i;
    }

    // print("LevelType-----------------");
    // print(levelTypeMap);
  }

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

  void sendDiverEdit() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);
    final box = Hive.box('userInfo');
    String token = box.get('token');
    final stub = AccountClient(channel,
        options: CallOptions(metadata: {'Authorization': '$token'}));

    // var accountRequest = AccountRequest();
    // var diver =Diver();
    // var account =Account();
    // diver.account=account;
    // var account = Account();

    user_profile.diver.account.username = _controllerUsername.text;
    user_profile.diver.account.email = _controllerEmail.text;
    user_profile.diver.account.password = _controllerPassword.text;
    // var diver = Diver();
    user_profile.diver.firstName = _controllerName.text;
    user_profile.diver.lastName = _controllerLastname.text;
    user_profile.diver.phone = _controllerPhone.text;
    // diver.account = account;
    user_profile.diver.birthDate = Timestamp.fromDateTime(_dateTime);

    var f = File();
    f.filename = 'Image.jpg';
    //var t = await imageFile.readAsBytes();
    //f.file = new List<int>.from(t);
    List<int> b = await divfront.readAsBytes();
    f.file = b;
    user_profile.diver.documents.add(f);

    var f2 = File();
    f2.filename = 'Image.jpg';
    List<int> a = await card.readAsBytes();
    f2.file = a;
    user_profile.diver.documents.add(f2);

    LevelType.values.forEach((levelType) {
      if (levelTypeMap[levelType.toString()] == int.parse(selected)) {
        user_profile.diver.level = levelType;
      }
    });

    var account = Account();
    account.username = user_profile.diver.account.username;
    account.password = _controllerPassword.text;
    account.oldPassword = _controllerOldPassword.text;
    account.email = user_profile.diver.account.email;

    var accountUpdateRequest = UpdateAccountRequest()..account = account;

    var diver = Diver();

    diver.birthDate = user_profile.diver.birthDate;
    diver.level = user_profile.diver.level;
    diver.phone = user_profile.diver.phone;
    diver.firstName = user_profile.diver.firstName;
    diver.lastName = user_profile.diver.lastName;
    for (int i = 0; i < user_profile.diver.documents.length; i++) {
      diver.documents.add(user_profile.diver.documents[i]);
    }
    final updateRequest = UpdateRequest()..diver = diver;

    try {
      var response = stub.update(updateRequest);
      var response2 = stub.updateAccount(accountUpdateRequest);
      print('response: ${response}');
      // print('ddd');
      print('response: ${response2}');
    } catch (e) {
      print(e);
    }
  }

  /// Get from gallery
  _getPicDiver() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 5000,
      maxHeight: 5000,
    );
    if (pickedFile != null) {
      setState(() {
        DiverImage = io.File(pickedFile.path);
        divfront = pickedFile;
      });
      print(pickedFile.path.split('/').last);
    }
  }

  /// Get from gallery
  _getPicCard() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        DiveBack = io.File(pickedFile.path);
        card = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    double screenwidth = MediaQuery.of(context).size.width;
    return SizedBox(
      child: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(children: [
                  SizedBox(height: 20),
                  buildUsernameFormField(),
                  SizedBox(height: 20),
                  buildNameFormField(),
                  SizedBox(height: 20),
                  buildLastnameFormField(),
                  SizedBox(height: 20),
                  // LevelDropdown(),
                  Container(
                    color: Colors.white,
                    //color: Color(0xFFFd0efff),
                    child: Center(
                      child: DropdownButton(
                        isExpanded: true,
                        value: selected,
                        items: listDrop,
                        hint: Text(user_profile.diver.level.toString()),
                        iconSize: 40,
                        onChanged: (value) {
                          setState(() {
                            selected = value;
                            print(value);
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  buildEmailFormField(),
                  SizedBox(height: 20),
                  buildPhoneNumberFormField(),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text('Birthday'),
                      Spacer(),
                      Text(_dateTime == null
                          ? DateFormat("dd/MM/yyyy")
                              .format(user_profile.diver.birthDate.toDateTime())
                          : DateFormat("dd/MM/yyyy").format(_dateTime)),
                      Spacer(),
                      RaisedButton(
                          color: Color(0xfff8dd9cc),
                          child: Text('Pick a date'),
                          onPressed: () {
                            showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(1900),
                                    lastDate: DateTime.now())
                                .then((date) => {
                                      setState(() {
                                        var timeStamp =
                                            print(Timestamp.fromDateTime(date));
                                        _dateTime = date;
                                      })
                                    });
                          }),
                    ],
                  ),
                  SizedBox(height: 20),
                  buildoldpasswordFormField(),
                  SizedBox(height: 20),
                  buildPasswordFormField(),
                  SizedBox(height: 20),
                  Text('Front Image'),
                  Row(
                    children: [

                      SizedBox(width: 30),
                      Container(

                          width: MediaQuery.of(context).size.width/10,
                          height: MediaQuery.of(context).size.width/10,

                          child: user_profile.diver.documents.length == 0
                              ? new Container(
                                  color: Colors.blue,
                                )
                              : Image.network(
                                  // 'http://139.59.101.136/static/'+
                                  user_profile.diver.documents[0].link
                                      .toString())),
                      Center(
                        child: DiverImage == null
                            ? Text('')
                            : kIsWeb
                                ? Image.network(
                                    DiverImage.path,
                                    fit: BoxFit.cover,

                                    width: MediaQuery.of(context).size.width/10,

                                  )
                                : Image.file(
                                    io.File(DiverImage.path),
                                    fit: BoxFit.cover,
                                    width: screenwidth * 0.05,
                                  ),
                      ),
                      /* Spacer(),
              DiverImage == null
                  ? Text('')
                  :
                  print(DiverImage.path)
              ,*/
                      Spacer(),
                      FlatButton(
                        color: Color(0xfffa2c8ff),
                        child: Text(
                          'Upload',
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                          _getPicDiver();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Text('Back image'),
                  Row(
                    children: [

                      SizedBox(width: 30),
                      Container(

                          width: MediaQuery.of(context).size.width/10,
                          height: MediaQuery.of(context).size.width/10,

                          child: user_profile.diver.documents.length == 0
                              ? new Container(
                                  color: Colors.green,
                                )
                              : Image.network(
                                  // 'http://139.59.101.136/static/'+
                                  // 'http:/139.59.101.136/static/1bb37ca5171345af86ff2e052bdf7dee.jpg'
                                  user_profile.diver.documents[1].link
                                      .toString())),
                      Center(
                          child: DiveBack == null
                              ? Text('')
                              : kIsWeb
                                  ? Image.network(
                                      DiveBack.path,
                                      fit: BoxFit.cover,

                                      width: MediaQuery.of(context).size.width/10,

                                    )
                                  : Image.file(
                                      io.File(DiveBack.path),
                                      fit: BoxFit.cover,
                                      width: screenwidth * 0.05,
                                    )),
                      Spacer(),
                      FlatButton(
                        color: Color(0xfffa2c8ff),
                        child: Text(
                          'Upload',
                          style: TextStyle(fontSize: 15),
                        ),
                        onPressed: () {
                          _getPicCard();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  FormError(errors: errors),
                  SizedBox(height: 20),
                  FlatButton(
                    onPressed: () => {
                      // if (_formKey.currentState.validate())
                      //   {
                      // if (_dateTime == null)
                      //   {
                      //     setState(() {
                      //       _dateTime =
                      //           user_profile.diver.birthDate.toDateTime();
                      //     })
                      //   }
                      // else if (selected == null)
                      //   {
                      //     setState(() {
                      //       selected = (levelTypeMap[
                      //               user_profile.diver.level.toString()])
                      //           .toString();
                      //     })
                      //   },

                      sendDiverEdit(),
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MainScreen()))
                      // }
                    },
                    color: Color(0xfff75BDFF),
                    child: Text(
                      'Confirm',
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 20),
                ]),
              ),
            );
          } else {
            return Text('User is not logged in.');
          }
        },
      ),
    );
  }

  TextFormField buildNameFormField() {
    return TextFormField(
      controller: _controllerName,
      cursorColor: Color(0xFFf5579c6),
      keyboardType: TextInputType.name,
      onSaved: (newValue) => name = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter name");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter name");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: user_profile.diver.firstName,
          labelText: "First Name",
          filled: true,
          // fillColor: Color(0xFFFd0efff),,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.person)),
    );
  }

  TextFormField buildLastnameFormField() {
    return TextFormField(
      controller: _controllerLastname,
      cursorColor: Color(0xFFf5579c6),
      keyboardType: TextInputType.name,
      onSaved: (newValue) => lastname = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter lastname");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter lastname");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: user_profile.diver.lastName,
          labelText: "Last Name",
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.person)),
    );
  }

  TextFormField buildUsernameFormField() {
    return TextFormField(
      controller: _controllerUsername,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => username = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter username");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter username");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: user_profile.diver.account.username,
          labelText: "Username",
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.person)),
    );
  }

  TextFormField buildoldpasswordFormField() {
    return TextFormField(
      controller: _controllerOldPassword,
      obscureText: _isObscure,
      onSaved: (newValue) => oldpassword = newValue,
      onChanged: (value) {
        if (password == oldpassword) {
          removeError(error: "Password doesn't match");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          return "";
        } else if (password != value) {
          addError(error: "Password doesn't match");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: "Old password",
          //   hintText: "Confirm password",
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: IconButton(
              icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              })),
    );
  }

  TextFormField buildPasswordFormField() {
    return TextFormField(
      controller: _controllerPassword,
      obscureText: _isObscure,
      onSaved: (newValue) => password = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter password");
        } else if (value.length >= 8) {
          removeError(error: "Password is too short");
        } else if (RegExp(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
            .hasMatch(value)) {
          removeError(error: "Please enter valid Password");
        }
        password = value;
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter password");
          return "";
        } else if (value.length < 8) {
          addError(error: "Password is too short");
          return "";
        } else if (!(RegExp(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'))
            .hasMatch(value)) {
          addError(error: "Please enter valid Password");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          labelText: "New password",
          //  hintText: "Password",
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: IconButton(
              icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                });
              })),
    );
  }

  TextFormField buildEmailFormField() {
    return TextFormField(
      controller: _controllerEmail,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter email");
        } else if (RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
            .hasMatch(value)) {
          removeError(error: "Please enter valid Email");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter email");
          return "";
        } else if (!(RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+"))
            .hasMatch(value)) {
          addError(error: "Please enter valid Email");
          return "";
        }

        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: "Email",
        hintText: user_profile.diver.account.email,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.mail),
      ),
    );
  }

  TextFormField buildPhoneNumberFormField() {
    return TextFormField(
      controller: _controllerPhone,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      onSaved: (newValue) => phoneNumber = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter phone");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter phone");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: "Phone number",
        hintText: user_profile.diver.phone,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.phone),
      ),
    );
  }
}