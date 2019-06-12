import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jss/Activity/Act_login.dart';
import 'package:jss/utils/ConfigApi.dart';
import 'package:jss/utils/CustomThemeData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_plugin/razorpay_plugin.dart';

class Act_Donation extends StatefulWidget {
  @override
  _Act_DonationState createState() => _Act_DonationState();
}

class _Act_DonationState extends State<Act_Donation> {
  String name = "";
  double _ele = 0.5;

  TextEditingController donationSurName_Controller =
      new TextEditingController();
  TextEditingController donationName_Controller = new TextEditingController();
  TextEditingController donationMiddleName_Controller =
      new TextEditingController();
  TextEditingController donationEmail_Controller = new TextEditingController();
  TextEditingController donationAddress_Controller =
      new TextEditingController();
  TextEditingController donationCity_Controller = new TextEditingController();
  TextEditingController donationState_Controller = new TextEditingController();
  TextEditingController donationAmount_Controller = new TextEditingController();
  var donationMobile_Controller =
      new MaskedTextController(mask: '000 0000 000');
  TextEditingController donationDOB_Controller = new TextEditingController();
  String selectCountryName = "";
  String selectDonatingFor = "";

//  TODO Focus NODE
  final FocusNode _donationSurName_Focus = FocusNode();
  final FocusNode _donationName_Focus = FocusNode();
  final FocusNode _donationMiddleName_Focus = FocusNode();
  final FocusNode _donationEmail_Focus = FocusNode();
  final FocusNode _donationMobile_Focus = FocusNode();
  final FocusNode _donationAddress_Focus = FocusNode();
  final FocusNode _donationCity_Focus = FocusNode();
  final FocusNode _donationState_Focus = FocusNode();
  final FocusNode _donationAmount_Focus = FocusNode();

  String login_status = "false";
  bool isLoading = false;
  String login_userToken = "";
  List<dynamic> campaign_list = new List();
  String selectDonationCampaign = "";

  DateTime selectedDate = DateTime.now();
  DateTime initialDate = DateTime(1990, 1);
  var formatter = new DateFormat('dd-MM-yyyy');
  bool isChecked = false;

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
      login_userToken = prefs.getString("login_token");
      donationEmail_Controller.text = prefs.getString("login_userEmail");

