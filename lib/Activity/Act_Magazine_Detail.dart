import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jss/utils/ConfigApi.dart';
import 'package:jss/utils/CustomThemeData.dart';
import 'package:jss/utils/StarRating.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:http/http.dart' as http;

class Act_Magazine_Detail extends StatefulWidget {
  @override
  _Act_Magazine_DetailsState createState() => _Act_Magazine_DetailsState();
}

class _Act_Magazine_DetailsState extends State<Act_Magazine_Detail> {
  var customerReviews = 3.0;
  int selected = 0;
  var yourrate = 0;
  List<String> img_list = [
    "https://images.unsplash.com/photo-1502943693086-33b5b1cfdf2f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80",
    "https://images.unsplash.com/photo-1510525009512-ad7fc13eefab?ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80",
    "https://images.unsplash.com/photo-1445464157715-605349ac2e43?ixlib=rb-1.2.1&auto=format&fit=crop&w=675&q=80"
  ];

  String login_status = "false", login_userEmail = "", login_userID = "";
  String login_userToken = "";
  bool isLoading = false;

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

      if (login_status != null || login_status != "" || login_status != "false") {
        login_userID = prefs.getString("login_userId");
        login_userEmail = prefs.getString("login_userEmail");
        login_userToken = prefs.getString("login_token");
      }

