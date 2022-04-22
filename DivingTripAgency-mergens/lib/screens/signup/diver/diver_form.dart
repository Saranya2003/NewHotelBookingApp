import 'package:diving_trip_agency/form_error.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/timestamp.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pbenum.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:diving_trip_agency/screens/signup/diver/levelDropdown.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'dart:io' as io;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SignupDiverForm extends StatefulWidget {
  @override
  _SignupDiverFormState createState() => _SignupDiverFormState();
}

class _SignupDiverFormState extends State<SignupDiverForm> {
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  String username;
  String name;
  String lastname;
  // String level;
  String phoneNumber;
  String email;
  String password;
  String confirmPassword;
  final List<String> errors = [];
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerLastname = TextEditingController();
  final TextEditingController _controllerUsername = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerConfirm = TextEditingController();
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

  void sendDiver() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);

    final stub = AccountClient(channel);
    // var accountRequest = AccountRequest();
    // var diver =Diver();
    // var account =Account();
    // diver.account=account;
    var account = Account();
    account.username = _controllerUsername.text;
    account.email = _controllerEmail.text;
    account.password = _controllerPassword.text;
    var diver = Diver();
    diver.firstName = _controllerName.text;
    diver.lastName = _controllerLastname.text;
    diver.phone = _controllerPhone.text;
    diver.account = account;
    diver.birthDate = Timestamp.fromDateTime(_dateTime);

    var f = File();
    f.filename = 'Image.jpg';
    //var t = await imageFile.readAsBytes();
    //f.file = new List<int>.from(t);
    List<int> b = await divfront.readAsBytes();
    f.file = b;
    diver.documents.add(f);

    var f2 = File();
    f2.filename = 'Image.jpg';
    List<int> a = await card.readAsBytes();
    f2.file = a;
    diver.documents.add(f2);

    LevelType.values.forEach((levelType) {
      if (levelTypeMap[levelType.toString()] == int.parse(selected)) {
        diver.level = levelType;
      }
    });

    var accountRequest = AccountRequest();
    accountRequest.diver = diver;

    var loginRequest = LoginRequest();
    loginRequest.email = account.email;
    loginRequest.password = account.password;

    var box;
    try {
      var response = await stub.create(accountRequest);
      print('response: ${response}');
      print('login');
      await Hive.openBox('userInfo');
      box = Hive.box('userInfo');
      var response2 = await stub.login(loginRequest);
      box.put('token', response2.token);
      box.put('login', true);
      String token = box.get('token');
      print("login ja");
    } catch (e) {
      print(e);
      box.put('login', false);
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
              child: DropdownButtonFormField(
                isExpanded: true,
                value: selected,
                items: listDrop,
                hint: Text('  Select level'),
                iconSize: 40,
                validator: (value) {
                  if (value == null) {
                    addError(error: "Please select level");
                    return "";
                  }
                  return null;
                },
                onChanged: (value) {
                  if (value != null) {
                    removeError(error: "Please select level");
                    setState(() {
                      selected = value;
                      print(value);
                    });
                  }
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
              //  Text(_dateTime == null ? '' : _dateTime.toString()),

              Text(_dateTime == null
                  ? ''
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
                              if (date != null)
                                {
                                  removeError(error: "Please select date"),
                                  setState(() {
                                    var timeStamp =
                                        print(Timestamp.fromDateTime(date));
                                    _dateTime = date;
                                  })
                                }
                              else if (date == null)
                                {
                                  addError(error: "Please select date"),
                                }
                            });
                  }),
            ],
          ),
          SizedBox(height: 20),
          buildPasswordFormField(),
          SizedBox(height: 20),
          buildConfirmPasswordFormField(),
          SizedBox(height: 20),
          Row(
            children: [
              Text('Front Image'),
              Center(
                child: DiverImage == null
                    ? Text('')
                    : kIsWeb
                        ? Image.network(
                            DiverImage.path,
                            fit: BoxFit.cover,
                            width: screenwidth * 0.2,
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
          Row(
            children: [
              Text('Back image'),
              Center(
                  child: DiveBack == null
                      ? Text('')
                      : kIsWeb
                          ? Image.network(
                              DiveBack.path,
                              fit: BoxFit.cover,
                              width: screenwidth * 0.2,
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
              if (_formKey.currentState.validate())
                {
                  if (_dateTime == null)
                    {
                      addError(error: "Please select date"),
                    }
                    else if (DiverImage==null||DiveBack==null){
                       addError(error: "Please upload image"),
                    }
                  else
                    {
                      sendDiver(),
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => MainScreen()))
                    }
                }
              //_formKey.currentState.save()
              //  print(_controllerUsername.text),
              //   print( _dateTime.toString()),
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
          //      hintText: "Name",
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
          //   hintText: "Lastname",
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
          //     hintText: "Username",
          labelText: "Username",
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.person)),
    );
  }

  TextFormField buildConfirmPasswordFormField() {
    return TextFormField(
      controller: _controllerConfirm,
      obscureText: _isObscure,
      onSaved: (newValue) => confirmPassword = newValue,
      onChanged: (value) {
        if (password == confirmPassword) {
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
          labelText: "Confirm password",
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
          labelText: "Password",
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
        //  hintText: "Email",
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
        // hintText: "Phone number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.phone),
      ),
    );
  }
}
