import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:jss/utils/CustomThemeData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Frag_DashBoard extends StatefulWidget {
  @override
  _Frag_DashBoardState createState() => _Frag_DashBoardState();
}

class _Frag_DashBoardState extends State<Frag_DashBoard> {
  List<String> img_list = [
    "https://images.unsplash.com/photo-1502943693086-33b5b1cfdf2f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80",
    "https://images.unsplash.com/photo-1510525009512-ad7fc13eefab?ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80",
    "https://images.unsplash.com/photo-1445464157715-605349ac2e43?ixlib=rb-1.2.1&auto=format&fit=crop&w=675&q=80"
  ];

  String login_status = "false",
      login_userEmail = "";
  String login_userToken = "";

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

      print(login_userEmail);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.backgroundColor,
        body: CustomScrollView(
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildListDelegate([
                  Stack(
                    children: <Widget>[
                      Container(
                        color: CustomColors.orageColor,
                        height: MediaQuery
                            .of(context)
                            .size
                            .height * 0.15,
                      ),
                      login_status == "false"
                          ? Container(
                        height: 213,
                        margin: EdgeInsets.only(
                            left: 5.0,
                            right: 5.0,
                            top: MediaQuery
                                .of(context)
                                .size
                                .height * 0.05),
//                    color: Colors.transparent,
                        width: MediaQuery
                            .of(context)
                            .size
                            .width,
                        child: Card(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.all(Radius.circular(5.0)),
                              image: DecorationImage(
                                image: AssetImage("banner1.png"),
                              ),
                            ),
                          ),
                        ),
                      )
                          : Container(
                        margin: EdgeInsets.only(
                            left: 10.0,
                            right: 10.0,
                            top: MediaQuery
                                .of(context)
                                .size
                                .height * 0.05),
                        color: Colors.transparent,
                        child: Card(
                          elevation: 5.0,
                          margin: EdgeInsets.symmetric(
                              horizontal:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .width * 0.02),
                          color: Colors.grey[200],
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(15.0))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 10.0, left: 10.0, right: 10.0),
                                child: Row(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(right: 5.0),
                                      height:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .height *
                                          0.072,
                                      width:
                                      MediaQuery
                                          .of(context)
                                          .size
                                          .height *
                                          0.072,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://media.gettyimages.com/photos/facebook-cofounder-chairman-and-ceo-mark-zuckerberg-arrives-to-a-picture-id944363520"),
                                              fit: BoxFit.fill)),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Nardeepsinh Vaghela",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20.0,
                                              color: Colors.orange),
                                        ),
                                        Text(
                                          login_userEmail == null
                                              ? ""
                                              : login_userEmail,
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.only(
                                    left: 10.0,
                                    right: 10.0,
                                    top: 20.0,
                                    bottom: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceAround,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "Total Donation",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            ImageIcon(
                                              AssetImage(
                                                  "ic_rupee_indian.png"),
                                              size: 16.0,
                                            ),
                                            Text(
                                              "150000",
                                              style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 20,
                                                  fontWeight:
                                                  FontWeight.w700),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 10.0)),
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          "This Month",
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            ImageIcon(
                                              AssetImage(
                                                  "ic_rupee_indian.png"),
                                              size: 16.0,
                                            ),
                                            Text(
                                              "15000",
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontSize: 20,
                                                  fontWeight:
                                                  FontWeight.w700),
                                            ),
                                          ],
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.32,
                    padding: EdgeInsets.only(
                        top: MediaQuery
                            .of(context)
                            .size
                            .height * 0.018),
                    child: new Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          elevation: 1.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                  Radius.circular(5.0))),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(5.0)),
                                image: DecorationImage(
                                  image: NetworkImage(img_list[index]),
                                  fit: BoxFit.fill,
                                )),
                          ),
                        );
                      },
                      itemCount: img_list.length,
                      viewportFraction: 0.8,
                      autoplay: true,
                      scale: 0.9,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery
                            .of(context)
                            .size
                            .height * 0.018,
                        top: MediaQuery
                            .of(context)
                            .size
                            .height * 0.035,
                        bottom: MediaQuery
                            .of(context)
                            .size
                            .height * 0.018),
                    child: Text(
                      "Recent Event",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.orange),
                    ),
                  ),
                  Container(
                    height: MediaQuery
                        .of(context)
                        .size
                        .height * 0.33,
                    child: ListView.builder(
                      itemCount: 10,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.47,
                          margin: EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                                Radius.circular(5.0)),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.5),
                                width: 1.0),
                            color: Colors.grey.withOpacity(0.1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 7,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(5.0),
                                        topLeft: Radius.circular(5.0)),
                                    image: DecorationImage(
                                        image: AssetImage("gallery1.jpg"),
                                        fit: BoxFit.fill),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                      margin:
                                      EdgeInsets.only(
                                          left: 5.0, top: 3.0, right: 10.0),
                                      child: Text(
                                        "Wed,22 May AT 20:30",
//                                "${DateFormat("EEE, dd MMM AT hh:mm").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(eventList[index].eventDate))}",
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 10.0,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                      EdgeInsets.only(left: 5.0, right: 10.0),
                                      child: Text(
                                        "Event Title",
                                        style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w700),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                      EdgeInsets.only(left: 5.0, right: 10.0),
                                      child: Text(
                                        "C806, the first, vastrapur, ahmedabad - 380015",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          border: Border(
                                              top: BorderSide(
                                                  color: Colors.grey
                                                      .withOpacity(0.3),
                                                  width: 1.0))),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 3.0),
                                      child: Row(
                                        children: <Widget>[
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      right: BorderSide(
                                                          color: Colors.grey,
                                                          width: 0.5))),
                                              child: Icon(
                                                Icons.star_border,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border(
                                                      left: BorderSide(
                                                          color: Colors.grey,
                                                          width: 0.5))),
                                              child: Icon(
                                                Icons.share,
                                                color: Colors.black54,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery
                            .of(context)
                            .size
                            .height * 0.018,
                        top: MediaQuery
                            .of(context)
                            .size
                            .height * 0.035,
                        bottom: MediaQuery
                            .of(context)
                            .size
                            .height * 0.018),
                    child: Text(
                      "Community Issue",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.orange),
                    ),
                  ),
                  Container(
                    child: Card(
                      margin: EdgeInsets.symmetric(
                          horizontal: MediaQuery
                              .of(context)
                              .size
                              .height * 0.018),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7.0))),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
