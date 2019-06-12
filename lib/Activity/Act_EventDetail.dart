import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:jss/Activity/Act_Donation.dart';
import 'package:jss/Activity/Act_login.dart';
import 'package:jss/utils/ConfigApi.dart';
import 'package:jss/utils/CustomThemeData.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Act_EventDetail extends StatefulWidget {
  String eventId = "",
      eventTitle = "",
      eventDate = "",
      eventAddress = "",
      eventDesc = "";
  String isInterested;
  String isGoing;
  String interestedCounter,goingCounter;
  List eventMedia = new List();

  Act_EventDetail(
      String eventId,
      String eventTitle,
      String eventDate,
      String eventAddress,
      String eventDesc,
      List media,
      String isInterested,
      String isGoing,
      String interestedCounter,
      String goingCounter) {
    this.eventId = eventId;
    this.eventTitle = eventTitle;
    this.eventDate = eventDate;
    this.eventAddress = eventAddress;
    this.eventDesc = eventDesc;
    this.eventMedia = media;
    this.isInterested = isInterested;
    this.isGoing = isGoing;
    this.interestedCounter = interestedCounter;
    this.goingCounter = goingCounter;

    print("isGoinggg ===> $isGoing");
    print("isInterested ===> $isInterested");
  }

  @override
  _Act_EventDetailState createState() => _Act_EventDetailState(
      eventId,
      eventTitle,
      eventDate,
      eventAddress,
      eventDesc,
      eventMedia,
      isInterested,
      isGoing,
      interestedCounter,
      goingCounter);
}

class _Act_EventDetailState extends State<Act_EventDetail> {
  String eventId = "",
      eventTitle = "",
      eventDate = "",
      eventAddress = "",
      eventDesc = "";
  bool isLoading = false;
  List eventMedia = new List();
  List<String> img_list = [
    "https://images.unsplash.com/photo-1502943693086-33b5b1cfdf2f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80",
    "https://images.unsplash.com/photo-1510525009512-ad7fc13eefab?ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80",
    "https://images.unsplash.com/photo-1445464157715-605349ac2e43?ixlib=rb-1.2.1&auto=format&fit=crop&w=675&q=80"
  ];

  String login_status = "false", login_userEmail = "", login_userID = "";
  String login_userToken = "";
  String isInterested;
  String isGoing;
  String interestCounter = "0", goingCounter = "0";

  _Act_EventDetailState(
      String eventId,
      String eventTitle,
      String eventDate,
      String eventAddress,
      String eventDesc,
      List eventMedia,
      String isInterested,
      String isGoing, String interestedCounter, String goingCounter) {
    this.eventId = eventId;
    this.eventTitle = eventTitle;
    this.eventDate = eventDate;
    this.eventAddress = eventAddress;
    this.eventDesc = eventDesc;
    this.eventMedia = eventMedia;
    this.isInterested = isInterested;
    this.isGoing = isGoing;
    this.interestCounter = interestedCounter;
    this.goingCounter = goingCounter;
  }

  getSharePref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      login_status = prefs.getString("login_status");

