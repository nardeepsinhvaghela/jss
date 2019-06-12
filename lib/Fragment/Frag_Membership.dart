import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jss/Activity/Act_login.dart';
import 'package:jss/utils/ConfigApi.dart';
import 'package:jss/utils/CustomThemeData.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

class Frag_Membership extends StatefulWidget {
  @override
  _Frag_MembershipState createState() => _Frag_MembershipState();
}

class _Frag_MembershipState extends State<Frag_Membership> {
  String name = "";
  double _ele = 0.5;

//  todo login detail
  String login_status = "false";
  String login_userIsMember = "false";
  String login_userToken = "";
  bool isLoading = false;
  List<dynamic> memberType_list = new List();

  DateTime selectedDate = DateTime.now();
  DateTime initialDate = DateTime(1990, 1);
  var formatter = new DateFormat('dd-MM-yyyy');

  TextEditingController memberSurName_Controller = new TextEditingController();
  TextEditingController memberName_Controller = new TextEditingController();
  TextEditingController memberMiddleName_Controller =
      new TextEditingController();
  TextEditingController memberEmail_Controller = new TextEditingController();
  TextEditingController memberAddress_Controller = new TextEditingController();
  TextEditingController memberDOB_Controller = new TextEditingController();
  TextEditingController memberCity_Controller = new TextEditingController();
  TextEditingController memberState_Controller = new TextEditingController();
  TextEditingController memberDonation_Controller = new TextEditingController();
  var memberMobile_Controller = new MaskedTextController(mask: '000 0000 000');
  String selectCountryName = "";
  String selectStateName = "";
  String selectMembershipType = "";

//  TODO Focus NODE
  final FocusNode _memberSurName_Focus = FocusNode();
  final FocusNode _memberName_Focus = FocusNode();
  final FocusNode _memberMiddleName_Focus = FocusNode();
  final FocusNode _memberEmail_Focus = FocusNode();
  final FocusNode _memberMobile_Focus = FocusNode();
  final FocusNode _memberAddress_Focus = FocusNode();
  final FocusNode _memberCity_Focus = FocusNode();
  final FocusNode _memberState_Focus = FocusNode();
  final FocusNode _memberCountry_Focus = FocusNode();
  final FocusNode _memberDonation_Focus = FocusNode();

  String profilePicture = "";
  Uint8List bytesProfilePicture = null;
  String selectDocPath = "";
  String selectDocName = "";

