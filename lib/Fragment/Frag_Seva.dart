import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jss/Activity/Act_Seva.dart';
import 'package:jss/Activity/Act_SevaDetails.dart';
import 'package:jss/Fragment/Frag_Complaint.dart';
import 'package:jss/utils/ConfigApi.dart';
import 'package:jss/utils/CustomThemeData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Frag_Seva extends StatefulWidget {
  @override
  _Frag_SevaState createState() => _Frag_SevaState();
}

class _Frag_SevaState extends State<Frag_Seva> {
  String login_status = "false", login_userEmail = "";
  String login_userToken = "";
  bool isLoading = false;
  bool isPageLoading = false;
  List<dynamic> sevaList = new List();

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
          getSevaApi(pageNumber);
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
        login_userEmail = prefs.getString("login_userEmail");
        login_userToken = prefs.getString("login_token");
      }

      print(login_status);
    });
    getSevaApi(1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future getSevaApi(int currentPageNumber) async {
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
        ConfigApi.SEVA_CATEGORY_API + "?page=$currentPageNumber",
        headers: {
          "content-type": "application/json",
          "Authorization": 'Bearer $login_userToken'
        },
      );
      print("AAA=> ${response.body}");
      Map responseMap = jsonDecode(response.body);
      setState(() {
        pageNumber = pageNumber + 1;
        lastPageNumber = responseMap['last_page'];
      });
      List<dynamic> responseList = responseMap['data'];
      for (int i = 0; i < responseList.length; i++) {
        sevaList.add(responseList[i]);
      }
      print("BC ==> $sevaList");
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
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: sevaList.length + 1,
            itemBuilder: (BuildContext context, int index) {
              return sevaList.length - 1 < index
                  ? Container(
                      height: 100,
                    )
                  : InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Act_SevaDetails(sevaList[index])));
                      },
                      child: Card(
                        margin: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.height * 0.018,
                            vertical: 10.0),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.0))),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
//                        shape: RoundedRectangleBorder(
//                            borderRadius:
//                                BorderRadius.all(Radius.circular(7.0))),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.28,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage("gallery2.jpg"),
                                          colorFilter: ColorFilter.mode(
                                              Colors.black54, BlendMode.darken),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(7.0),
                                          topLeft: Radius.circular(7.0))),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(
                                    horizontal: 5.0, vertical: 5.0),
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(sevaList[index]['title'] == null ? "" : sevaList[index]['title'],
                                            maxLines: 1,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontFamily: "Quicksand",
                                                color: Colors.black87),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 5.0, top: 2.0),
                                          child: Text(sevaList[index]['created_at'] == null ? " - " : "${DateFormat("dd MMM, yyyy").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(sevaList[index]['created_at']))}",
                                            style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black54),
                                          ),
                                        )
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 3.0,
                                          right: 2.0,
                                          top: 5.0,
                                          bottom: 3.0),
                                      child: Text(sevaList[index]['description'] == null ? " - " : sevaList[index]['description'],
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Quicksand",
                                            color: Colors.black45),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
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
}
