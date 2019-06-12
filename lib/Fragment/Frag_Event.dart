import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jss/Activity/Act_EventDetail.dart';
import 'package:jss/Activity/Act_login.dart';
import 'package:jss/utils/ConfigApi.dart';
import 'package:jss/utils/CustomThemeData.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';

class Frag_Event extends StatefulWidget {
  @override
  _Frag_EventState createState() => _Frag_EventState();
}

class Event_Model {
  String eventId;
  String eventTitle;
  String eventDate;
  String interestedCounter;
  String goingCounter;
  String eventVenue;
  String eventDesc;
  List<dynamic> eventUrl;
  String isGoing;
  String isInterested;

  Event_Model(
      this.eventId,
      this.eventTitle,
      this.eventUrl,
      this.eventVenue,
      this.eventDesc,
      this.eventDate,
      this.interestedCounter,
      this.goingCounter,
      this.isInterested,
      this.isGoing);
}

class _Frag_EventState extends State<Frag_Event> with TickerProviderStateMixin {
  String login_status = "false", login_userEmail = "", login_userID = "";
  String login_userToken = "";
  bool isLoading = false;
  bool isPageLoading = false;

  List<Event_Model> eventList = new List();
  List<dynamic> eventMedia = new List();
  List<dynamic> tempInterested = new List();

  int currentPage = 1;
  int pageNumber = 1;
  int lastPageNumber = 1;

