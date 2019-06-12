import 'package:flutter/material.dart';
import 'package:jss/Activity/Act_BlogsDetails.dart';
import 'package:jss/utils/CustomThemeData.dart';

class Frag_CommunityIssues extends StatefulWidget {
  @override
  _Frag_CommunityIssuesState createState() => _Frag_CommunityIssuesState();
}

class _Frag_CommunityIssuesState extends State<Frag_CommunityIssues> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
      body: GridView.builder(
          itemCount: 15,
          addAutomaticKeepAlives: true,
          gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: MediaQuery.of(context).size.width /
                  (MediaQuery.of(context).size.height / 1.4)),
          itemBuilder: (BuildContext builder, int index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => Act_BlogsDetails()));
              },
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(7.0))),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
//                        shape: RoundedRectangleBorder(
//                            borderRadius:
//                                BorderRadius.all(Radius.circular(7.0))),
                          child: Container(
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
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 5.0, vertical: 5.0),
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  "The Shape of water Movies",
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Quicksand",
                                      color: Colors.black87),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 3.0, right: 2.0),
                                  child: Text(
                                    "The Shape of water Movies of water Movies",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontFamily: "Quicksand",
                                        color: Colors.grey),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      "12/02/2018",
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black54),
                                    ),
                                    Icon(
                                      Icons.bookmark,
                                      color: Colors.grey,
                                    )
                                  ],
                                )
                              ]),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
