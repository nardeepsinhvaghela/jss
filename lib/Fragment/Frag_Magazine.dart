import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jss/Activity/Act_MagazinePdf.dart';
import 'package:jss/Activity/Act_Magazine_Detail.dart';
import 'package:jss/Activity/Act_login.dart';
import 'package:jss/utils/ConfigApi.dart';
import 'package:jss/utils/CustomThemeData.dart';
import 'package:jss/utils/StarRating.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:http/http.dart' as http;

class Frag_Magazine extends StatefulWidget {
  @override
  _Frag_MagazineState createState() => _Frag_MagazineState();
}

class _Frag_MagazineState extends State<Frag_Magazine> {
  String isSubscriber = "false";

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

      if (login_status != null ||
          login_status != "" ||
          login_status != "false") {
        login_userID = prefs.getString("login_userId");
        login_userEmail = prefs.getString("login_userEmail");
        login_userToken = prefs.getString("login_token");
        isSubscriber = prefs.getString("isSubscriber");
      }

      print(login_status);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body: Stack(
        children: <Widget>[
          login_status == "false" || login_status == null
              ? _loginWidget(context)
              : isSubscriber == "false" || isSubscriber == null
                  ? Act_Magazine_Detail(context)
                  : GridView.builder(
                      itemCount: 15,
                      addAutomaticKeepAlives: true,
                      gridDelegate:
                          new SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: MediaQuery.of(context)
                                      .size
                                      .width /
                                  (MediaQuery.of(context).size.height / 1.1)),
                      itemBuilder: (BuildContext builder, int index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 15.0, top: 5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 6,
                                child: Card(
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 10),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(7.0))),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage("gallery4.jpg"),
                                            colorFilter: ColorFilter.mode(
                                                Colors.black54,
                                                BlendMode.darken),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(7.0))),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Container(
                                  margin:
                                      EdgeInsets.symmetric(horizontal: 10.0),
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Text(
                                          "The Shape of water Movies",
                                          maxLines: 2,
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontFamily: "Quicksand",
                                              color: Colors.black87),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        Act_MagazinePdf()));
                                          },
                                          child: Container(
                                            margin: EdgeInsets.only(top: 2.0),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(5.0)),
                                                color: CustomColors
                                                    .orageColor[87]),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20.0,
                                                vertical: 5.0),
                                            child: Text(
                                              "Read",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontFamily: "Quicksand",
                                                  color: Colors.white),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        )
                                      ]),
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
                            login_status = value;
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

  Widget _subSciberWidget(BuildContext context) {
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
                    "You are not subsciber?",
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
                    "Click button subscrition",
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
                          "Click to Subscription",
                          style: TextStyle(
                              fontSize: 18.0,
                              fontFamily: "Quicksand",
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                            barrierDismissible: true,
                            context: context,
                            builder: (BuildContext context) {
                              return dialogueEditName(context);
                            }).then((value) {
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

  Widget Act_Magazine_Detail(BuildContext context) {
    return CustomScrollView(
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
                                "${(index + 1) * 3} months",
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
    );
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
      "user_id": login_userID,
      "period": "3",
      "amount": "1500",
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
        Fluttertoast.showToast(msg: responseMap['']);
        setState(() {
          prefs.setString("isSubscriber", "true");
          isSubscriber = "true";
        });
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

Widget dialogueEditName(BuildContext context) {
  return StatefulBuilder(
    builder: (context, state) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(
// you may want to use an aspect ratio here for tablet support
                height: MediaQuery.of(context).size.height * 0.7,
                child: PageView.builder(
// store this controller in a State to save the carousel scroll position
                  controller: PageController(viewportFraction: 0.9),
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int itemIndex) {
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Container(
                        child: Stack(
                          children: <Widget>[
                            Card(
                                margin: EdgeInsets.only(bottom: 35.0, top: 5.0),
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(50.0),
                                        bottomLeft: Radius.circular(50.0),
                                        topRight: Radius.circular(50.0))),
                                color: Color(0XFF5BDDA7),
                                child: Container(
                                  height: MediaQuery.of(context).size.height,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Expanded(
                                        flex: 1,
                                        child: Container(
                                          alignment: Alignment.centerLeft,
                                          margin: EdgeInsets.only(left: 30.0),
                                          child: Text(
                                            "Gold Subscription",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Text(
                                                    "Rs.299",
                                                    style: TextStyle(
                                                        fontSize: 28,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.white),
                                                  ),
                                                  Container(
                                                      height:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .height *
                                                              0.04,
                                                      alignment:
                                                          Alignment.bottomLeft,
                                                      child: Text(
                                                        "  / 3months",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color:
                                                                Colors.white),
                                                      )),
                                                ]),
                                            Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 50.0,
                                                    left: 25.0,
                                                    right: 25.0),
                                                child: Text(
                                                  "Click button subscrition Click button subscrition",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: "Quicksand",
                                                      color: Colors.black54),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                            Container(
                              alignment: Alignment.bottomCenter,
                              child: Card(
                                elevation: 5.0,
                                margin: const EdgeInsets.only(
                                    left: 60.0, right: 60.0, bottom: 10.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30.0))),
                                child:
/*RevealProgressButton(),*/ new Row(
                                  children: <Widget>[
                                    new Expanded(
                                        child: new Container(
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
                                              "Buy Subscription",
                                              style: TextStyle(
                                                  fontSize: 18.0,
                                                  fontFamily: "Quicksand",
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          onPressed: () {}),
                                    )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