      print(login_status);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            Container(
              height: MediaQuery.of(context).size.height * 0.25,
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.018),
              child: new Swiper(
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 15.0),
                    child: Card(
                      elevation: 1.0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                            image: DecorationImage(
                              image: NetworkImage(img_list[index]),
                              fit: BoxFit.fill,
                            )),
                      ),
                    ),
                  );
                },
                itemCount: img_list.length,
                viewportFraction: 1.0,
                autoplay: true,
                scale: 0.9,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: 20.0, right: 10.0, top: 20.0, bottom: 3.0),
              child: Text(
                "Valmiki's Ramayana (10001)",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Quicksand",
                    color: CustomColors.black),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 23.0, right: 23.0, bottom: 5.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "by ",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54),
                  ),
                  Text(
                    "Subba Rao" + " ",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: CustomColors.blue),
                  ),
                  Text(
                    "(Author)",
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 23.0, bottom: 20.0),
              child: SmoothStarRating(
                rating: customerReviews,
                size: 20,
                starCount: 5,
                borderColor: CustomColors.orageColor,
                color: CustomColors.orageColor,
              ),
            ),
            Divider(
              color: Colors.grey.withOpacity(0.5),
              height: 1.0,
            ),
            Container(
              margin: EdgeInsets.only(
                  left: 20.0, right: 10.0, top: 10.0, bottom: 3.0),
              child: Text(
                "Time period select",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Quicksand",
                    color: CustomColors.black),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              height: 65,
              child: ListView.builder(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return selected == index
                      ? Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.0, vertical: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(5.0),
                            ),
                            border: Border.all(
                                color: CustomColors.orageColor, width: 1.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${(index + 1 )* 3} months",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black87),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                                child: Text(
                                  "RS. ${(index + 1) * 100}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: Colors.blue),
                                ),
                              )
                            ],
                          ),
                        )
                      : Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selected = index;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 10.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                                border: Border.all(
                                    color: Colors.black54, width: 1.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "${(index + 1) * 3} months",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 2.0),
                                    child: Text(
                                      "RS. ${(index + 1) * 100}",
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black54),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                },
              ),
            ),
            Divider(
              color: Colors.grey.withOpacity(0.5),
              height: 1.0,
            ),
            Container(
              margin: EdgeInsets.only(
                  left: 20.0, right: 10.0, top: 10.0, bottom: 3.0),
              child: Text(
                "Desciption",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Quicksand",
                    color: CustomColors.black),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 30.0, right: 15.0, top: 5.0),
              child: Text(
                "You are paying nothing compared to the quality provided by Gita press...salute to Ancient Gita press for providing our religious book at approx no cost.",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: "OpenSans",
                    color: Colors.black54),
              ),
            ),
            Card(
              elevation: 5.0,
              margin: const EdgeInsets.only(
                  top: 30.0, left: 20.0, right: 20.0, bottom: 10.0),
              shape: RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.grey.withOpacity(0.5), width: 1.0),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child:
                  /*RevealProgressButton(),*/ new Row(
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
                          "Buy Now",
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontFamily: "Quicksand"),
                        ),
                      ),
                      onPressed: () {
                        sendMagSubAPI(login_userID);
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(
                color: Colors.grey.withOpacity(0.5),
                height: 1.0,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: 20.0, right: 10.0, top: 10.0, bottom: 10.0),
              child: Text(
                "Rate this product",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Quicksand",
                    color: CustomColors.black),
              ),
            ),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(bottom: 10.0, top: 5.0),
                child: StarRating(
                  onChanged: (index) {
                    setState(() {
                      yourrate = index;
                      showDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (BuildContext context) {
                            return dialogue_Rating(context);
                          });
                    });
                  },
                  value: yourrate,
                )),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                "WRITE A REVIEW",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.cyan),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: Divider(
                color: Colors.grey.withOpacity(0.5),
                height: 1.0,
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  left: 20.0, right: 10.0, top: 20.0, bottom: 10.0),
              child: Text(
                "Review",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Quicksand",
                    color: CustomColors.black),
              ),
            ),
          ]),
        ),
        SliverList(
          delegate:
              SliverChildBuilderDelegate((BuildContext context, int index) {
            return Container(
              margin: EdgeInsets.symmetric(vertical: 15.0),
              padding: EdgeInsets.only(left: 20.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 40.0,
                        width: 40.0,
                        margin: EdgeInsets.only(right: 10.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage("gallery1.jpg"),
                              fit: BoxFit.cover),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Nardeep Vaghela",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Quicksand",
                                color: Colors.black54),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 1.0),
                            child: Text(
                              "22/25/2015",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "OpenSans",
                                  color: Colors.black54),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 5.0),
                            child: SmoothStarRating(
                              rating: customerReviews,
                              size: 13,
                              starCount: 5,
                              borderColor: CustomColors.orageColor,
                              color: CustomColors.orageColor,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),

                  Container(
                    margin: EdgeInsets.only(
                        left: 50.0, right: 5.0, top: 10.0, bottom: 10.0),
                    child: Text(
                      "You are paying nothing compared to the quality provided by Gita press...salute to Ancient Gita press for providing our religious book at approx no cost.",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: "OpenSans",
                          color: Colors.black54),
                    ),
                  ),
                  Divider(
                    color: Colors.grey.withOpacity(0.5),
                    height: 1.0,
                  )
                ],
              ),
            );
          }, childCount: 10),
        )
      ],
    ));
  }

  Widget dialogue_Rating(BuildContext context) {
    return StatefulBuilder(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, top: 5.0, bottom: 15.0, right: 2.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "Rate this product",
                                  style: TextStyle(
                                      color: CustomColors.black,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w700),
                                ),
                                IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    })
                              ],
                            ),
                          ),
                          Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(bottom: 10.0, top: 5.0),
                              child: StarRating(
                                onChanged: (index) {
                                  state(() {
                                    yourrate = index;
                                  });
                                },
                                value: yourrate,
                              )),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.withOpacity(0.7),
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            margin: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 15.0),
                            padding: EdgeInsets.only(left: 10.0),
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              maxLines: 3,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Enter review',
                                hintStyle: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                          new Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: RaisedButton(
                                elevation: 5.0,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(10.0)),
                                splashColor: Colors.grey.withOpacity(0.7),
                                color: CustomColors.buttonColor,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 15.0),
                                  child: Text(
                                    "Send",
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ),
                                onPressed: () {}),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future sendMagSubAPI(String login_userID) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }
    var body = jsonEncode({
      "userid": login_userID,
    });

    print(body);
    try {
      var response = await http.post(ConfigApi.MAGSUB_API,
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
          prefs.setString("isSubscriber", "true");
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
