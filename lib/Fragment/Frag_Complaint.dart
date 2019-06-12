import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jss/utils/ConfigApi.dart';
import 'package:jss/utils/CustomThemeData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Frag_Complaint extends StatefulWidget {
  Map complainMap = null;
  String operation;

  Frag_Complaint(Map complainList, String operation) {
    this.complainMap = complainList;
    this.operation = operation;
    print(complainList);
  }

  @override
  _Frag_ComplaintState createState() => _Frag_ComplaintState(complainMap,operation);
}

class _Frag_ComplaintState extends State<Frag_Complaint> {
  String name = "";
  double _ele = 0.5;

  TextEditingController complaintSurName_Controller =
      new TextEditingController();
  TextEditingController complaintName_Controller = new TextEditingController();
  TextEditingController complaintMiddleName_Controller =
      new TextEditingController();
  TextEditingController complaintEmail_Controller = new TextEditingController();
  TextEditingController complaintDescription_Controller =
      new TextEditingController();
  var complaintMobile_Controller =
      new MaskedTextController(mask: '000 0000 000');
  TextEditingController complaintArea_Controller = new TextEditingController();
  TextEditingController complaintCity_Controller = new TextEditingController();

//  TODO Focus NODE
  final FocusNode _complaintSurName_Focus = FocusNode();
  final FocusNode _complaintName_Focus = FocusNode();
  final FocusNode _complaintMiddleName_Focus = FocusNode();
  final FocusNode _complaintEmail_Focus = FocusNode();
  final FocusNode _complaintMobile_Focus = FocusNode();
  final FocusNode _complaintDesc_Focus = FocusNode();
  final FocusNode _complaintArea_Focus = FocusNode();
  final FocusNode _complaintCity_Focus = FocusNode();

  String selectCountryName = "";
  String selectStateName = "";
  bool isChecked = false;

  String login_status = "false", login_userEmail = "";
  String login_userToken = "";
  bool isLoading = false;
  String operation = "";
  String complainId = "";
  List<dynamic> complainList = null;

  _Frag_ComplaintState(Map complainMap, String operation) {
    this.operation = operation;
    this.complainId = complainMap['id'] == null ? "" : complainMap['id'].toString();
    complaintSurName_Controller.text = complainMap['fname'] == null ? "" : complainMap['fname'];
    complaintName_Controller.text = complainMap['mname'] == null ? "" : complainMap['mname'];
    complaintMiddleName_Controller.text = complainMap['lname'] == null ? "" : complainMap['lname'];
    complaintEmail_Controller.text = complainMap['email'] == null ? "" : complainMap['email'];
    complaintMobile_Controller.text = complainMap['mobile'] == null ? "" : complainMap['mobile'];
    complaintDescription_Controller.text = complainMap['complaint'] == null ? "" : complainMap['complaint'];
    complaintArea_Controller.text = complainMap['area'] == null ? "" : complainMap['area'];
    complaintCity_Controller.text = complainMap['city'] == null ? "" : complainMap['city'];
    selectCountryName = complainMap['country'] == null ? "" : complainMap['country'];
    selectStateName = complainMap['state'] == null ? "" : complainMap['state'];
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
      }

      print(login_status);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Complain"),
        elevation: 1.0,
        backgroundColor: CustomColors.orageColor,
      ),