      if (login_status != null ||
          login_status != "" ||
          login_status != "false") {
        login_userID = prefs.getString("login_userId");
        login_userEmail = prefs.getString("login_userEmail");
        login_userToken = prefs.getString("login_token");
      }
      print(login_status);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (eventMedia != null) {
      img_list.clear();
      for (int i = 0; i < eventMedia.length; i++) {
        img_list.add(eventMedia[i]['url']);
        print(eventMedia[i]['url']);
      }
    }
    getSharePref();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      appBar: AppBar(
//        title: Text("Event Details"),
//        backgroundColor: CustomColors.appBarColor,
//      ),
        body: isLoading
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
            : CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    backgroundColor: CustomColors.orageColor,
                    expandedHeight: MediaQuery.of(context).size.height * 0.3,
                    automaticallyImplyLeading: false,
                    leading: IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          Navigator.pop(context, false);
                        }),
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text(eventTitle,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          )),
                      background: new Swiper(
                        itemBuilder: (BuildContext context, int index) {
                          return new Image.network(
                            img_list[index],
                            fit: BoxFit.fill,
                          );
                        },
                        itemCount: img_list.length,
                        autoplay: img_list.length == 1 ? false : true,
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate([
                      Container(
                        margin:
                            EdgeInsets.only(top: 10.0, left: 20.0, right: 20.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${eventDate == "" ? " - " : DateFormat("MMM").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(eventDate))}",
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      "${eventDate == "" ? " - " : DateFormat("dd").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(eventDate))}",
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    eventTitle,
                                    style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: Text(
                                      "Hosted by Skara technologies",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(top: 25.0, left: 10.0, right: 10.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  if (login_status == "false" ||
                                      login_status == null) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Act_Login())).then((value) {
                                      if (value == "true") {
                                        getSharePref();
                                      }
                                    });
                                  } else {
                                    sendInterestApi(isInterested,eventId,isGoing).then((value) {
                                      print(value);
                                      setState(() {
                                        if (value) {
                                          if (isInterested == "true") {
                                            isInterested = "false";
                                          } else {
                                            isInterested = "true";
                                          }
                                          getCounterApi();
                                        }
                                      });
                                    });
                                  }
                                },
                                child: Column(
                                  children: <Widget>[
                                    isInterested == "true"
                                        ? Icon(Icons.star, color: CustomColors.cyan)
                                        : Icon(
                                            Icons.star_border,
                                            color: Colors.black45,
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 1.0),
                                      child: Text(
                                        "Interested",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: isInterested == "true"
                                                ? CustomColors.cyan
                                                : Colors.black45),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: (){
                                  if (login_status == "false" ||
                                      login_status == null) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Act_Login())).then((value) {
                                      if (value == "true") {
                                        getSharePref();
                                      }
                                    });
                                  } else {
                                    sendGoingApi(isInterested,eventId,isGoing).then((value) {
                                      print(value);
                                      setState(() {
                                        if (value) {
                                          if (isGoing == "true") {
                                            isGoing = "false";
                                          } else {
                                            isGoing = "true";
                                          }
                                          getCounterApi();
                                        }
                                      });
                                    });
                                  }
                                },
                                child: Column(
                                  children: <Widget>[
                                    isGoing == "true"
                                        ? Icon(
                                            Icons.watch_later,
                                            color: CustomColors.orageColor,
                                          )
                                        : Icon(
                                            Icons.watch_later,
                                            color: Colors.black45,
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 1.0),
                                      child: Text(
                                        "Going",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: isGoing == "true"
                                                ?  CustomColors.orageColor : Colors.black45),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.share,
                                    color: Colors.black45,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 1.0),
                                    child: Text(
                                      "Share",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.black54),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Divider(
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Icon(
                                Icons.group,
                                color: Colors.black54,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text("$goingCounter going",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                            ),
                            Text(" | "),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text("$interestCounter interested",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Icon(
                                Icons.watch_later,
                                color: Colors.black54,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5.0),
                              child: Text(
                                  "${eventDate == "" ? " - " : DateFormat("EEE, dd MMM AT hh:mm").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(eventDate))}",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14)),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 10.0, right: 10.0, top: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Icon(
                                Icons.location_on,
                                color: Colors.black54,
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        eventAddress,
                                        style: TextStyle(
                                            color: Colors.black87,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14),
                                      ),
                                    ),
//                        Container(
//                          margin: EdgeInsets.only(top: 3.0),
//                          alignment: Alignment.centerLeft,
//                          child: Text(
//                            "c806, The First, near keshavbaugh, Vastrapu, Ahmedabad - 380015",
//                            style: TextStyle(
//                                color: Colors.black54, fontSize: 13.0),
//                          ),
//                        )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Divider(
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ),
                      Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: Html(
                            data: eventDesc,
                            defaultTextStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          )
                          /* Text(
                eventDesc,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                  fontFamily: "OpenSans",
                ),
              ),*/
                          ),
                      Container(
                        child: Card(
                          elevation: 5.0,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 100.0, vertical: 30.0),
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10.0))),
                          child: new Row(
                            children: <Widget>[
                              new Expanded(
                                  child: FlatButton(
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(10.0)),
                                      splashColor: Colors.white30,
                                      color: CustomColors.buttonColor,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 15.0),
                                        child: Text(
                                          "DONATION",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white),
                                        ),
                                      ),
                                      onPressed: () {
                                        if (login_status != "true") {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Act_Login()));
                                        } else {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      Act_Donation()));
                                        }
                                      })),
                            ],
                          ),
                        ),
                      )
                    ]),
                  ),
                ],
              )

        /*ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height * 0.3,
            child: new Swiper(
              itemBuilder: (BuildContext context, int index) {
                return new Image.network(
                  img_list[index],
                  fit: BoxFit.fill,
                );
              },
              itemCount: img_list.length,
              autoplay: true,
              pagination: SwiperPagination(),

            ),
          ),
          Container(
            margin: EdgeInsets.only(
                left: 20.0, right: 10.0, top: 20.0, bottom: 3.0),
            child: Text(
              "Title Name",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  fontFamily: "Quicksand",
                  color: CustomColors.black),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 23.0, right: 23.0, bottom: 20.0),
            child: Text(
              "12/02/2018",
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black54),
            ),
          ),
          Container(
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                "The Collapsing Toolbar is UI component widely used in our applications today. It consists of displaying an image or background in the upper part of the screen, occupying a fixed space, so that later, by scrolling upwards, the content changes and becomes a navigation bar in iOS or toolbar in the case of Android.Here I show you a visual example of how an interface looks using Collapsing Toolbar The Collapsing Toolbar is UI component widely used in our applications today. It consists of displaying an image or background in the upper part of the screen, occupying a fixed space, so that later, by scrolling upwards, the content changes and becomes a navigation bar in iOS or toolbar in the case of Android.Here I show you a visual example of how an interface looks using Collapsing Toolbar The Collapsing Toolbar is UI component widely used in our applications today. It consists of displaying an image or background in the upper part of the screen, occupying a fixed space, so that later, by scrolling upwards, the content changes and becomes a navigation bar in iOS or toolbar in the case of Android.Here I show you a visual example of how an interface looks using Collapsing Toolbar The Collapsing Toolbar is UI component widely used in our applications today. It consists of displaying an image or background in the upper part of the screen, occupying a fixed space, so that later, by scrolling upwards, the content changes and becomes a navigation bar in iOS or toolbar in the case of Android.Here I show you a visual example of how an interface looks using Collapsing Toolbar The Collapsing Toolbar is UI component widely used in our applications today. It consists of displaying an image or background in the upper part of the screen, occupying a fixed space, so that later, by scrolling upwards, the content changes and becomes a navigation bar in iOS or toolbar in the case of Android.Here I show you a visual example of how an interface looks using Collapsing Toolbar",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                  fontFamily: "OpenSans",
                ),
              )),
          Container(
            child: Card(
              elevation: 5.0,
              margin: const EdgeInsets.symmetric(horizontal: 100.0, vertical: 30.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              child:
              */ /*RevealProgressButton(),*/ /* new Row(
                children: <Widget>[
                  new Expanded(
                      child: FlatButton(
                          shape: new RoundedRectangleBorder(
                              borderRadius: new BorderRadius.circular(10.0)),
                          splashColor: Colors.white30,
                          color: CustomColors.buttonColor,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Text(
                              "DONATION",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                          ),
                          onPressed: () {})),
                ],
              ),
            ),
          )
        ],
      ),*/
        );
  }

  Future sendInterestApi(String isInterested, String eventId, String isGoing) async {
    if (isInterested == 'null' && isGoing == 'null') {
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
        "going": isGoing == "true" ? "true" : "false"
      });

      print(body);
      try {
        var response = await http.post(ConfigApi.EVENT_COUNTER_API,
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
    } else {
      print("PUT");
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });
      }
      var body = jsonEncode({
        "event_id": eventId,
        "interested": isInterested == "true" ? "false" : "true",
        "going": isGoing == "true" ? "true" : "false"
      });

      print(body);
      try {
        var response = await http.put(
            ConfigApi.EVENT_COUNTER_API + "/$login_userID",
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

  Future sendGoingApi(
      String isInterested, String eventId, String isGoing) async {
    if (isGoing == 'null' && isInterested == 'null') {
      print("POST");
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });
      }
      var body = jsonEncode({
        "event_id": eventId,
        "user_id": login_userID,
        "interested": isInterested == "true" ? "true" : "false",
        "going": isGoing == "true" ? "false" : "true"
      });

      print(body);
      try {
        var response = await http.post(ConfigApi.EVENT_COUNTER_API,
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
    } else {
      print("PUT");
      if (!isLoading) {
        setState(() {
          isLoading = true;
        });
      }
      var body = jsonEncode({
        "event_id": eventId,
        "interested": isInterested == "true" ? "true" : "false",
        "going": isGoing == "true" ? "false" : "true"
      });

      print(body);
      try {
        var response = await http.put(
            ConfigApi.EVENT_COUNTER_API + "/$login_userID",
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

  Future getCounterApi() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }

    print(ConfigApi.EVENTS_API + "/user/$login_userID/$eventId");
    try {
      var response = await http.get(
        ConfigApi.EVENTS_USER_API + "/user/$login_userID/$eventId",
        headers: {
          "content-type": "application/json",
          "Authorization": 'Bearer $login_userToken'
        },
      );
      print(response.body);
      Map responseMap = jsonDecode(response.body);

      setState(() {
        interestCounter = responseMap['interested'].toString();
        goingCounter = responseMap['going'].toString();
      });

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
