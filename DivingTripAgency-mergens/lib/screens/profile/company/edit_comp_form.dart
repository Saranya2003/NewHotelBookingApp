import 'dart:io' as io;
import 'package:diving_trip_agency/form_error.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/agency.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:diving_trip_agency/screens/signup/company/signup_divemaster.dart';
import 'package:flutter/material.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import '../../../nautilus/proto/dart/model.pb.dart';
import 'package:multi_image_picker2/multi_image_picker2.dart';
import 'package:fixnum/fixnum.dart';

GetProfileResponse user_profile = new GetProfileResponse();
var profile;

final TextEditingController _controllerName =
    TextEditingController(text: user_profile.agency.name);
final TextEditingController _controllerUsername =
    TextEditingController(text: user_profile.agency.account.username);
final TextEditingController _controllerPassword = TextEditingController();
final TextEditingController _controllerCompanyemail =
    TextEditingController(text: user_profile.agency.account.email);
final TextEditingController _controllerAddress =
    TextEditingController(text: user_profile.agency.address.addressLine1);
final TextEditingController _controllerPhone =
    TextEditingController(text: user_profile.agency.phone);
final TextEditingController _controlleroldpassword = TextEditingController();
final TextEditingController _controllerAddress2 =
    TextEditingController(text: user_profile.agency.address.addressLine2);
final TextEditingController _controllerPostalcode =
    TextEditingController(text: user_profile.agency.address.postcode);
final TextEditingController _controllerCountry =
    TextEditingController(text: user_profile.agency.address.country);
final TextEditingController _controllerRegion =
    TextEditingController(text: user_profile.agency.address.region);
final TextEditingController _controllerCity =
    TextEditingController(text: user_profile.agency.address.city);

class EditCompanyForm extends StatefulWidget {
  @override
  _EditCompanyFormState createState() => _EditCompanyFormState();
}

class _EditCompanyFormState extends State<EditCompanyForm> {
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
    // print(0);
    // print(user_profile.agency.account.email);
    // print(user_profile.agency.phone);
    // print(user_profile.agency.name);
    // print(user_profile.agency.documents);
    // print(user_profile.agency.address.addressLine1);
    // print(user_profile.agency.address.addressLine2);
    // print(user_profile.agency.address.city);
    // print(user_profile.agency.address.country);
    // print(user_profile.agency.address.region);
    // print(user_profile.agency.address.postcode);
    // print(1);

