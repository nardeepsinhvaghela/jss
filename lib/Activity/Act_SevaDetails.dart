import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:intl/intl.dart';
import 'package:jss/Activity/Act_Seva.dart';
import 'package:jss/utils/CustomThemeData.dart';
import 'package:share/share.dart';

class Act_SevaDetails extends StatefulWidget {
  Map sevaList = null;

  Act_SevaDetails(Map sevaList) {
    this.sevaList = sevaList;
  }

  @override
  _Act_SevaDetailsState createState() => _Act_SevaDetailsState(sevaList);
}

class _Act_SevaDetailsState extends State<Act_SevaDetails> {
  String sevaID = "",
      blogTitle = "",
      blogDesc = "",
      category = "",
      blogDate = "";
  List<String> img_list = [
    "https://images.unsplash.com/photo-1502943693086-33b5b1cfdf2f?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=334&q=80",
    "https://images.unsplash.com/photo-1510525009512-ad7fc13eefab?ixlib=rb-1.2.1&auto=format&fit=crop&w=334&q=80",
    "https://images.unsplash.com/photo-1445464157715-605349ac2e43?ixlib=rb-1.2.1&auto=format&fit=crop&w=675&q=80"
  ];

  _Act_SevaDetailsState(Map sevaList) {
    sevaID = sevaList['id'].toString();
    blogTitle = sevaList['title'];
    blogDesc = sevaList['description'] == null ? "" : sevaList['description'];
    blogDate = sevaList['created_at'] == null
        ? " - "
        : "${DateFormat("dd MMM, yyyy").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(sevaList['created_at']))}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                backgroundColor: CustomColors.orageColor,
                expandedHeight: MediaQuery.of(context).size.height * 0.3,
                floating: false,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(blogTitle,
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
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      margin: EdgeInsets.only(
                          left: 20.0, right: 10.0, top: 20.0, bottom: 3.0),
                      child: Text(
                        blogTitle,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            fontFamily: "Quicksand",
                            color: CustomColors.black),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          left: 20.0, right: 20.0, bottom: 20.0),
                      child: Text(
                        blogDate,
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child:
                          /*Html(
                          data: "",
                        )*/
                          Text(
                        blogDesc,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.w700,
                          fontFamily: "OpenSans",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.bottomCenter,
            child: new Row(
              children: <Widget>[
                new Expanded(
                  child: FlatButton(
                    splashColor: Colors.white30,
                    color: Colors.grey[400],
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15.0),
                      child: Text(
                        "Share",
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                    onPressed: () {
                      Share.share('skara testing');
                    },
                  ),
                ),
                new Expanded(
                  child: FlatButton(
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Act_Seva(sevaID)));
                    },
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