  ScrollController _scrollController = new ScrollController();

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
          getEventApi(pageNumber);
        }
      }
    });
  }

  getSharePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      login_status = prefs.getString("login_status");

      if (login_status != null || login_status != "" || login_status != "false") {
        login_userID = prefs.getString("login_userId");
        login_userEmail = prefs.getString("login_userEmail");
        login_userToken = prefs.getString("login_token");
      }
      getEventApi(1);
      print(login_status.toString() + " " + login_userID.toString());
    });
  }

  Future getEventApi(int currentPageNumber) async {
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
      if(login_status != null || login_status != "" || login_status != "false"){
        print("not login");
      }else{
        print("login");
      }

      var response = login_status != "true" ? await http.get(
        ConfigApi.EVENTS_API + "?page=$currentPageNumber",
        headers: {
          "content-type": "application/json",
          "Authorization": 'Bearer $login_userToken'
        },
      ) : await http.get(
        ConfigApi.EVENTS_USER_API + "/user/$login_userID?page=$currentPageNumber",
        headers: {
          "content-type": "application/json",
          "Authorization": 'Bearer $login_userToken'
        },
      );
      print(response.body);
      tempInterested.clear();
      eventList.clear();
      Map responseMap = jsonDecode(response.body);
      setState(() {
        pageNumber = pageNumber + 1;
        currentPage = responseMap['current_page'];
        lastPageNumber = responseMap['last_page'];
      });
      List<dynamic> responseList = responseMap['data'];
      for (int i = 0; i < responseList.length; i++) {
        String eventId = responseList[i]['id'].toString();
        String eventTitle =
            responseList[i]['title'] == null ? " - " : responseList[i]['title'];
        List<dynamic> eventURL = responseList[i]['media'].toString() == '[]'
            ? null
            : responseList[i]['media'];
        String eventDate = responseList[i]['event_date'] == null
            ? " - "
            : responseList[i]['event_date'];
        String eventVenue =
            responseList[i]['venue'] == null ? " - " : responseList[i]['venue'];
        String eventDesc = responseList[i]['description'] == null
            ? " - "
            : responseList[i]['description'];
        String interestedCounter = responseList[i]['interested'].toString();
        String goingCounter = responseList[i]['going'].toString();
        String isInterested ;
        String isGoing;

        print(responseList[i]);

        tempInterested = responseList[i]['counter'];
        /*if (tempInterested.toString() != "[]") {
          for (int i = 0; i < tempInterested.length; i++) {
            print(tempInterested[i]["interested"]);
            if (tempInterested[i]["interested"].toString() == "1") {
              setState(() {
                isInterested = true;
              });
            }
            if (tempInterested[i]["going"].toString() == "1") {
              setState(() {
                isInterested = true;
              });
            }
          }
        }*/
        
        if(login_status == "true"){
          print("isInterested == "+responseList[i]['isInterested'].toString());
          setState(() {
            isInterested = responseList[i]['isInterested'].toString();
            isGoing = responseList[i]['isGoing'].toString();
          });
        }else {
          setState(() {
            isInterested = "false";
            isGoing = "false";
          }); 
        }
        
        Event_Model event_model = new Event_Model(
            eventId,
            eventTitle,
            eventURL,
            eventVenue,
            eventDesc,
            eventDate,
            interestedCounter,
            goingCounter,
            isInterested,
            isGoing);
        eventList.add(event_model);
      }
      print("event ==  $eventList");
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
            controller: _scrollController,
            itemCount: eventList.length + 1,
            itemBuilder: (BuildContext context, int index) {
              return eventList.length <= index
                  ? isPageLoading
                      ? _buildProgressIndicator()
                      : Container(
                          height: 50,
                        )
                  : GestureDetector(
                      onTap: () {
                        print(eventList[index].isInterested);
                        print(eventList[index].isGoing);
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => Act_EventDetail(
                                  eventList[index].eventId,
                                  eventList[index].eventTitle,
                                  eventList[index].eventDate,
                                  eventList[index].eventVenue,
                                  eventList[index].eventDesc,
                                  eventList[index].eventUrl,
                                  eventList[index].isInterested,
                                  eventList[index].isGoing,
                                  eventList[index].interestedCounter,
                                  eventList[index].goingCounter,
                                ),
                          ),
                        ).then((value){
                          print(value);
                          getSharePref();
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 10.0, horizontal: 15.0),
                        height: MediaQuery.of(context).size.height * 0.42,
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.0)),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                                flex: 6,
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: eventList[index].eventUrl ==
                                                  null
                                              ? AssetImage("gallery2.jpg")
                                              : eventList[index].eventUrl[0]['url'] == null
                                                  ? AssetImage("gallery2.jpg")
                                                  : NetworkImage(
                                                      eventList[index]
                                                          .eventUrl[0]['url']),
                                          fit: BoxFit.fill),
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(4.0),
                                          topRight: Radius.circular(4.0))),
                                )),
                            Expanded(
                              flex: 5,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                color: Colors.grey.withOpacity(0.1),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01,
                                              top: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.008),
                                          child: Text(
//                                              Wed,22 May AT 20:30
                                            "${DateFormat("EEE, dd MMM AT hh:mm").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(eventList[index].eventDate))}",
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01,
                                              top: 0.5,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01),
                                          child: Text(
                                            eventList[index].eventTitle == null
                                                ? " - "
                                                : eventList[index].eventTitle,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      child: Text(
                                        eventList[index].eventVenue == null
                                            ? " - "
                                            : eventList[index].eventVenue,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                        left:
                                            MediaQuery.of(context).size.height *
                                                0.01,
                                      ),
                                      child: Text(
                                        "${eventList[index].interestedCounter} people interested",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 11.0,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01,
                                              right: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.01,
                                              top: 0.5),
                                          child: Divider(
                                            color: Colors.grey.withOpacity(0.8),
                                            height: 1.0,
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.012),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: <Widget>[
                                              Expanded(
                                                child: InkWell(
                                                  onTap: () {
                                                    if (login_status == "false" ||
                                                        login_status == null) {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => Act_Login())).then((value){
                                                        if(value == "true"){
                                                          getSharePref();
                                                        }
                                                      });
                                                    } else {
                                                      sendInterestApi(eventList[index]
                                                          .isInterested,eventList[index]
                                                          .eventId,eventList[index]
                                                          .isGoing).then((value) {
                                                        print(value);
                                                        setState(() {
                                                          if (value) {
//                                                            if(eventList[index]
//                                                                .isInterested == "true"){
//                                                              eventList[index]
//                                                                  .isInterested = "false";
//                                                            }else{
//                                                              eventList[index]
//                                                                  .isInterested = "true";
//                                                            }
                                                            getEventApi(currentPage);
                                                          }
                                                        });
                                                      });
                                                    }
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      eventList[index]
                                                          .isInterested == 'null' || eventList[index]
                                                              .isInterested == "false"
                                                          ? Icon(
                                                              Icons.star_border,
                                                              color: Colors
                                                                  .black45,
                                                            )
                                                          : Icon(
                                                              Icons.star,
                                                              color:
                                                                  CustomColors
                                                                      .cyan,
                                                            ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 3.0),
                                                        child: Text(
                                                          "Interested",
                                                          style: TextStyle(
                                                              color: eventList[
                                                                          index]
                                                                      .isInterested == 'null' || eventList[index]
                                                                  .isInterested == "false"
                                                                  ? Colors
                                                                      .black45
                                                                  : CustomColors
                                                                      .cyan,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 14),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: InkWell(
                                                  onTap: (){
                                                    Share.share('skara testing');
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.share,
                                                        color: Colors.black45,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets.only(
                                                                left: 3.0),
                                                        child: Text(
                                                          "Share",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black45,
                                                              fontWeight:
                                                                  FontWeight.w600,
                                                              fontSize: 14),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
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


  Future sendInterestApi(String isInterested, String eventId, String isGoing) async {
    if(isInterested == 'null' && isGoing == 'null'){
      print("POST");
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });
      }
      var body = jsonEncode({
        "event_id": eventId,
        "user_id": login_userID,
        "interested": isInterested == "true" ? "false" : "true",
        "going": isGoing
      });

      print(body);
      try {
        var response =  await http.post(ConfigApi.EVENT_COUNTER_API,
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
          print("nanna");
          setState(() {
            isLoading = false;
          });
          return true;
        } else {
          Fluttertoast.showToast(msg: "member not created. try again");
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        print(e.toString());
        setState(() {
          isLoading = false;
        });
      }
    }else{
      print("PUT");
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });
      }
      var body = jsonEncode({
        "event_id": eventId,
        "interested": isInterested == "true" ? "false" : "true",
        "going": isGoing
      });

      print(body);
      try {
        var response = await http.put(ConfigApi.EVENT_COUNTER_API+"/$login_userID",
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
          print("nanna");
          setState(() {
            isLoading = false;
          });
          return true;
        } else {
          Fluttertoast.showToast(msg: "member not created. try again");
          setState(() {
            isLoading = false;
          });
        }
      } catch (e) {
        print(e.toString());
        setState(() {
          isLoading = false;
        });
      }
    }

  }

}