    return user_profile;
  }

  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();
  String name;
  String username;
  String companyEmail;
  // String email;
  String phoneNumber;
  String address1;
  String password;
  String oldpassword;
  String address2;
  String postalCode;
  String country;
  String region;
  String city;
  io.File _image;
  final List<String> errors = [];

  io.File imageFile;
  io.File docFile;
  var bytes;
  //List<io.File> imagelist = <io.File>[];
  List<Asset> imagelist = <Asset>[];
  List<io.File> docList = <io.File>[];

  PickedFile Img;
  PickedFile doc;

  /// Get from gallery
  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 5000,
      maxHeight: 5000,
    );
    if (pickedFile != null) {
      setState(() {
        imageFile = io.File(pickedFile.path);

        Img = pickedFile;

        //bytes = imageFile.readAsBytes();
      });
    }
  }

  _getdoc() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        docFile = io.File(pickedFile.path);
        doc = pickedFile;
      });
    }
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

  void sendCompanyEdit() async {
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

    user_profile.agency.account.username = _controllerUsername.text;
    user_profile.agency.account.email = _controllerCompanyemail.text;
    user_profile.agency.account.password = _controllerPassword.text;

    user_profile.agency.address.addressLine1 = _controllerAddress.text;
    user_profile.agency.address.addressLine2 = _controllerAddress2.text;
    user_profile.agency.address.city = _controllerCity.text;
    user_profile.agency.address.postcode = _controllerPostalcode.text;
    user_profile.agency.address.region = _controllerRegion.text;
    user_profile.agency.address.country = _controllerCountry.text;

    user_profile.agency.name = _controllerName.text;
    user_profile.agency.phone = _controllerPhone.text;
    //agency.documents.add(imageFile);

    //final pngByteData = await imageFile.toByteData(format: ImageByteFormat.png);

    //ns file

    var f = File();
    f.filename = 'Image.jpg';
    //var t = await imageFile.readAsBytes();
    //f.file = new List<int>.from(t);
    List<int> b = await doc.readAsBytes();
    f.file = b;
    user_profile.agency.documents.add(f);

    var f2 = File();
    f2.filename = 'Image.jpg';
    List<int> a = await Img.readAsBytes();
    f2.file = a;
    user_profile.agency.documents.add(f2);

    var account = Account();
    account.username = user_profile.agency.account.username;
    account.password = _controllerPassword.text;
    account.oldPassword = _controlleroldpassword.text;
    account.email = user_profile.agency.account.email;

    var accountUpdateRequest = UpdateAccountRequest()..account = account;

    // accountUpdateRequest.account.username =
    //     user_profile.agency.account.username;
    // accountUpdateRequest.account.password =
    //     user_profile.agency.account.password;
    // accountUpdateRequest.account.email = user_profile.agency.account.email;

    var address = Address();
    address.addressLine1 = user_profile.agency.address.addressLine1;
    address.addressLine2 = user_profile.agency.address.addressLine2;
    address.city = user_profile.agency.address.city;
    address.country = user_profile.agency.address.country;
    address.postcode = user_profile.agency.address.postcode;
    address.region = user_profile.agency.address.region;

    var agency = Agency()..address = address;
    agency.name = user_profile.agency.name;
    agency.phone = user_profile.agency.phone;
    for (int i = 0; i < user_profile.agency.documents.length; i++) {
      agency.documents.add(user_profile.agency.documents[i]);
    }
    //  agency.address.addressLine1 =
    //     user_profile.agency.address.addressLine1;
    // agency.address.addressLine2 =
    //     user_profile.agency.address.addressLine2;
    // agency.address.city = user_profile.agency.address.city;
    // agency.address.country = user_profile.agency.address.country;
    // agency.address.postcode =
    //     user_profile.agency.address.postcode;
    // agency.address.region = user_profile.agency.address.region;

    final updateRequest = UpdateRequest()..agency = agency;
    // updateRequest.agency.name = user_profile.agency.name;
    // updateRequest.agency.phone = user_profile.agency.phone;
    // for (int i = 0; i < user_profile.agency.documents.length; i++) {
    //   updateRequest.agency.documents.add(user_profile.agency.documents[i]);
    // }
    // updateRequest.agency.address.addressLine1 =
    //     user_profile.agency.address.addressLine1;
    // updateRequest.agency.address.addressLine2 =
    //     user_profile.agency.address.addressLine2;
    // updateRequest.agency.address.city = user_profile.agency.address.city;
    // updateRequest.agency.address.country = user_profile.agency.address.country;
    // updateRequest.agency.address.postcode =
    //     user_profile.agency.address.postcode;
    // updateRequest.agency.address.region = user_profile.agency.address.region;

    try {
      var response = pf.update(updateRequest);
      print('response: ${response}');
      print('----------');
      var response2 = pf.updateAccount(accountUpdateRequest);

      print('response: ${response2}');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  buildCompanyEmailFormField(),
                  SizedBox(height: 20),
                  // buildEmailFormField(),
                  // SizedBox(height: 20),
                  buildPhoneNumberFormField(),
                  SizedBox(height: 20),
                  buildAddressFormField(),
                  SizedBox(height: 20),
                  buildAddress2FormField(),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width / 3.6,
                          child: buildCountryFormField()),
                      Spacer(),
                      // Spacer(flex: 1,),
                      Container(
                          width: MediaQuery.of(context).size.width / 3.6,
                          child: buildCityFormField()),
                    ],
                  ),

                  SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width / 3.6,
                          child: buildRegionFormField()),
                      Spacer(),
                      Container(
                          width: MediaQuery.of(context).size.width / 3.6,
                          child: buildPostalCodeFormField()),
                    ],
                  ),
                  SizedBox(height: 20),
                  buildoldpasswordFormField(),
                  SizedBox(height: 20),
                  buildPasswordFormField(),
                  SizedBox(height: 20),
                  Column(
                    children: [
                      Text('Verified'),
                      Text('Document'),
                    ],
                  ),
                  Row(
                    children: [

                      SizedBox(width: 30),
                      Container(
                          width: MediaQuery.of(context).size.width/10,
                          height: MediaQuery.of(context).size.width/10,
                          child: user_profile.agency.documents.length == 0
                              ? new Container(
                                  color: Colors.pink,
                                )
                              : Image.network(
                                  // 'http:/139.59.101.136/static/1bb37ca5171345af86ff2e052bdf7dee.jpg'
                                  user_profile.agency.documents[1].link
                                      .toString())),
                      Center(
                          child: docFile == null
                              ? Column(
                                  children: [Text('')],
                                )
                              : kIsWeb
                                  ? Image.network(
                                      docFile.path,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width/10,
                                    )
                                  : Image.file(
                                      io.File(docFile.path),
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
                          _getdoc();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  //Center(child:imageFile == null ? Text('No image selected'):Text("You have an image")),
                  //Center(child:imageFile == null ? Text('No image selected'):Image.file(imageFile,fit:BoxFit.cover,)),
                  Column(
                    children: [
                      Text('Company'),
                      Text('Image'),
                    ],
                  ),
                  Row(
                    children: [

                      SizedBox(width: 30),
                      Container(
                          width: MediaQuery.of(context).size.width/10,
                          height: MediaQuery.of(context).size.width/10,
                          child: user_profile.agency.documents.length == 0
                              ? new Container(
                                  color: Colors.green,
                                )
                              : Image.network(
                                  // 'http:/139.59.101.136/static/1bb37ca5171345af86ff2e052bdf7dee.jpg'
                                  user_profile.agency.documents[1].link
                                      .toString())),
                      Center(
                          child: imageFile == null
                              ? Text('')
                              : kIsWeb
                                  ? Image.network(
                                      imageFile.path,
                                      fit: BoxFit.cover,
                                      width: MediaQuery.of(context).size.width/10,
                                    )
                                  : Image.file(
                                      io.File(imageFile.path),
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

                          _getFromGallery();
                        },
                      ),
                    ],
                  ),
                  //Center(child:imageFile == null ? Text('No image selected'):Text(imageFile.path.split('/').last)),

                  SizedBox(height: 20),
                  SizedBox(height: 20),
                  FormError(errors: errors),
                  SizedBox(height: 20),
                  FlatButton(
                    onPressed: () => {
                      sendCompanyEdit(),
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainCompanyScreen())),
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
          hintText: user_profile.agency.name,
          labelText: "First Name",
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
      keyboardType: TextInputType.name,
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
          hintText: user_profile.agency.account.username,
          labelText: "Username",
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.person)),
    );
  }

  TextFormField buildAddressFormField() {
    return TextFormField(
      controller: _controllerAddress,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => address1 = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter address");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter address");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: user_profile.agency.address.addressLine1,
          labelText: "Address 1",
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.home)),
    );
  }

  TextFormField buildoldpasswordFormField() {
    return TextFormField(
      controller: _controlleroldpassword,
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
          //  hintText: "Confirm password",
          labelText: "Old Password",
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
        } else if (value.length >= 6) {
          removeError(error: "Password is too short");
        } else if (RegExp(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
            .hasMatch(value)) {
          removeError(error: "Please enter valid password");
        }
        password = value;
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter password");
          return "";
        } else if (value.length < 6) {
          addError(error: "Password is too short");
          return "";
        } else if (!(RegExp(
                r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$'))
            .hasMatch(value)) {
          addError(error: "Please enter valid password");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: user_profile.agency.account.password,
          labelText: "New password",
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

  TextFormField buildCompanyEmailFormField() {
    return TextFormField(
      controller: _controllerCompanyemail,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => companyEmail = newValue,
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
        hintText: user_profile.agency.account.email,
        labelText: "Company email",
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
        hintText: user_profile.agency.phone,
        labelText: "Phone number",
        floatingLabelBehavior: FloatingLabelBehavior.always,
        suffixIcon: Icon(Icons.phone),
      ),
    );
  }

  TextFormField buildAddress2FormField() {
    return TextFormField(
      controller: _controllerAddress2,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => address2 = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter address");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter address");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
          hintText: user_profile.agency.address.addressLine2,
          labelText: "Address 2",
          filled: true,
          fillColor: Colors.white,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          suffixIcon: Icon(Icons.home)),
    );
  }

  TextFormField buildCountryFormField() {
    return TextFormField(
      controller: _controllerCountry,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => country = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter country");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter country");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: user_profile.agency.address.country,
        labelText: "Country",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildCityFormField() {
    return TextFormField(
      controller: _controllerCity,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => city = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter city");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter city");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: user_profile.agency.address.city,
        labelText: "City",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildRegionFormField() {
    return TextFormField(
      controller: _controllerRegion,
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => region = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter region");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter region");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: user_profile.agency.address.region,
        labelText: "Region",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }

  TextFormField buildPostalCodeFormField() {
    return TextFormField(
      controller: _controllerPostalcode,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
      ],
      cursorColor: Color(0xFFf5579c6),
      onSaved: (newValue) => postalCode = newValue,
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: "Please enter postal code");
        }
        return null;
      },
      validator: (value) {
        if (value.isEmpty) {
          addError(error: "Please enter postal code");
          return "";
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: user_profile.agency.address.postcode,
        labelText: "Postal code",
        filled: true,
        fillColor: Colors.white,
        floatingLabelBehavior: FloatingLabelBehavior.always,
      ),
    );
  }
}