      if (login_status != null &&
          login_status != "" &&
          login_status != "false") {
        getCampaign();
      }
      print(login_status);
    });
  }

  Future getCampaign() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      var response = await http.get(
        ConfigApi.DONATION_CATEGORY_API,
        headers: {
          "content-type": "application/json",
          "Authorization": 'Bearer $login_userToken'
        },
      );
      print(response.body);
      campaign_list = jsonDecode(response.body);
      print(campaign_list);
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
      appBar: AppBar(
        title: Text("Donation"),
        elevation: 1.0,
        backgroundColor: CustomColors.orageColor,
      ),
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
                            controller: donationSurName_Controller,
                            textInputAction: TextInputAction.next,
                            focusNode: _donationSurName_Focus,
                            onSubmitted: (term) {
                              _donationSurName_Focus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_donationName_Focus);
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
                            controller: donationName_Controller,
                            textInputAction: TextInputAction.next,
                            focusNode: _donationName_Focus,
                            onSubmitted: (term) {
                              _donationName_Focus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_donationEmail_Focus);
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
                            controller: donationMiddleName_Controller,
                            textInputAction: TextInputAction.next,
                            focusNode: _donationMiddleName_Focus,
                            onSubmitted: (term) {
                              _donationMiddleName_Focus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_donationEmail_Focus);
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
                          controller: donationEmail_Controller,
                          textInputAction: TextInputAction.next,
                          enabled: false,
                          focusNode: _donationEmail_Focus,
                          onSubmitted: (term) {
                            _donationEmail_Focus.unfocus();
                            FocusScope.of(context)
                                .requestFocus(_donationMobile_Focus);
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
                            controller: donationMobile_Controller,
                            textInputAction: TextInputAction.next,
                            focusNode: _donationMobile_Focus,
                            onSubmitted: (term) {
                              _donationMobile_Focus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_donationAddress_Focus);
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
                              controller: donationDOB_Controller,
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
                            controller: donationAddress_Controller,
                            textInputAction: TextInputAction.next,
                            focusNode: _donationAddress_Focus,
                            onSubmitted: (term) {
                              _donationAddress_Focus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_donationCity_Focus);
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
                            controller: donationCity_Controller,
                            textInputAction: TextInputAction.next,
                            focusNode: _donationCity_Focus,
                            onSubmitted: (term) {
                              _donationCity_Focus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_donationState_Focus);
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.black12)),
                      elevation: name == "state" ? 3.0 : _ele,
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
                            controller: donationState_Controller,
                            textInputAction: TextInputAction.next,
                            focusNode: _donationState_Focus,
                            onSubmitted: (term) {
                              _donationState_Focus.unfocus();
                              FocusScope.of(context)
                                  .requestFocus(_donationAmount_Focus);
                            },
                            onTap: () {
                              setState(() {
                                name = "state";
                              });
                            },
                            keyboardType: TextInputType.text,
                            style: TextStyle(
                                fontFamily: "OpenSans",
                                fontWeight: FontWeight.w700),
                            decoration: InputDecoration.collapsed(
                                hintText: "Enter State",
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
                      "Donating For".toUpperCase(),
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
                          decoration: InputDecoration(border: InputBorder.none),
                          items: campaign_list.map((item) {
                            return new DropdownMenuItem<String>(
                              child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: new Text(
                                    item['name'].toString(),
                                    maxLines: 1,
                                  )),
                              value: item['id'].toString(),
                            );
                          }).toList(),
                          value: selectDonationCampaign == ""
                              ? null
                              : selectDonationCampaign,
                          hint: Text(
                            "Select Donation Campaign",
                            style: TextStyle(
                                fontFamily: "OpenSans",
                                fontWeight: FontWeight.w700),
                          ),
                          onChanged: (newVal) {
                            setState(() {
                              selectDonationCampaign = newVal.toString();
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
                            controller: donationAmount_Controller,
                            textInputAction: TextInputAction.done,
                            focusNode: _donationAmount_Focus,
                            onSubmitted: (term) {
                              _donationAmount_Focus.unfocus();
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
                                if (donationName_Controller.text == "") {
                                  Fluttertoast.showToast(
                                      msg: "Enter valid name");
                                } else if (donationEmail_Controller.text ==
                                    "") {
                                  Fluttertoast.showToast(
                                      msg: "Enter valid email");
                                } else if (donationMobile_Controller.text ==
                                    "") {
                                  Fluttertoast.showToast(
                                      msg: "Enter valid mobile");
                                } else if (selectDonationCampaign == "") {
                                  Fluttertoast.showToast(
                                      msg: "Select donation campaign");
                                } else if (donationAmount_Controller.text ==
                                    "") {
                                  Fluttertoast.showToast(
                                      msg: "Select valid donation amount");
                                } else {
                                  print("Memeber Name = " +
                                      donationName_Controller.text);
                                  print("Memeber EMail = " +
                                      donationEmail_Controller.text);
                                  print("Memeber Mobile = " +
                                      donationMobile_Controller.text);
                                  print("Memeber Address = " +
                                      donationAddress_Controller.text);
                                  print("Memeber City = " +
                                      donationCity_Controller.text);
                                  print("Memeber State = " +
                                      donationState_Controller.text);
                                  print(
                                      "Memeber Country = " + selectCountryName);
                                  print("Memeber Donation Campaign = " +
                                      selectDonationCampaign);
                                  print("Memeber Donation = " +
                                      donationAmount_Controller.text);
                                  sendPaymentProccess();
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

  Future sendPaymentProccess() async {
    Map<String, dynamic> options = new Map();
    options.putIfAbsent("name", () => "Donation");
    options.putIfAbsent(
        "image", () => "https://www.73lines.com/web/image/12427");
    options.putIfAbsent("description", () => "This is a real transaction");
    options.putIfAbsent("amount",
        () => (int.parse(donationAmount_Controller.text) * 100).toString());
    options.putIfAbsent("email", () => donationEmail_Controller.text);
    options.putIfAbsent("contact", () => donationMobile_Controller.text);
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

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(1900, 1),
        lastDate: selectedDate);
    if (picked != null && picked != selectedDate)
      setState(() {
        initialDate = picked;
        donationDOB_Controller.text = formatter.format(initialDate).toString();
        print(formatter.format(initialDate));
      });
  }

  Future sendDonationApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    var body = jsonEncode({
      "fname": donationSurName_Controller.text,
      "mname": donationName_Controller.text,
      "lname": donationMiddleName_Controller.text,
      "email": donationEmail_Controller.text,
      "mobile": donationMobile_Controller.text,
      "dob": donationDOB_Controller.text,
      "address": donationAddress_Controller.text,
      "city": donationCity_Controller.text,
      "country": selectCountryName,
      "state": donationState_Controller.text,
      "category": selectDonationCampaign,
      "amount": donationAmount_Controller.text,
    });

    print(body);
    try {
      var response = await http.post(ConfigApi.DONATION_API,
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
          donationName_Controller.text = "";
          donationEmail_Controller.text = "";
          donationMobile_Controller.text = "";
          donationAddress_Controller.text = "";
          donationCity_Controller.text = "";
          selectCountryName = "";
          donationState_Controller.text = "";
          selectDonationCampaign = "";
          donationAmount_Controller.text = "";
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