//      backgroundColor: Color(0XFFF6FAFC),
      resizeToAvoidBottomPadding: true,
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
                            controller: complaintSurName_Controller,
                            textInputAction: TextInputAction.next,
                            focusNode: _complaintSurName_Focus,
                            onSubmitted: (term) {
                              _complaintSurName_Focus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_complaintName_Focus);
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
                            controller: complaintName_Controller,
                            textInputAction: TextInputAction.next,
                            focusNode: _complaintName_Focus,
                            onSubmitted: (term) {
                              _complaintName_Focus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_complaintMiddleName_Focus);
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
                            controller: complaintMiddleName_Controller,
                            textInputAction: TextInputAction.next,
                            focusNode: _complaintMiddleName_Focus,
                            onSubmitted: (term) {
                              _complaintMiddleName_Focus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_complaintEmail_Focus);
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
                          controller: complaintEmail_Controller,
                          textInputAction: TextInputAction.next,
                          focusNode: _complaintEmail_Focus,
                          onSubmitted: (term) {
                            _complaintEmail_Focus.unfocus();
                            FocusScope.of(context)
                                .requestFocus(_complaintMobile_Focus);
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
                            controller: complaintMobile_Controller,
                            textInputAction: TextInputAction.next,
                            focusNode: _complaintMobile_Focus,
                            onSubmitted: (term) {
                              _complaintMobile_Focus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_complaintDesc_Focus);
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
                      "Complaint".toUpperCase(),
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
                      elevation: name == "complaint" ? 3.0 : _ele,
                      margin: EdgeInsets.only(top: 5),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.white,
                        ),
                        alignment: Alignment.centerLeft,
                        child: TextField(
                            controller: complaintDescription_Controller,
                            textInputAction: TextInputAction.done,
                            focusNode: _complaintDesc_Focus,
                            onSubmitted: (term) {
                              _complaintDesc_Focus.unfocus();
//                          todo Call Api
                            },
                            onTap: () {
                              setState(() {
                                name = "complaint";
                              });
                            },
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                fontFamily: "OpenSans",
                                fontWeight: FontWeight.w700),
                            maxLines: 3,
                            decoration: InputDecoration.collapsed(
                                hintText: "Enter Complaint",
                                hintStyle: TextStyle(
                                    fontFamily: "OpenSans",
                                    fontWeight: FontWeight.w700))),
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
                            controller: complaintArea_Controller,
                            textInputAction: TextInputAction.next,
                            focusNode: _complaintArea_Focus,
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
                            controller: complaintCity_Controller,
                            textInputAction: TextInputAction.next,
                            focusNode: _complaintCity_Focus,
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
                              border: Border.all(color: Colors.grey, width: 1),
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
                                print("Complaint SurName = " +
                                    complaintSurName_Controller.text);
                                print("Complaint Name = " +
                                    complaintName_Controller.text);
                                print("Complaint MiddleName = " +
                                    complaintMiddleName_Controller.text);
                                print("Complaint EMail = " +
                                    complaintEmail_Controller.text);
                                print("Complaint Mobile = " +
                                    complaintMobile_Controller.text);
                                print("Complaint Desc = " +
                                    complaintDescription_Controller.text);
                                print("Complaint Area = " +
                                    complaintArea_Controller.text);
                                print("Complaint City = " +
                                    complaintCity_Controller.text);
                                print("Complaint State = " + selectStateName);
                                print(
                                    "Complaint country = " + selectCountryName);
                                if (complaintSurName_Controller.text == "") {
                                  Fluttertoast.showToast(
                                      msg: "Enter valid surname");
                                } else if (complaintName_Controller.text ==
                                    "") {
                                  Fluttertoast.showToast(
                                      msg: "Enter valid name");
                                } else if (complaintEmail_Controller.text ==
                                    "") {
                                  Fluttertoast.showToast(
                                      msg: "Enter valid name");
                                } else if (complaintDescription_Controller
                                        .text ==
                                    "") {
                                  Fluttertoast.showToast(
                                      msg: "Enter complain description");
                                } else {
                                  if(operation == "Add"){
                                    sendAddComplaintAPI();
                                  }else{
                                    sendEditComplaintAPI(complainId);
                                  }
                                }
                              }),
                        )),
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

  Future sendAddComplaintAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    var body = jsonEncode({
      "fname": complaintSurName_Controller.text,
      "mname": complaintName_Controller.text,
      "lname": complaintMiddleName_Controller.text,
      "email": complaintEmail_Controller.text,
      "mobile": complaintMobile_Controller.text,
      "complaint": complaintDescription_Controller.text,
      "area": complaintArea_Controller.text,
      "city": complaintCity_Controller.text,
      "country": selectCountryName,
      "state": selectStateName
    });

    print(body);
    try {
      var response = await http.post(ConfigApi.COMPLAIN_API,
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

  Future sendEditComplaintAPI(String complainId) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    var body = jsonEncode({
      "fname": complaintSurName_Controller.text,
      "mname": complaintName_Controller.text,
      "lname": complaintMiddleName_Controller.text,
      "email": complaintEmail_Controller.text,
      "mobile": complaintMobile_Controller.text,
      "complaint": complaintDescription_Controller.text,
      "area": complaintArea_Controller.text,
      "city": complaintCity_Controller.text,
      "country": selectCountryName,
      "state": selectStateName
    });

    print(body);
    try {
      var response = await http.put(ConfigApi.COMPLAIN_API+"/$complainId",
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