  bool isChecked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getSharePref();
    print("nardeep");
  }

  getSharePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      login_status = prefs.getString("login_status");

      if (login_status != null ||
          login_status != "" ||
          login_status != "false") {
        login_userIsMember = prefs.getString("login_userisMember");
        login_userToken = prefs.getString("login_token");
        if (login_userIsMember != null || login_userIsMember != "false") {
          getMemberTypeAPI();
        }
      }
      print(login_status);
    });
  }

  Future getMemberTypeAPI() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      var response = await http.get(
        ConfigApi.MEMBER_TYPE_API,
        headers: {
          "content-type": "application/json",
          "Authorization": 'Bearer $login_userToken'
        },
      );
      print(response.body);
      Map responseList = jsonDecode(response.body);
      memberType_list = responseList['data'];
      print(memberType_list);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: Color(0XFFF6FAFC),
      resizeToAvoidBottomPadding: true,
      /*bottomNavigationBar: Container(
        height: 50.0,
        child: Container(
          child: RaisedButton(
            onPressed: () {},
            color: CustomColors.orageColor[87],
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                "SUBMIT",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ),*/
      body: Stack(
        children: <Widget>[
          login_status == "false" || login_status == null
              ? _loginWidget(context)
              : login_userIsMember == "true"
                  ? _memberDetailWidget(context)
                  : Container(
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("jss_logo_orange.png")),
                          backgroundBlendMode: BlendMode.darken,
                          color: Colors.grey[100]),
                      child: ScrollConfiguration(
                        behavior: ScrollBehavior(),
                        child: ListView(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10.0),
                              child: Column(
                                children: <Widget>[
                                  InkWell(
                                    onTap: () async {
                                      String path =
                                          await FilePicker.getFilePath(
                                              type: FileType.IMAGE);
//                              _documents = path;
                                      setState(() {
                                        String profilePicturePath = path;
                                        File profileFile =
                                            new File(profilePicturePath);
                                        String extension =
                                            p.extension(profilePicturePath);
                                        print("abcd ==>" + extension);
                                        List<int> imageBytes =
                                            profileFile.readAsBytesSync();
                                        print(imageBytes);
                                        if (extension == ".png") {
                                          profilePicture =
                                              "data:image/png;base64," +
                                                  base64Encode(imageBytes);
                                        } else if (extension == ".jpeg") {
                                          profilePicture =
                                              "data:image/jpeg;base64," +
                                                  base64Encode(imageBytes);
                                        } else if (extension == ".jpg") {
                                          profilePicture =
                                              "data:image/jpg;base64," +
                                                  base64Encode(imageBytes);
                                        }

                                        bytesProfilePicture = base64Decode(
                                            base64Encode(imageBytes));
                                      });
                                    },
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15.0)),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          boxShadow: [
                                            new BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 5.0)
                                          ],
                                          border: Border.all(
                                              color: Colors.white70,
                                              width: 2.0),
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: profilePicture == ""
                                                  ? AssetImage("gallery1.jpg")
                                                  : MemoryImage(
                                                      bytesProfilePicture),
                                              fit: BoxFit.cover)),
                                      height: 90,
                                      width: 90,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
                                      controller: memberSurName_Controller,
                                      textInputAction: TextInputAction.next,
                                      focusNode: _memberSurName_Focus,
                                      onSubmitted: (term) {
                                        _memberSurName_Focus.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(_memberName_Focus);
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
                                      controller: memberName_Controller,
                                      textInputAction: TextInputAction.next,
                                      focusNode: _memberName_Focus,
                                      onSubmitted: (term) {
                                        _memberName_Focus.unfocus();
                                        FocusScope.of(context).requestFocus(
                                            _memberMiddleName_Focus);
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
                                      controller: memberMiddleName_Controller,
                                      textInputAction: TextInputAction.next,
                                      focusNode: _memberMiddleName_Focus,
                                      onSubmitted: (term) {
                                        _memberMiddleName_Focus.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(_memberEmail_Focus);
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
                                    controller: memberEmail_Controller,
                                    textInputAction: TextInputAction.next,
                                    focusNode: _memberEmail_Focus,
                                    onSubmitted: (term) {
                                      _memberEmail_Focus.unfocus();
                                      FocusScope.of(context)
                                          .requestFocus(_memberMobile_Focus);
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
                                      controller: memberMobile_Controller,
                                      textInputAction: TextInputAction.next,
                                      focusNode: _memberMobile_Focus,
                                      onSubmitted: (term) {
                                        _memberMobile_Focus.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(_memberAddress_Focus);
                                      },
                                      onTap: () {
                                        setState(() {
                                          name = "mobile";
                                        });
                                      },
                                      keyboardType: TextInputType.phone,
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
                                        controller: memberDOB_Controller,
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
                                "Address".toUpperCase(),
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
                                elevation: name == "address" ? 3.0 : _ele,
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
                                      controller: memberAddress_Controller,
                                      textInputAction: TextInputAction.next,
                                      focusNode: _memberAddress_Focus,
                                      onSubmitted: (term) {
                                        _memberAddress_Focus.unfocus();
                                        FocusScope.of(context)
                                            .requestFocus(_memberCity_Focus);
                                      },
                                      onTap: () {
                                        setState(() {
                                          name = "address";
                                        });
                                      },
                                      keyboardType: TextInputType.text,
                                      style: TextStyle(
                                          fontFamily: "OpenSans",
                                          fontWeight: FontWeight.w700),
                                      decoration: InputDecoration.collapsed(
                                          hintText: "Enter Address",
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
                                      controller: memberCity_Controller,
                                      textInputAction: TextInputAction.next,
                                      focusNode: _memberCity_Focus,
                                      onSubmitted: (term) {
                                        _memberCity_Focus.unfocus();
                                        FocusScope.of(context).requestFocus(
                                            _memberDonation_Focus);
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
                                "Type of Membership".toUpperCase(),
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
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  height: 50.0,
                                  child: new DropdownButtonFormField<String>(
                                    decoration: InputDecoration(
                                        border: InputBorder.none),
                                    items: memberType_list.map((item) {
                                      return new DropdownMenuItem<String>(
                                        child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.6,
                                            child: new Text(
                                              item['name'].toString(),
                                              maxLines: 1,
                                            )),
                                        value: item['id'].toString(),
                                      );
                                    }).toList(),
                                    value: selectMembershipType == ""
                                        ? null
                                        : selectMembershipType,
                                    hint: Text(
                                      "Select Member Type",
                                      style: TextStyle(
                                          fontFamily: "OpenSans",
                                          fontWeight: FontWeight.w700),
                                    ),
                                    onChanged: (newVal) {
                                      setState(() {
                                        selectMembershipType =
                                            newVal.toString();
                                        for (int i = 0;
                                            i < memberType_list.length;
                                            i++) {
                                          if (memberType_list[i]['id']
                                                  .toString() ==
                                              selectMembershipType) {
                                            memberDonation_Controller.text =
                                                memberType_list[i]['amount'];
                                          }
                                        }
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 20, top: 15),
                              child: Text(
                                "Donate".toUpperCase(),
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
                                      enabled: false,
                                      controller: memberDonation_Controller,
                                      textInputAction: TextInputAction.done,
                                      focusNode: _memberDonation_Focus,
                                      onSubmitted: (term) {
                                        _memberDonation_Focus.unfocus();
//                          Call api
                                      },
                                      onTap: () {
                                        setState(() {
                                          name = "donate";
                                        });
                                      },
                                      keyboardType: TextInputType.number,
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
                              margin: EdgeInsets.only(left: 20, top: 15),
                              child: Text(
                                "Document".toUpperCase(),
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
                                elevation: name == "doc" ? 3.0 : _ele,
                                margin: EdgeInsets.only(top: 5),
                                child: InkWell(
                                  onTap: () async {
                                    File file = await FilePicker.getFile(
                                        type: FileType.CUSTOM,
                                        fileExtension: "pdf");

                                    setState(() {
                                      selectDocPath = file.path;
                                      selectDocName = basename(file.path);
                                      print("selectPath " + selectDocPath);
                                      print("select " + selectDocName);
                                    });
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 20.0),
                                    height: 70.0,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.white,
                                    ),
                                    alignment: Alignment.center,
                                    child: selectDocPath == "" &&
                                            selectDocName == ""
                                        ? Text(
                                            "Select Document",
                                            style: TextStyle(
                                                fontFamily: "OpenSans",
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w700),
                                          )
                                        : Text(
                                            selectDocName,
                                            style: TextStyle(
                                                fontFamily: "OpenSans",
                                                fontWeight: FontWeight.w700),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 20, top: 15, right: 20.0),
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.white54,
                                  border: Border.all(
                                      color: Colors.black12, width: 1.0)),
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
                                  top: 30.0,
                                  left: 20.0,
                                  right: 20.0,
                                  bottom: 30.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0))),
                              child:
                                  /*RevealProgressButton(),*/ new Row(
                                children: <Widget>[
                                  new Expanded(
                                      child: new Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.grey, width: 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0))),
                                    child: FlatButton(
                                        shape: new RoundedRectangleBorder(
                                            borderRadius:
                                                new BorderRadius.circular(
                                                    30.0)),
                                        splashColor: Colors.white30,
                                        color: CustomColors.buttonColor,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 15.0),
                                          child: Text(
                                            "Membership Donation",
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white),
                                          ),
                                        ),
                                        onPressed: () {
                                          print("Memeber SurName = " +
                                              memberSurName_Controller.text);
                                          print("Memeber Name = " +
                                              memberName_Controller.text);
                                          print("Memeber MiddleName = " +
                                              memberMiddleName_Controller.text);
                                          print("Memeber EMail = " +
                                              memberEmail_Controller.text);
                                          print("Memeber Mobile = " +
                                              memberMobile_Controller.text);
                                          print("Memeber DOB = " +
                                              memberDOB_Controller.text);
                                          print("Memeber Address = " +
                                              memberAddress_Controller.text);
                                          print("Memeber City = " +
                                              memberCity_Controller.text);
                                          print("Memeber State = " +
                                              selectStateName);
                                          print("Memeber Country = " +
                                              selectCountryName);
                                          print("Memeber Type = " +
                                              selectMembershipType);
                                          print("Memeber Donation = " +
                                              memberDonation_Controller.text);

                                          if (memberName_Controller.text ==
                                              "") {
                                            Fluttertoast.showToast(
                                                msg: "Enter valid name");
                                          } else if (memberMobile_Controller
                                                      .text ==
                                                  "" ||
                                              memberEmail_Controller.text ==
                                                  "") {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Enter valid email / mobile number");
                                          } else if (memberAddress_Controller
                                                  .text ==
                                              "") {
                                            Fluttertoast.showToast(
                                                msg: "Enter valid address");
                                          } else if (memberCity_Controller
                                                  .text ==
                                              "") {
                                            Fluttertoast.showToast(
                                                msg: "Enter valid city");
                                          } else if (selectCountryName == "") {
                                            Fluttertoast.showToast(
                                                msg: "Select country");
                                          } else if (selectStateName == "") {
                                            Fluttertoast.showToast(
                                                msg: "Select state");
                                          } else if (selectMembershipType ==
                                              "") {
                                            Fluttertoast.showToast(
                                                msg: "Select member type");
                                          } else {
//                                            sendMemberApi();
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

  Widget _loginWidget(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CircleAvatar(
            backgroundImage: AssetImage("gallery1.jpg"),
            radius: 60.0,
          ),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.1),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(
                    "You are not login?",
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Quicksand",
                        color: Colors.black87),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    "Click login button",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Quicksand",
                        color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
          Card(
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
                          "Click to Login",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Act_Login()))
                            .then((value) {
                          setState(() {
                            getSharePref();
                          });
                        });
                      }),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _memberDetailWidget(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: CustomColors.backgroundColor,
      child: ListView(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                border: Border.all(color: Colors.grey.withOpacity(0.5))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Hello Bittu Patel,",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Membership : ",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w600,
                              color: Colors.black54)),
                      Text("Silver",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w600,
                              color: CustomColors.orageColor)),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                border: Border.all(color: Colors.grey.withOpacity(0.5))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Text(
                    "Your Benifits",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      child: ListTile(
                        leading: Container(
                          height: 60.0,
                          width: 80.0,
                          child: ImageIcon(
                            NetworkImage(
                                "https://img.icons8.com/color/2x/video-call.png"),
                            color: Colors.green,
                          ),
                        ),
                        title: Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 5.0),
                          child: Text(
                            "Video",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                        subtitle: Text(
                          "Unlimited One-Day and Two-Day delivery from india's largest online store",
                          style: TextStyle(
                              fontSize: 13.0,
                              fontFamily: "Opensans",
                              color: Colors.black),
                        ),
                      ),
                    ),
                    Container(
                      child: ListTile(
                        leading: Container(
                          height: 60.0,
                          width: 80.0,
                          child: ImageIcon(
                            NetworkImage(
                                "https://img.icons8.com/cotton/2x/headphones.png"),
                            color: Colors.orange,
                          ),
                        ),
                        title: Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 5.0),
                          child: Text(
                            "Music",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                        subtitle: Text(
                          "Unlimited One-Day and Two-Day delivery from india's largest online store",
                          style: TextStyle(
                              fontSize: 13.0,
                              fontFamily: "Opensans",
                              color: Colors.black),
                        ),
                      ),
                    ),
                    Container(
                      child: ListTile(
                        leading: Container(
                          height: 60.0,
                          width: 80.0,
                          child: ImageIcon(
                            NetworkImage(
                                "https://img.icons8.com/ios/2x/stack-of-photos-filled.png"),
                            color: Colors.pink,
                          ),
                        ),
                        title: Padding(
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 5.0),
                          child: Text(
                            "Gallery",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                        subtitle: Text(
                          "Unlimited One-Day and Two-Day delivery from india's largest online store",
                          style: TextStyle(
                              fontSize: 13.0,
                              fontFamily: "Opensans",
                              color: Colors.black),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                border: Border.all(color: Colors.grey.withOpacity(0.5))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Membership Info",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Payment Option",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "QuickSand",
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 2.0),
                  child: Text(
                    "Yearly (₹700/year)",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Opensans",
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: Text(
                    "Renewal and Next Payment",
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: "QuickSand",
                        fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 2.0),
                  child: Text(
                    "Your membership will expire on May 16, 2020.",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Opensans",
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 2.0),
                  child: Text(
                    "You will be informed via email or SMS and can renew only after expiry.",
                    style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Opensans",
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Enable Auto-renew",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "QuickSand",
                            fontWeight: FontWeight.w600),
                      ),
                      Switch(
                        value: false,
                        onChanged: (value) {
                          setState(() {});
                        },
                        activeTrackColor: CustomColors.orageColor,
                        inactiveTrackColor: Colors.grey,
                        activeColor: Colors.white,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                border: Border.all(color: Colors.grey.withOpacity(0.5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 10.0),
                      child: Text(
                        "Payment History ",
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: "QuickSand",
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 2.0, bottom: 10.0),
                      child: Text(
                        "Last Payment: May 16,2019",
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Opensans",
                            fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                border: Border.all(color: Colors.grey.withOpacity(0.5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Cancel Membership",
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: "QuickSand",
                      fontWeight: FontWeight.w600),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
                border: Border.all(color: Colors.grey.withOpacity(0.5))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "Terms & Conditions",
                  style: TextStyle(
                      fontSize: 16,
                      fontFamily: "QuickSand",
                      fontWeight: FontWeight.w600),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                )
              ],
            ),
          ),
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
        memberDOB_Controller.text = formatter.format(initialDate).toString();
        print(formatter.format(initialDate));
      });
  }

  sendMemberApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    var body = jsonEncode({
      "name": memberName_Controller.text,
      "email": memberEmail_Controller.text,
      "mobile": memberMobile_Controller.text,
      "address": memberAddress_Controller.text,
      "city": memberCity_Controller.text,
      "country": selectCountryName,
      "state": selectStateName,
      "type": selectMembershipType,
    });

    print(body);
    try {
      var response = await http.post(ConfigApi.MEMBER_API,
          body: body,
          headers: {
            "content-type": "application/json",
            "Authorization": 'Bearer $login_userToken'
          });
      print(response.body);
      Map responseMap = jsonDecode(response.body);
      print(responseMap);
      if (responseMap['success'] == true) {
        Fluttertoast.showToast(msg: "Successfully created member");
        setState(() {
          prefs.setString("login_userisMember", "true");
          memberName_Controller.text = "";
          memberEmail_Controller.text = "";
          memberMobile_Controller.text = "";
          memberAddress_Controller.text = "";
          memberCity_Controller.text = "";
          selectCountryName = "";
          selectStateName = "";
          selectMembershipType = "";
        });
      } else {
        Fluttertoast.showToast(msg: "member not created. try again");
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
