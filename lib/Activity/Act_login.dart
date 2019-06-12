import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jss/Activity/Act_DashBoard.dart';
import 'package:jss/Activity/Act_Registration.dart';
import 'package:jss/Fragment/Frag_Magazine.dart';
import 'package:jss/utils/ConfigApi.dart';
import 'package:jss/utils/CustomThemeData.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Act_Login extends StatefulWidget {
  @override
  _Act_LoginState createState() => _Act_LoginState();
}

class _Act_LoginState extends State<Act_Login> {
  TextEditingController _textEditingController_Email =
      new TextEditingController();
  TextEditingController _textEditingController_Password =
      new TextEditingController();

//  Focus Variable
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body: Stack(
        children: <Widget>[
          ListView(
            children: <Widget>[
              _header(),
              Padding(padding: EdgeInsets.only(top: 50.0)),
              _textField_EmailWidget(),
              Padding(padding: EdgeInsets.only(top: 10.0)),
              _textField_PassWidget(),
              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                      fontFamily: "Quicksand"),
                ),
              ),
              _buttonWidget(),
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Don't have an account?",
                        style: TextStyle(
                            fontFamily: "OpenSans",
                            fontWeight: FontWeight.w700,
                            color: Colors.black54),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Act_Registration()));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                          child: Text(
                            " Register",
                            style: TextStyle(
                                fontFamily: "OpenSans",
                                fontWeight: FontWeight.w700,
                                color: CustomColors.orageColor),
                          ),
                        ),
                      )
                    ]),
              ),
            ],
          ),
          isLoading
              ? Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: Colors.black38,
            child: Center(
              child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(
                    CustomColors.progressBar),
              ),
            ),
          )
              : Container(),
        ],
      ),
    );
  }

  Widget _header() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: CustomColors.orageColor,
//          gradient: LinearGradient(
//              colors: [const Color(0xFFF2841E), const Color(0xFFF4591E)]),
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100.0))),
      child: Image.asset("jss_logo_white.png"),
    );
  }

  Widget _textField_EmailWidget() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      elevation: 1.0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0))),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: Colors.grey.withOpacity(0.8),
            ),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0))),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.mail,
              color: Colors.grey,
            ),
            Padding(padding: EdgeInsets.only(left: 10.0)),
            Expanded(
              child: TextFormField(
                focusNode: _emailFocus,
                controller: _textEditingController_Email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                style: TextStyle(
                    fontFamily: "OpenSans", fontWeight: FontWeight.w600),
                onFieldSubmitted: (term) {
                  _emailFocus.unfocus();
                  FocusScope.of(context).requestFocus(_passFocus);
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Email',
                  hintStyle: TextStyle(
                      color: Colors.black45,
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _textField_PassWidget() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      elevation: 1.0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0))),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
            border: Border.all(
              width: 1.0,
              color: Colors.grey.withOpacity(0.8),
            ),
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(25.0),
                topRight: Radius.circular(25.0))),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.lock,
              color: Colors.grey,
            ),
            Padding(padding: EdgeInsets.only(left: 10.0)),
            Expanded(
              child: TextFormField(
                focusNode: _passFocus,
                controller: _textEditingController_Password,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                style: TextStyle(
                    fontFamily: "OpenSans", fontWeight: FontWeight.w600),
                obscureText: true,
                onFieldSubmitted: (term) {
                  _passFocus.unfocus();
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Password',
                  hintStyle: TextStyle(
                      color: Colors.black45,
                      fontFamily: "OpenSans",
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buttonWidget() {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.only(
          top: 30.0, left: 20.0, right: 20.0, bottom: 10.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(30.0))),
      child:
          /*RevealProgressButton(),*/ new Row(
        children: <Widget>[
          new Expanded(
              child: new Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey, width: 1),
                borderRadius: BorderRadius.all(Radius.circular(30.0))),
            child: FlatButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                splashColor: Colors.white30,
                color: CustomColors.buttonColor,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                  child: Text(
                    "LOGIN",
                    style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: "Quicksand"),
                  ),
                ),
                onPressed: () {
                  if (validateEmail(_textEditingController_Email.text)) {
                    Fluttertoast.showToast(msg: "Enter Valid Email");
                  } else if (validatePassword(
                      _textEditingController_Password.text)) {
                    Fluttertoast.showToast(msg: "Enter valid password");
                  } else {
                    sendLoginApi();
                  }
//                  Navigator.push(context,
//                      MaterialPageRoute(builder: (context) => Act_DashBoard()));
                }),
          )),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
                title: new Text('Are you sure?'),
                content: new Text('Do you want to exit an App'),
                actions: <Widget>[
                  new GestureDetector(
                    onTap: () => Navigator.of(context).pop(false),
                    child: Container(
                        padding: EdgeInsets.only(
                            left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
                        child: Text(
                          "No",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                  ),
                  new GestureDetector(
                    onTap: () {
                      exit(0);
                    },
                    child: Container(
                        padding: EdgeInsets.only(
                            left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
                        child: Text(
                          " Yes ",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        )),
                  ),
                ],
              ),
        ) ??
        false;
  }

  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return true;
    else
      return false;
  }

  bool validatePassword(String value) {
    if (value.length < 6 || value.length > 16) {
      return true;
    } else {
      return false;
    }
  }

  sendLoginApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("email = " + _textEditingController_Email.text);
    print("password = " + _textEditingController_Password.text);

    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    var body = jsonEncode({
      "email": _textEditingController_Email.text,
      "password": _textEditingController_Password.text,
    });

    try {
      var response = await http.post(ConfigApi.LOGIN_API,
          body: body, headers: {"content-Type": "application/json"});
      print(response.body);
      Map responseMap = jsonDecode(response.body);
      print("MAP ==> "+responseMap.toString());
      if (responseMap['success'] == "true") {
        prefs.setString("login_status", "true");
        prefs.setString("login_token", responseMap['access_token']);
        prefs.setString("login_tokenType", responseMap['token_type']);
        prefs.setString("login_userId", responseMap['user'] == null ? "" : responseMap['user']['id'].toString());
        prefs.setString("login_userName", responseMap['user'] == null ? "" : responseMap['user']['name'] == null ? "" : responseMap['user']['name']);
        prefs.setString("login_userEmail", responseMap['user'] == null ? "" : responseMap['user']['email'] == null ? "" : responseMap['user']['email']);
        prefs.setString("login_userEmail", responseMap['user'] == null ? "" : responseMap['user']['email'] == null ? "" : responseMap['user']['email']);
        prefs.setString("login_userisMember", responseMap['user'] == null ? "" : responseMap['user']['isMember'] == null ? "" : responseMap['user']['isMember']);
        prefs.setString("isSubscriber", "false");

        Fluttertoast.showToast(msg: "Login success");
        Navigator.pop(context, "true");
      } else {
        Fluttertoast.showToast(msg: "Try Again");
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }
}
