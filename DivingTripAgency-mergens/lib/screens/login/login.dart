import 'package:diving_trip_agency/nautilus/proto/dart/account.pbgrpc.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/account.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/model.pb.dart';
import 'package:diving_trip_agency/nautilus/proto/dart/google/protobuf/empty.pb.dart';
import 'package:diving_trip_agency/screens/main/mainScreen.dart';
import 'package:diving_trip_agency/screens/main/main_screen_company.dart';
import 'package:diving_trip_agency/screens/signup/company/signup_company.dart';
import 'package:diving_trip_agency/screens/signup/diver/signup_diver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import '../main/mainScreen.dart';
import '../main/main_screen_company.dart';
import 'constant.dart';
import 'package:hive/hive.dart';

//import 'dart:typed_data';
//import 'package:hive/hive.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _rememberMe = false;
  bool _isObscure = true;
  //var dummyusername = 'Numchok';
  //var dummypassword = 'Numchok';
  final usrcontroller = TextEditingController();
  final psscontroller = TextEditingController();

  void sendLogin() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);

    final stub = AccountClient(channel);
    var account = Account();
    account.email = usrcontroller.text;
    account.password = psscontroller.text;

    var loginRequest = LoginRequest();
    loginRequest.email = account.email;
    loginRequest.password = account.password;

    //try {
    //var response = stub.login(loginRequest);
    //print('response: ${response}');
    //response.then((p0) => {
    //send token to other files
    //print(p0.token)
    //});
    //} catch (e) {

    //print(e);
    //}
    //}
    try {
      //var response = await stub.login(loginRequest);
      //var response = Hive.stub.login(loginRequest);
      //print('Response received: ${response}');

      await Hive.openBox('userInfo');

      final box = Hive.box('userInfo');

      var response = await stub.login(loginRequest);

      box.put('token', response.token);
      String token = box.get('token');
      print(token);
    } on GrpcError catch (e) {
      // Handle exception of type GrpcError
      print('codeName: ${e.codeName}');
      print('details: ${e.details}');
      print('message: ${e.message}');
      print('rawResponse: ${e.rawResponse}');
      print('trailers: ${e.trailers}');

      var response = stub.login(loginRequest);
      print('response: ${response}');
      response.then((p0) => {print(p0.token)});
    } catch (e) {
      // Handle all other exceptions
      print('Exception: $e');
    }
  }

  Widget _buildEmailTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Email', style: TextStyle(color: Colors.black)
            // kLabelStyle,
            ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: usrcontroller,
            keyboardType: TextInputType.emailAddress,
            style: TextStyle(
              color: Colors.black,
              //fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.email,
                color: Colors.black,
              ),
              hintText: 'Enter your Email',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordTF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Password', style: TextStyle(color: Colors.black)
            //kLabelStyle,
            ),
        SizedBox(height: 10.0),
        Container(
          alignment: Alignment.centerLeft,
          decoration: kBoxDecorationStyle,
          height: 60.0,
          child: TextField(
            controller: psscontroller,
            obscureText: _isObscure,
            style: TextStyle(
              color: Colors.black,
              // fontFamily: 'OpenSans',
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock,
                color: Colors.black,
              ),
              suffixIcon: IconButton(
                  icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      _isObscure = !_isObscure;
                    });
                  }),
              hintText: 'Enter your Password',
              hintStyle: kHintTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPasswordBtn() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () => print('Forgot Password Button Pressed'),
        padding: EdgeInsets.only(right: 0.0),
        child: Text('Forgot Password?', style: TextStyle(color: Colors.black)
            //kLabelStyle,
            ),
      ),
    );
  }

  Widget _buildRememberMeCheckbox() {
    return Container(
      height: 20.0,
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.black),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value;
                });
              },
            ),
          ),
          Text('Remember me', style: TextStyle(color: Colors.black)
              //kLabelStyle,
              ),
        ],
      ),
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () => {
          sendLogin(),
          print('Login Button Pressed'), //Determine what to do after clicking
          // usrcontroller.text == dummyusername &&
          //         psscontroller.text == dummypassword
          //     ?
          //showError(),
          checkAuthen(),

          //Navigator.push(context,
          //MaterialPageRoute(builder: (context) => MainCompanyScreen()))
          // : showDialog(
          //     context: context,
          //     builder: (context) {
          //       return AlertDialog(
          //           content: Text("Incorrect Username or Password"));
          //     })
        },
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            // fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildSignInWithText() {
    return Column(
      children: <Widget>[
        Text(
          '- OR -',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: 20.0),
        Text('Sign up as',
            style: TextStyle(
              color: Colors.black,
            )
            //  kLabelStyle,
            ),
      ],
    );
  }

  Widget _buildSocialBtn(Function onTap, AssetImage logo) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],
          image: DecorationImage(
            image: logo,
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtnRow() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
      //padding: EdgeInsets.symmetric(vertical: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        /*children: <Widget>[
          _buildSocialBtn(
                () => print('Login with Facebook'),
            AssetImage(
              'assets/images/facebook.jpg',
            ),
          ),*/
        children: <Widget>[
          RaisedButton(
            elevation: 5.0,
            onPressed: () {
              print(
                  'Login Button Pressed'); //Determine what to do after clicking
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SignUpDiverScreen()));
            },
            padding: EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Colors.white,
            child: Text(
              'Diver',
              style: TextStyle(
                color: Color(0xFF527DAA),
                letterSpacing: 1.5,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                // fontFamily: 'OpenSans',
              ),
            ),
          ),
          /*_buildSocialBtn(
                () => print('Login with Google'),
            AssetImage(
              'assets/images/google.jpg',
            ),
          ),*/
          RaisedButton(
            elevation: 5.0,
            onPressed: () {
              print(
                  'Login Button Pressed'); //Determine what to do after clicking
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SignupCompanyScreen()));
            },
            padding: EdgeInsets.all(15.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
            color: Colors.white,
            child: Text(
              'Company',
              style: TextStyle(
                color: Color(0xFF527DAA),
                letterSpacing: 1.5,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                // fontFamily: 'OpenSans',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignupBtn() {
    return GestureDetector(
      onTap: () => print('Sign Up Button Pressed'),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Don\'t have an Account? ',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Sign Up',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                    //color: Color(0xfffdcfffb)
                    gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.topRight,
                        colors: [
                      // Color(0xfff7AD7F0),
                      Color(0xfff92DFF3),
                      Color(0xfffB7E9F7),
                      Color(0xfffDBF3FA),
                      Color(0xfffF5FCFF),
                    ])
                    // decoration: BoxDecoration(
                    //     image: DecorationImage(
                    //         image: AssetImage("assets/images/S__77250562.jpg"),
                    //         fit: BoxFit.cover) //Background

                    //color:Colors.white,
                    /*gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],*/

                    ),
              ),
              Container(
                //height: double.infinity,

                constraints: BoxConstraints(maxWidth: 400, maxHeight: 600),
                //margin: EdgeInsets.all(80),
                //height: 600,
                //width: 661,

                decoration: BoxDecoration(color: Color(0xfff7AD7F0)
                    // Colors.greenAccent.withOpacity(0.5)
                    ),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.only(left: 40, top: 10, right: 40
                      //padding: EdgeInsets.symmetric(
                      //  horizontal: 40.0,
                      //  vertical: 40.0,
                      //vertical: 120.0,
                      ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: Color(0xFF527DAA),
                          // color: Colors.white,
                          //fontFamily: 'OpenSans',
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          // shadows: [
                          //   Shadow(
                          //       // bottomLeft
                          //       offset: Offset(-1.5, -1.5),
                          //       color: Colors.black),
                          //   Shadow(
                          //       // bottomRight
                          //       offset: Offset(1.5, -1.5),
                          //       color: Colors.black),
                          //   Shadow(
                          //       // topRight
                          //       offset: Offset(1.5, 1.5),
                          //       color: Colors.black),
                          //   Shadow(
                          //       // topLeft
                          //       offset: Offset(-1.5, 1.5),
                          //       color: Colors.black),
                          //    ],
                        ),
                      ),
                      SizedBox(height: 30.0),
                      _buildEmailTF(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildPasswordTF(),
                      _buildForgotPasswordBtn(),
                     // _buildRememberMeCheckbox(),
                      _buildLoginBtn(),
                      _buildSignInWithText(),
                      _buildSocialBtnRow(),
                      //_buildSignupBtn(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showError() async {
    await Future.delayed(Duration(microseconds: 1));
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text("Incorrect password or username, please try again."),
            actions: <Widget>[
              FlatButton(
                  //child: Text("OK"),
                  ),
            ],
          );
        });
  }

  Future<Null> checkAuthen() async {
    final channel = GrpcOrGrpcWebClientChannel.toSeparatePorts(
        host: '139.59.101.136',
        grpcPort: 50051,
        grpcTransportSecure: false,
        grpcWebPort: 8080,
        grpcWebTransportSecure: false);

    final stub = AccountClient(channel);
    var account = Account();
    account.email = usrcontroller.text;
    account.password = psscontroller.text;

    var loginRequest = LoginRequest();
    loginRequest.email = account.email;
    loginRequest.password = account.password;


    var box;
    try {
      await Hive.openBox('userInfo');
      box = Hive.box('userInfo');
      var response = await stub.login(loginRequest);
      box.put('token', response.token);
      box.put('login', true);
      String token = box.get('token');
      print("Valid Username!");

      final pf = AccountClient(channel,
          options: CallOptions(metadata: {'Authorization': '$token'}));
      var profile = await pf.getProfile(new Empty());
      print(profile);

      if (profile.hasAdmin()){
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => MainCompanyScreen()));
      }

      if (profile.hasDiver()){
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => MainScreen()));
      }

      if (profile.hasAgency()){
        Navigator.push(context,
          MaterialPageRoute(builder: (context) => MainCompanyScreen()));
      }

    } on GrpcError catch (e) {
      showError();
      box.put('login', false);
    } catch (e) {
      // Handle all other exceptions
      print('Exception: $e');
    }
  }
}
