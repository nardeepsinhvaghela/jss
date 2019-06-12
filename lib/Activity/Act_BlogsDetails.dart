import 'package:flutter/material.dart';
import 'package:jss/utils/CustomThemeData.dart';

class Act_BlogsDetails extends StatefulWidget {
  @override
  _Act_BlogsDetailsState createState() => _Act_BlogsDetailsState();
}

class _Act_BlogsDetailsState extends State<Act_BlogsDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          expandedHeight: 200.0,
          floating: false,
          pinned: true,
          title: Text("The Shape of water Movies",maxLines: 1,),
          backgroundColor: CustomColors.appBarColor,
          flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
//                title: Text("Collapsing Toolbar",
//                    style: TextStyle(
//                      color: Colors.white,
//                      fontSize: 16.0,
//                    )),
              background: Image.network(
                "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                fit: BoxFit.cover,
              )),
        ),
        SliverList(
            delegate: SliverChildListDelegate([
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
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
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
        ]))
      ],
    ));
  }
}
