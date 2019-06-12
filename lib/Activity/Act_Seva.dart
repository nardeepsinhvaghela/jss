import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jss/utils/ConfigApi.dart';
import 'package:jss/utils/CustomThemeData.dart';
import 'package:razorpay_plugin/razorpay_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Act_Seva extends StatefulWidget {
  String sevaId;
  Act_Seva(String sevaID){
    this.sevaId = sevaID;
  }

  @override
  _Act_SevaState createState() => _Act_SevaState(sevaId);
}

class _Act_SevaState extends State<Act_Seva> {
  String name = "";
  double _ele = 0.5;

  TextEditingController sevaSurName_Controller = new TextEditingController();
  TextEditingController sevaName_Controller = new TextEditingController();
  TextEditingController sevaMiddleName_Controller = new TextEditingController();
  TextEditingController sevaEmail_Controller = new TextEditingController();
  TextEditingController sevaDescription_Controller =
      new TextEditingController();
  var sevaMobile_Controller = new MaskedTextController(mask: '000 0000 000');
  TextEditingController sevaArea_Controller = new TextEditingController();
  TextEditingController sevaCity_Controller = new TextEditingController();
  TextEditingController sevaDOB_Controller = new TextEditingController();
  TextEditingController sevaAmount_Controller = new TextEditingController();

//  TODO Focus NODE
  final FocusNode _sevaSurName_Focus = FocusNode();
  final FocusNode _sevaName_Focus = FocusNode();
  final FocusNode _sevaMiddleName_Focus = FocusNode();
  final FocusNode _sevaEmail_Focus = FocusNode();
  final FocusNode _sevaMobile_Focus = FocusNode();
  final FocusNode _sevaDesc_Focus = FocusNode();
  final FocusNode _sevaArea_Focus = FocusNode();
  final FocusNode _sevaCity_Focus = FocusNode();
  final FocusNode _sevaAmount_Focus = FocusNode();

  List<dynamic> category_list = new List();
  String selectSevaId = "";

  String selectCountryName = "";
  String selectStateName = "";
  bool isChecked = false;

  String login_status = "false", login_userEmail = "";
  String login_userToken = "";
  bool isLoading = false;

  DateTime selectedDate = DateTime.now();
  DateTime initialDate = DateTime(1990, 1);
  var formatter = new DateFormat('dd-MM-yyyy');

  _Act_SevaState(String sevaId){
    this.selectSevaId = sevaId;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharePref();
  }

  getSharePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      login_status = prefs.getString("login_status");

      if (login_status != null ||
          login_status != "" ||
          login_status != "false") {
        login_userEmail = prefs.getString("login_userEmail");
        login_userToken = prefs.getString("login_token");
        sevaEmail_Controller.text = login_userEmail;
      }

