import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jss/Activity/Act_Donation.dart';
import 'package:jss/Activity/Act_login.dart';
import 'package:jss/utils/ConfigApi.dart';
import 'package:jss/utils/CustomThemeData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Frag_DonationList extends StatefulWidget {
  @override
  _Frag_DonationListState createState() => _Frag_DonationListState();
}

class _Frag_DonationListState extends State<Frag_DonationList> {
  String login_status = "false", login_userEmail = "";
  String login_userToken = "";
  bool isLoading = false;
  bool isPageLoading = false;
  List<dynamic> donationList = new List();

  ScrollController _scrollController = new ScrollController();

  String nextPage = "";
  int pageNumber = 1;
  int lastPageNumber = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSharePref();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (pageNumber <= lastPageNumber) {
          print("next === " + pageNumber.toString());
          getDonationApi(pageNumber);
        }
      }
    });
  }

  getSharePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      login_status = prefs.getString("login_status");

      if (login_status != null ||
          login_status != "" ||
          login_status != "false") {
        if (login_status != "false") {
          login_userEmail = prefs.getString("login_userEmail");
          login_userToken = prefs.getString("login_token");
          getDonationApi(1);
          print(login_status);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future getDonationApi(int currentPageNumber) async {
    if (currentPageNumber == 1 && !isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    if (currentPageNumber != 1 && !isPageLoading) {
      setState(() {
        isPageLoading = true;
      });
    }

    try {
      var response = await http.get(
        ConfigApi.DONATION_API +
            "/user/" +
            login_userEmail +
            "?page=$currentPageNumber",
        headers: {
          "content-type": "application/json",
          "Authorization": 'Bearer $login_userToken'
        },
      );
      print(response.body);
      Map responseMap = jsonDecode(response.body);
      setState(() {
        pageNumber = pageNumber + 1;
        lastPageNumber = responseMap['last_page'];
      });
      List<dynamic> responseList = responseMap['data'];
      for (int i = 0; i < responseList.length; i++) {
        donationList.add(responseList[i]);
      }
      print(donationList);
      setState(() {
        isLoading = false;
      });
      if (isPageLoading) {
        setState(() {
          isPageLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      if (isPageLoading) {
        setState(() {
          isPageLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      floatingActionButton: login_status == "false" || login_status == null
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.of(context)
                    .push(
                        MaterialPageRoute(builder: (context) => Act_Donation()))
                    .then((value) {
                  if (value == true) {
                    getDonationApi(1);
                  }
                });
              },
              backgroundColor: CustomColors.floating_button,
              child: Icon(Icons.add),
            ),
      body: Stack(
        children: <Widget>[
          login_status == "false" || login_status == null
              ? _loginWidget(context)
              : Container(
                  child: donationList.length <= 0
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.5),
                                        width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                child: Text(
                                  "No Donation",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            )
                          ],
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          itemCount: donationList.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            return donationList.length <= index
                                ? isPageLoading
                                    ? _buildProgressIndicator()
                                    : Container(
                                        height: 100,
                                      )
                                : Card(
                                    elevation: 5.0,
                                    margin: EdgeInsets.only(
                                        top: 10.0, left: 15.0, right: 15.0),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0))),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.23,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5.0))),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            flex: 2,
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              padding:
                                                  EdgeInsets.only(left: 5.0),
                                              decoration: BoxDecoration(
                                                color: Colors.grey
                                                    .withOpacity(0.1),
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(5.0),
                                                  bottomLeft:
                                                      Radius.circular(5.0),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10.0,
                                                            left: 5.0),
                                                        child: Text(
                                                          "Name",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  "Quicksand",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 1.0,
                                                            left: 5.0,
                                                            right: 5.0),
                                                        child: Text(
                                                          "${donationList[index]['fname'] == null ? "" : donationList[index]['fname']}" +
                                                              " ${donationList[index]['mname'] == null ? "" : donationList[index]['mname']}" +
                                                              "${donationList[index]['lname'] == null ? "" : donationList[index]['lname']}",
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  "OpenSans",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 10.0,
                                                            left: 5.0),
                                                        child: Text(
                                                          "Donation Amount",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .black54,
                                                              fontSize: 12,
                                                              fontFamily:
                                                                  "Quicksand",
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                        ),
                                                      ),
                                                      Container(
                                                        margin: EdgeInsets.only(
                                                            top: 1.0,
                                                            left: 5.0,
                                                            right: 20.0),
                                                        child: Text(
                                                          "₹ ${donationList[index]['amount'] == null ? 0 : donationList[index]['amount']}",
                                                          style: TextStyle(
                                                              fontSize: 18.0,
                                                              color: Colors
                                                                  .black87,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontFamily:
                                                                  "Opensans"),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Container(
                                              height: MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              decoration: BoxDecoration(
                                                color: Colors.blue,
                                                borderRadius: BorderRadius.only(
                                                  topRight:
                                                      Radius.circular(5.0),
                                                  bottomRight:
                                                      Radius.circular(5.0),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: <Widget>[
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                        left: 15.0),
                                                    child: Text(
                                                      donationList[index][
                                                                  'category'] ==
                                                              null
                                                          ? " - "
                                                          : donationList[index][
                                                                          'category']
                                                                      [
                                                                      'name'] ==
                                                                  null
                                                              ? " - "
                                                              : donationList[index]
                                                                          [
                                                                          'category']
                                                                      ['name']
                                                                  .toString(),
                                                      style: TextStyle(
                                                          fontSize: 17.0,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily:
                                                              "Quicksand"),
                                                    ),
                                                  ),
                                                  Container(
                                                      margin: EdgeInsets.only(
                                                          left: 15.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Container(
                                                            margin:
                                                                EdgeInsets.only(
                                                                    bottom:
                                                                        2.0),
                                                            child: Text(
                                                              "Donation Date",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Colors
                                                                      .white70,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontFamily:
                                                                      "Quicksand"),
                                                            ),
                                                          ),
                                                          Row(
                                                            children: <Widget>[
                                                              Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5.0)),
                                                                  color: Colors
                                                                      .white54,
                                                                ),
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10.0,
                                                                        vertical:
                                                                            5.0),
                                                                child: Text(
                                                                  donationList[index]
                                                                              [
                                                                              'created_at'] ==
                                                                          null
                                                                      ? " - "
                                                                      : "${DateFormat("dd").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(donationList[index]['created_at']))}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                      color: Colors
                                                                          .black54,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontFamily:
                                                                          "Quicksand"),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            5.0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5.0)),
                                                                  color: Colors
                                                                      .white54,
                                                                ),
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10.0,
                                                                        vertical:
                                                                            5.0),
                                                                child: Text(
                                                                  donationList[index]
                                                                              [
                                                                              'created_at'] ==
                                                                          null
                                                                      ? " - "
                                                                      : "${DateFormat("MM").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(donationList[index]['created_at']))}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                      color: Colors
                                                                          .black54,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontFamily:
                                                                          "Quicksand"),
                                                                ),
                                                              ),
                                                              Container(
                                                                margin: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            5.0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              5.0)),
                                                                  color: Colors
                                                                      .white54,
                                                                ),
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            10.0,
                                                                        vertical:
                                                                            5.0),
                                                                child: Text(
                                                                  donationList[index]
                                                                              [
                                                                              'created_at'] ==
                                                                          null
                                                                      ? " - "
                                                                      : "${DateFormat("yyyy").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(donationList[index]['created_at']))}",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14.0,
                                                                      color: Colors
                                                                          .black54,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontFamily:
                                                                          "Quicksand"),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      )),
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                      left: 15.0,
                                                    ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Container(
                                                          margin:
                                                              EdgeInsets.only(
                                                                  bottom: 0.0),
                                                          child: Text(
                                                            "Payment ID",
                                                            style: TextStyle(
                                                                fontSize: 14.0,
                                                                color: Colors
                                                                    .white70,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontFamily:
                                                                    "Quicksand"),
                                                          ),
                                                        ),
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: <Widget>[
                                                            Text(
                                                              "124577844545",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      14.0,
                                                                  color: Colors
                                                                      .white70,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontFamily:
                                                                      "Quicksand"),
                                                            ),
                                                            InkWell(
                                                              onTap: () {
                                                                Clipboard.setData(
                                                                    new ClipboardData(
                                                                        text:
                                                                            "Copy"));
                                                                Fluttertoast
                                                                    .showToast(
                                                                        msg:
                                                                            "Payment Id : 124577844545 copied");
                                                              },
                                                              onLongPress:
                                                                  () {},
                                                              child: Container(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            15.0,
                                                                        vertical:
                                                                            3.0),
                                                                child: Icon(
                                                                  Icons
                                                                      .content_copy,
                                                                  color: Colors
                                                                      .white70,
                                                                  size: 14,
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                            /*Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  top: 10.0, left: 10.0, right: 10.0),
                              padding: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.5),
                                      width: 1.0)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "RamRoti",
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Quicksand"),
                                      ),
                                      Text(
                                        "12/12/2012",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600,
                                            fontFamily: "Quicksand"),
                                      )
                                    ],
                                  ),
                                  Column(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.only(top: 15.0),
                                        child: Text(
                                          "Donate Amount :",
                                          style: TextStyle(
                                              fontSize: 14.0,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: "Quicksand"),
                                        ),
                                      ),
                                      Text(
                                        "₹ 120",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Opensans"),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),

                          ],
                        );*/
                          }),
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

  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isPageLoading ? 1.0 : 00,
          child: new CircularProgressIndicator(
              valueColor:
                  new AlwaysStoppedAnimation<Color>(CustomColors.progressBar)),
        ),
      ),
    );
  }
}