//                        shape: RoundedRectangleBorder(
//                            borderRadius:
//                                BorderRadius.all(Radius.circular(7.0))),
                              child: Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.24,
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
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: <Widget>[
                                        Expanded(
                                          child: Text(
                                            "The Shape of water Moviet The Shape of water Movies",
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
                                          child: Text(
                                            "12/02/2018",
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
                                      child: Text(
                                        "The Shape of water Movies of water Movies The Shape of water Movies of water Movies",
                                        maxLines: 2,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Quicksand",
                                            color: Colors.black45),
                                      ),
                                    ),
                                  ]),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery
                            .of(context)
                            .size
                            .height * 0.018,
                        top: MediaQuery
                            .of(context)
                            .size
                            .height * 0.036,
                        bottom: MediaQuery
                            .of(context)
                            .size
                            .height * 0.018),
                    child: Text(
                      "Upcoming Events",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.orange),
                    ),
                  ),
                ])),
            SliverList(
                delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: MediaQuery
                                .of(context)
                                .size
                                .height * 0.018,
                            vertical: MediaQuery
                                .of(context)
                                .size
                                .height * 0.009),
                        padding: EdgeInsets.symmetric(
                            vertical: MediaQuery
                                .of(context)
                                .size
                                .height * 0.027,
                            horizontal: MediaQuery
                                .of(context)
                                .size
                                .height * 0.018),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1.0, color: Colors.white54),
                            color: Colors.blueGrey,
                            borderRadius: BorderRadius.all(
                                Radius.circular(15.0))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "Event Name",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                  color: Colors.white),
                            ),
                            Text(
                              "12/12/2019",
                              style: TextStyle(color: Colors.white70),
                            )
                          ],
                        ),
                      );
                    }, childCount: 5)),
            SliverPadding(
              padding: EdgeInsets.only(top: 10.0),
            )
          ],
        ));
  }
}
