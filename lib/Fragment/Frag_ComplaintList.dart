import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jss/Activity/Act_login.dart';
import 'package:jss/Fragment/Frag_Complaint.dart';
import 'package:jss/utils/ConfigApi.dart';
import 'package:jss/utils/CustomThemeData.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Frag_ComplaintList extends StatefulWidget {
  @override
  _Frag_ComplaintListState createState() => _Frag_ComplaintListState();
}

class _Frag_ComplaintListState extends State<Frag_ComplaintList> {
  String login_status = "false", login_userEmail = "";
  String login_userToken = "";
  bool isLoading = false;
  bool isPageLoading = false;
  List<dynamic> complainList = new List();

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
          getComplainApi(pageNumber);
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
          getComplainApi(1);
        }
      }

      print(login_status);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future getComplainApi(int currentPageNumber) async {
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
        ConfigApi.COMPLAIN_API + "?page=$currentPageNumber",
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
        complainList.add(responseList[i]);
      }
      print(complainList);
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
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Frag_Complaint(null, "Add")))
                    .then((value) {
                  if (value) {
                    complainList.clear();
                    getSharePref();
                  }
                });
              },
              child: Icon(Icons.add),
              backgroundColor: CustomColors.floating_button,
            ),
      body: Stack(
        children: <Widget>[
          login_status == "false" || login_status == null
              ? _loginWidget(context)
              : ListView.builder(
                  itemCount: complainList.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    return complainList.length <= index
                        ? isPageLoading
                            ? _buildProgressIndicator()
                            : Container(
                                height: 100,
                              )
                        : Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.5),
                                    width: 1.0)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(left: 10, right: 10),
                                  child: Text(
                                    complainList[index]['complaint'] == null
                                        ? " - "
                                        : complainList[index]['complaint'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w700,
                                        fontFamily: "Quicksand"),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 12, top: 5, right: 10),
                                  child: Text(
                                    complainList[index]['complaint'] == null
                                        ? " - "
                                        : complainList[index]['complaint'],
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                        fontFamily: "Opensans"),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 12, top: 15, right: 10),
                                  child: Text(
                                    complainList[index]['created_at'] == null
                                        ? " - "
                                        : "${DateFormat("dd MMM, hh:mm a").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(complainList[index]['created_at']))}",
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 12.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                        fontFamily: "Opensans"),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      left: 12, top: 3, right: 10),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: Row(
                                          children: <Widget>[
                                            Container(
                                              height: 30.0,
                                              width: 30.0,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: DecorationImage(
                                                      image: AssetImage(
                                                          "gallery1.jpg"),
                                                      fit: BoxFit.fill)),
                                            ),
                                            Expanded(
                                              child: Container(
                                                margin:
                                                    EdgeInsets.only(left: 5.0),
                                                child: Text(
                                                  "${complainList[index]['fname'] == null ? "" : complainList[index]['fname']}" +
                                                      " ${complainList[index]['mname'] == null ? "" : complainList[index]['mname']}" +
                                                      " ${complainList[index]['lname'] == null ? "" : complainList[index]['lname']}",
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black54,
                                                      fontFamily: "Opensans"),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: <Widget>[
                                            InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Frag_Complaint(
                                                                complainList[
                                                                    index],
                                                                "Edit"))).then(
                                                    (value) {
                                                  if (value) {
                                                    complainList.clear();
                                                    getSharePref();
                                                  }
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15.0,
                                                    vertical: 3.0),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: Colors.blue),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15.0))),
                                                child: Text(
                                                  "Edit",
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.black54,
                                                      fontFamily: "QuickSand"),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                showDialog(
                                                    barrierDismissible: true,
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return dialogue_Delete(
                                                          context, index);
                                                    });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 15.0,
                                                    vertical: 3.0),
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color: CustomColors
                                                            .orageColor),
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15.0))),
                                                child: Text(
                                                  "Delete",
                                                  style: TextStyle(
                                                      fontSize: 15.0,
                                                      color: Colors.black54,
                                                      fontFamily: "QuickSand"),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                  },
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

  Widget dialogue_Delete(BuildContext context, int index) {
    return StatefulBuilder(
      builder: (context, state) {
        return Center(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width * 0.85,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5.0),
                          topLeft: Radius.circular(5.0),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.warning,
                            color: Color(0XFFF15757),
                            size: 60,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Do you want to delete?",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          FlatButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            splashColor: Colors.white30,
                            color: Color(0XFFF15757),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              deleteApi(index, context).then((value) {
                                if (value) {
                                  complainList.clear();
                                  getSharePref();
                                }
                              });
                            },
                          ),
                          FlatButton(
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0)),
                            splashColor: Colors.white30,
                            color: Colors.grey,
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              child: Text(
                                "No",
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future deleteApi(int index, BuildContext context1) async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    try {
      var response = await http.delete(
        ConfigApi.COMPLAIN_API + "/${complainList[index]['id']}",
        headers: {
          "content-type": "application/json",
          "Authorization": 'Bearer $login_userToken'
        },
      );
      print(response.body);

      if (response.body != "") {
        Map delResponse = jsonDecode(response.body);
        print(delResponse);

        if (delResponse['success'] == true) {
          Fluttertoast.showToast(msg: delResponse['message']);
          return true;
        } else {
          Fluttertoast.showToast(msg: delResponse['message']);
          return false;
        }
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
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
}