      print(login_status);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Seva"),
        elevation: 1.0,
        backgroundColor: CustomColors.orageColor,
      ),
      backgroundColor: CustomColors.backgroundColor,
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image:
                    DecorationImage(image: AssetImage("jss_logo_orange.png")),
                backgroundBlendMode: BlendMode.darken,
                color: Colors.grey[100]),
            child: ScrollConfiguration(
              behavior: ScrollBehavior(),
              child: ListView(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 15),
                    child: Text(
                      "Surname".toUpperCase(),
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Quicksand"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      elevation: name == "SurName" ? 3.0 : _ele,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.black12)),
                      margin: EdgeInsets.only(top: 5),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        alignment: Alignment.centerLeft,
                        child: TextField(
                            controller: sevaSurName_Controller,
                            textInputAction: TextInputAction.next,
                            focusNode: _sevaSurName_Focus,
                            onSubmitted: (term) {
                              _sevaSurName_Focus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_sevaName_Focus);
                            },
                            onTap: () {
                              setState(() {
                                name = "SurName";
                              });
                            },
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                fontFamily: "OpenSans",
                                fontWeight: FontWeight.w700),
                            decoration: InputDecoration.collapsed(
                                hintText: "Enter Surname",
                                hintStyle: TextStyle(
                                    fontFamily: "OpenSans",
                                    fontWeight: FontWeight.w700))),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 15),
                    child: Text(
                      "Name".toUpperCase(),
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Quicksand"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      elevation: name == "Name" ? 3.0 : _ele,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.black12)),
                      margin: EdgeInsets.only(top: 5),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        alignment: Alignment.centerLeft,
                        child: TextField(
                            controller: sevaName_Controller,
                            textInputAction: TextInputAction.next,
                            focusNode: _sevaName_Focus,
                            onSubmitted: (term) {
                              _sevaName_Focus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_sevaMiddleName_Focus);
                            },
                            onTap: () {
                              setState(() {
                                name = "Name";
                              });
                            },
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                fontFamily: "OpenSans",
                                fontWeight: FontWeight.w700),
                            decoration: InputDecoration.collapsed(
                                hintText: "Enter Name",
                                hintStyle: TextStyle(
                                    fontFamily: "OpenSans",
                                    fontWeight: FontWeight.w700))),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 15),
                    child: Text(
                      "Middle Name".toUpperCase(),
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Quicksand"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      elevation: name == "MiddleName" ? 3.0 : _ele,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.black12)),
                      margin: EdgeInsets.only(top: 5),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        alignment: Alignment.centerLeft,
                        child: TextField(
                            controller: sevaMiddleName_Controller,
                            textInputAction: TextInputAction.next,
                            focusNode: _sevaMiddleName_Focus,
                            onSubmitted: (term) {
                              _sevaMiddleName_Focus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_sevaEmail_Focus);
                            },
                            onTap: () {
                              setState(() {
                                name = "MiddleName";
                              });
                            },
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                fontFamily: "OpenSans",
                                fontWeight: FontWeight.w700),
                            decoration: InputDecoration.collapsed(
                                hintText: "Enter Middle Name",
                                hintStyle: TextStyle(
                                    fontFamily: "OpenSans",
                                    fontWeight: FontWeight.w700))),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 15),
                    child: Text(
                      "Email".toUpperCase(),
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Quicksand"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.black12)),
                      elevation: name == "email" ? 3.0 : _ele,
                      margin: EdgeInsets.only(top: 5),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        alignment: Alignment.centerLeft,
                        child: TextField(
                          controller: sevaEmail_Controller,
                          textInputAction: TextInputAction.next,
                          focusNode: _sevaEmail_Focus,
                          enabled: false,
                          onSubmitted: (term) {
                            _sevaEmail_Focus.unfocus();
                            FocusScope.of(context)
                                .requestFocus(_sevaMobile_Focus);
                          },
                          onTap: () {
                            setState(() {
                              name = "email";
                            });
                          },
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(
                              fontFamily: "OpenSans",
                              fontWeight: FontWeight.w700),
                          decoration: InputDecoration.collapsed(
                              hintText: "Enter Email",
                              hintStyle: TextStyle(
                                  fontFamily: "OpenSans",
                                  fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 15),
                    child: Text(
                      "Mobile Number".toUpperCase(),
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Quicksand"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.black12)),
                      elevation: name == "mobile" ? 3.0 : _ele,
                      margin: EdgeInsets.only(top: 5),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        alignment: Alignment.centerLeft,
                        child: TextField(
                            controller: sevaMobile_Controller,
                            textInputAction: TextInputAction.next,
                            focusNode: _sevaMobile_Focus,
                            onSubmitted: (term) {
                              _sevaMobile_Focus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_sevaArea_Focus);
                            },
                            onTap: () {
                              setState(() {
                                name = "mobile";
                              });
                            },
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                fontFamily: "OpenSans",
                                fontWeight: FontWeight.w700),
                            decoration: InputDecoration.collapsed(
                                hintText: "Enter Mobile Number",
                                hintStyle: TextStyle(
                                    fontFamily: "OpenSans",
                                    fontWeight: FontWeight.w700))),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 15),
                    child: Text(
                      "Date Of Birth".toUpperCase(),
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Quicksand"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      onTap: () {
                        _selectDate(context);
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: BorderSide(color: Colors.black12)),
                        elevation: name == "dob" ? 3.0 : _ele,
                        margin: EdgeInsets.only(top: 5),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          height: 50.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: Colors.white,
                          ),
                          alignment: Alignment.centerLeft,
                          child: TextField(
                              controller: sevaDOB_Controller,
                              enabled: false,
                              onTap: () {
                                setState(() {
                                  name = "dob";
                                });
                              },
                              style: TextStyle(
                                  fontFamily: "OpenSans",
                                  fontWeight: FontWeight.w700),
                              decoration: InputDecoration.collapsed(
                                  hintText: "Select Date of Birth",
                                  hintStyle: TextStyle(
                                      fontFamily: "OpenSans",
                                      fontWeight: FontWeight.w700))),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 15),
                    child: Text(
                      "Area".toUpperCase(),
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Quicksand"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.black12)),
                      elevation: name == "area" ? 3.0 : _ele,
                      margin: EdgeInsets.only(top: 5),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        alignment: Alignment.centerLeft,
                        child: TextField(
                            controller: sevaArea_Controller,
                            textInputAction: TextInputAction.next,
                            focusNode: _sevaArea_Focus,
                            onSubmitted: (term) {
                              _sevaArea_Focus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_sevaCity_Focus);
                            },
                            onTap: () {
                              setState(() {
                                name = "area";
                              });
                            },
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                fontFamily: "OpenSans",
                                fontWeight: FontWeight.w700),
                            decoration: InputDecoration.collapsed(
                                hintText: "Enter Area",
                                hintStyle: TextStyle(
                                    fontFamily: "OpenSans",
                                    fontWeight: FontWeight.w700))),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 15),
                    child: Text(
                      "City".toUpperCase(),
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Quicksand"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.black12)),
                      elevation: name == "city" ? 3.0 : _ele,
                      margin: EdgeInsets.only(top: 5),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        alignment: Alignment.centerLeft,
                        child: TextField(
                            controller: sevaCity_Controller,
                            textInputAction: TextInputAction.next,
                            focusNode: _sevaCity_Focus,
                            onSubmitted: (term) {
                              _sevaCity_Focus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_sevaAmount_Focus);
                            },
                            onTap: () {
                              setState(() {
                                name = "city";
                              });
                            },
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                fontFamily: "OpenSans",
                                fontWeight: FontWeight.w700),
                            decoration: InputDecoration.collapsed(
                                hintText: "Enter City",
                                hintStyle: TextStyle(
                                    fontFamily: "OpenSans",
                                    fontWeight: FontWeight.w700))),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 15),
                    child: Text(
                      "Country".toUpperCase(),
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Quicksand"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      margin: EdgeInsets.only(top: 5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.black12)),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 50.0,
                        child: DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                            isExpanded: true,
                            hint: Text(
                              selectCountryName == ""
                                  ? "Select Country"
                                  : selectCountryName,
                              style: TextStyle(
                                  fontFamily: "OpenSans",
                                  fontWeight: FontWeight.w700),
                            ),
                            items: <String>[
                              'India',
                              'Pakistan',
                              'Russia',
                              'USA',
                            ].map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(
                                  value,
                                  style: TextStyle(
                                      fontFamily: "OpenSans",
                                      fontWeight: FontWeight.w700),
                                ),
                              );
                            }).toList(),
                            onChanged: (country) {
                              print(country);
                              setState(() {
                                selectCountryName = country;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 15),
                    child: Text(
                      "State".toUpperCase(),
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Quicksand"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      margin: EdgeInsets.only(top: 5),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.black12)),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 50.0,
                        child: DropdownButtonHideUnderline(
                          child: new DropdownButton<String>(
                            isExpanded: true,
                            hint: Text(
                              selectStateName == ""
                                  ? "Select State"
                                  : selectStateName,
                              style: TextStyle(
                                  fontFamily: "OpenSans",
                                  fontWeight: FontWeight.w700),
                            ),
                            items: <String>[
                              'Gujarat',
                              'Rajsthan',
                              'MP',
                              'UP',
                            ].map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(
                                  value,
                                  style: TextStyle(
                                      fontFamily: "OpenSans",
                                      fontWeight: FontWeight.w700),
                                ),
                              );
                            }).toList(),
                            onChanged: (country) {
                              print(country);
                              setState(() {
                                selectStateName = country;
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 15),
                    child: Text(
                      "Amount".toUpperCase(),
                      style: TextStyle(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Quicksand"),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.black12)),
                      elevation: name == "donate" ? 3.0 : _ele,
                      margin: EdgeInsets.only(top: 5),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 50.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        alignment: Alignment.centerLeft,
                        child: TextField(
                            controller: sevaAmount_Controller,
                            textInputAction: TextInputAction.done,
                            focusNode: _sevaAmount_Focus,
                            onSubmitted: (term) {
                              _sevaAmount_Focus.unfocus();
//                          Call api
                            },
                            onTap: () {
                              setState(() {
                                name = "donate";
                              });
                            },
                            keyboardType: TextInputType.phone,
                            style: TextStyle(
                                fontFamily: "OpenSans",
                                fontWeight: FontWeight.w700),
                            decoration: InputDecoration.collapsed(
                                hintText: "Enter Amount",
                                hintStyle: TextStyle(
                                    fontFamily: "OpenSans",
                                    fontWeight: FontWeight.w700))),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 20, top: 15, right: 20.0),
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white54,
                        border: Border.all(color: Colors.black12, width: 1.0)),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Checkbox(
                          value: isChecked,
                          onChanged: (value) {
                            setState(() {
                              isChecked = value;
                            });
                          },
                        ),
                        Expanded(
                          child: Text(
                            "I have read and agree to the terms and conditions",
                            style: TextStyle(
                                fontFamily: "OpenSans",
                                color: Colors.black54,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Card(
                    elevation: 5.0,
                    margin: const EdgeInsets.only(
                        top: 30.0, left: 20.0, right: 20.0, bottom: 30.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30.0))),
                    child:
                        /*RevealProgressButton(),*/ new Row(
                      children: <Widget>[
                        new Expanded(
                          child: new Container(
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30.0))),
                            child: FlatButton(
                              shape: new RoundedRectangleBorder(
                                  borderRadius:
                                      new BorderRadius.circular(30.0)),
                              splashColor: Colors.white30,
                              color: CustomColors.buttonColor,
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 15.0),
                                child: Text(
                                  "SUBMIT",
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              ),
                              onPressed: () {
                                if (validateSurName(sevaSurName_Controller.text)) {
                                  Fluttertoast.showToast(msg: "Enter valid surname");
                                } else if (validateEmail(sevaEmail_Controller.text)) {
                                  Fluttertoast.showToast(msg: "Enter valid email");
                                } else if (selectSevaId == "") {
                                  Fluttertoast.showToast(msg: "Select category");
                                } else if (sevaAmount_Controller.text == "" || sevaAmount_Controller.text == "0") {
                                  Fluttertoast.showToast(msg: "Enter valid amount");
                                } else {
                                  print("Complaint SURName = " + sevaSurName_Controller.text);
                                  print("Complaint Name = " + sevaName_Controller.text);
                                  print("Complaint MiddleName = " + sevaMiddleName_Controller.text);
                                  print("Complaint EMail = " + sevaEmail_Controller.text);
                                  print("Complaint Mobile = " + sevaMobile_Controller.text);
                                  print("Complaint DOB = " + sevaDOB_Controller.text);
                                  print("Complaint Area = " + sevaArea_Controller.text);
                                  print("Complaint City = " + sevaCity_Controller.text);
                                  print("Complaint State = " + selectStateName);
                                  print("Complaint country = " + selectCountryName);
                                  print("Complaint amount = " + sevaAmount_Controller.text);
//                                  sendPaymentProccess();
                                  sendDonationApi();
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
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

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900, 1),
        lastDate: selectedDate);
    if (picked != null && picked != selectedDate)
      setState(() {
        initialDate = picked;
        sevaDOB_Controller.text = formatter.format(initialDate).toString();
        print(formatter.format(initialDate));
      });
  }

  bool validateSurName(String value) {
    if (value.length < 1) {
      return true;
    } else {
      return false;
    }
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

  Future sendPaymentProccess() async {
    Map<String, dynamic> options = new Map();
    options.putIfAbsent("name", () => "Donation");
    options.putIfAbsent(
        "image", () => "https://www.73lines.com/web/image/12427");
    options.putIfAbsent("description", () => "This is a real transaction");
    options.putIfAbsent("amount",
        () => (int.parse(sevaAmount_Controller.text) * 100).toString());
    options.putIfAbsent("email", () => sevaEmail_Controller.text);
    options.putIfAbsent("contact", () => sevaMobile_Controller.text);
    //Must be a valid HTML color.
    options.putIfAbsent("theme", () => "#FFA64D");
    //Notes -- OPTIONAL
    /*Map<String, String> notes = new Map();
    notes.putIfAbsent('key', () => "value");
    notes.putIfAbsent('randomInfo', () => "haha");
    options.putIfAbsent("notes", () => notes);*/
    options.putIfAbsent("api_key", () => "rzp_test_Ow1CEIpzgOAJAe");
    Map<dynamic, dynamic> paymentResponse = new Map();
    paymentResponse = await Razorpay.showPaymentForm(options);
    print("response ${paymentResponse['message']}");
    if (paymentResponse['code'].toString() == "0") {
      Fluttertoast.showToast(msg: paymentResponse['message']);
    } else if (paymentResponse['code'].toString() == "1") {
      Fluttertoast.showToast(msg: paymentResponse['message']);
      sendDonationApi();
    }
  }

  Future sendDonationApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    var body = jsonEncode({
      "fname": sevaSurName_Controller.text,
      "mname": sevaName_Controller.text,
      "lname": sevaMiddleName_Controller.text,
      "email": sevaEmail_Controller.text,
      "mobile": sevaMobile_Controller.text,
      "address": sevaArea_Controller.text,
      "city": sevaCity_Controller.text,
      "country": selectCountryName,
      "state": selectStateName,
      "category": selectSevaId,
      "amount": sevaAmount_Controller.text,
    });

    print(body);
    try {
      var response = await http.post(ConfigApi.SEVA_API,
          body: body,
          headers: {
            "content-type": "application/json",
            "Authorization": 'Bearer $login_userToken'
          });
      print(response.body);
      Map responseMap = jsonDecode(response.body);
      print(responseMap);
      if (responseMap['success'] == true) {
        Fluttertoast.showToast(msg: "Successfully");
        setState(() {
          prefs.setString("login_userisMember", "true");
          sevaSurName_Controller.text = "";
          sevaName_Controller.text = "";
          sevaMiddleName_Controller.text = "";
          sevaSurName_Controller.text = "";
          sevaEmail_Controller.text = "";
          sevaMobile_Controller.text = "";
          sevaArea_Controller.text = "";
          sevaCity_Controller.text = "";
          sevaDOB_Controller.text = "";
          selectCountryName = "";
          selectStateName = "";
          selectSevaId = "";
          sevaAmount_Controller.text = "";
        });
        Navigator.pop(context, true);
      } else {
        Fluttertoast.showToast(msg: "member not created. try again");
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
