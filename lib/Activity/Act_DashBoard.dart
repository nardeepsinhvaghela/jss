import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jss/Activity/Act_login.dart';
import 'package:jss/Fragment/Frag_Blog.dart';
import 'package:jss/Fragment/Frag_CommunityIssues.dart';
import 'package:jss/Fragment/Frag_Complaint.dart';
import 'package:jss/Fragment/Frag_ComplaintList.dart';
import 'package:jss/Fragment/Frag_DashBoard.dart';
import 'package:jss/Activity/Act_Donation.dart';
import 'package:jss/Fragment/Frag_DonationList.dart';
import 'package:jss/Fragment/Frag_Event.dart';
import 'package:jss/Fragment/Frag_Gallery.dart';
import 'package:jss/Fragment/Frag_Magazine.dart';
import 'package:jss/Fragment/Frag_Membership.dart';
import 'package:jss/Fragment/Frag_Seva.dart';
import 'package:jss/Fragment/Frag_WL_DashBoard.dart';
import 'package:jss/utils/CustomThemeData.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem(this.title, this.icon);
}

class Act_DashBoard extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Home", Icons.home),
    new DrawerItem("Events", Icons.category),
    new DrawerItem("Gallery", Icons.photo_library),
    new DrawerItem("Blogs", Icons.view_comfy),
    new DrawerItem("Magazine", Icons.location_on),
    new DrawerItem("Beacome a Member", Icons.location_on),
    new DrawerItem("Complaint", Icons.location_on),
    new DrawerItem("Seva", Icons.help),
    new DrawerItem("Donation", Icons.location_on),
  ];

  @override
  _Act_DashBoardState createState() => _Act_DashBoardState();
}

class _Act_DashBoardState extends State<Act_DashBoard> {
  String header_name = "Home";
  int _selectedDrawerIndex = 0;
  bool isLogin = false;
  String login_status = "false";

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
//        Home Fragment
        return login_status == "false" ? new Frag_WL_DashBoard():new Frag_DashBoard();
      case 1:
//        Event Fragment
        return new Frag_Event();
      case 2:
//        Galeery Fragment
        return new Frag_Gallery();
      case 3:
//        News Fragment
        return new Frag_Blog();
      case 4:
//        Magazine Fragment
        return new Frag_Magazine();
      case 5:
//        Membership Fragment
        return new Frag_Membership();
      case 6:
//        Complaint Fragment
        return new Frag_ComplaintList();
      case 7:
//        Community Issues Fragment
//        return new Frag_CommunityIssues();
        return new Frag_Seva();
      case 8:
//        Donation Fragment
        return new Frag_DonationList();
      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

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
    });
  }

  @override
  Widget build(BuildContext context) {
//    var drawerOptions = <Widget>[];
//    for (var i = 0; i < widget.drawerItems.length; i++) {
//      var d = widget.drawerItems[i];
//      drawerOptions.add(new ListTile(
//          leading: new Icon(d.icon),
//          title: new Text(d.title),
//          selected: i == _selectedDrawerIndex,
//          onTap: () {
//            header_name = d.title;
//            _onSelectItem(i);
//          }));
//    }

    Future<bool> _onBackPressed() {
      return showDialog(
            context: context,
            builder: (context) => new AlertDialog(
                  title: new Text('Are you sure?'),
                  content: new Text('Do you want to exit an App'),
                  actions: <Widget>[
                    new GestureDetector(
                      onTap: () => Navigator.of(context).pop(false),
                      child: Container(
                          padding: EdgeInsets.only(
                              left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
                          child: Text(
                            "No",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                    ),
                    new GestureDetector(
                      onTap: () {
                        exit(0);
                      },
                      child: Container(
                          padding: EdgeInsets.only(
                              left: 5.0, right: 5.0, top: 2.0, bottom: 2.0),
                          child: Text(
                            " Yes ",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
          ) ??
          false;
    }

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        primary: true,
        appBar: AppBar(
          title: Text(header_name),
          backgroundColor: CustomColors.orageColor,
          automaticallyImplyLeading: true,
          actions: <Widget>[
            login_status == "false"
                ? IconButton(
                    icon: Icon(Icons.input),
                    onPressed: () async {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Act_Login())).then((value) {
                        getSharePref();
                      });
                    })
                : IconButton(
                    icon: Icon(Icons.power_settings_new),
                    onPressed: () async {
                      _resetSharedpref();
                      setState(() {
                        _selectedDrawerIndex = 0;
                      });
                    })
          ],
          elevation: 0.0,
        ),
        drawer:
            /*Drawer(
          child: Container(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: widget.drawerItems.length,
              itemBuilder: (context, index) {
                return Container(
                  color: _selectedDrawerIndex == index ? Colors.red : Colors.white,
                  child: ListTile(
                    title: Text(widget.drawerItems[index].toString()),
                    onTap: () {
                      setState(() {
                        _selectedDrawerIndex = index;
                        Navigator.pop(context);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ),*/

            Drawer(
                child: Container(
          color: Colors.white,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverList(
                  delegate: SliverChildListDelegate([
                UserAccountsDrawerHeader(
                  accountName: Text("Ashish Rawat"),
                  accountEmail: Text("ashishrawat2911@gmail.com"),
                  decoration: BoxDecoration(color: CustomColors.orageColor),
                  currentAccountPicture: CircleAvatar(
                    backgroundColor:
                        Theme.of(context).platform == TargetPlatform.iOS
                            ? CustomColors.blue
                            : Colors.white,
                    child: Text(
                      "A",
                      style: TextStyle(fontSize: 40.0),
                    ),
                  ),
                ),
              ])),
              SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                return _selectedDrawerIndex == index
                    ? Container(
                        color: _selectedDrawerIndex == index
                            ? Colors.white
                            : Colors.white,
                        child: ListTile(
                          title: Text(
                            widget.drawerItems[index].title,
                            style: TextStyle(color: CustomColors.orageColor),
                          ),
                          leading: Icon(
                            widget.drawerItems[index].icon,
                            color: CustomColors.orageColor,
                          ),
                          onTap: () {
                            setState(() {
                              Navigator.pop(context);
                              header_name = widget.drawerItems[index].title;
                              _selectedDrawerIndex = index;
                            });
                          },
                        ),
                      )
                    : Container(
                        color: _selectedDrawerIndex == index
                            ? CustomColors.blue
                            : Colors.white,
                        child: ListTile(
                          title: Text(widget.drawerItems[index].title),
                          leading: Icon(widget.drawerItems[index].icon),
                          onTap: () {
                            setState(() {
                              header_name = widget.drawerItems[index].title;
                              _selectedDrawerIndex = index;
                              Navigator.pop(context);
                            });
                          },
                        ),
                      );
              }, childCount: widget.drawerItems.length))
            ],
          ),
        ) /*ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text("Ashish Rawat"),
                accountEmail: Text("ashishrawat2911@gmail.com"),
                decoration: BoxDecoration(color: CustomColors.orageColor),
                currentAccountPicture: CircleAvatar(
                  backgroundColor:
                  Theme.of(context).platform == TargetPlatform.iOS
                      ? CustomColors.blue
                      : Colors.white,
                  child: Text(
                    "A",
                    style: TextStyle(fontSize: 40.0),
                  ),
                ),
              ),
              new Column(children: drawerOptions)
            ],
          ),*/
                ),
        body: _getDrawerItemWidget(_selectedDrawerIndex),
      ),
    );
  }

  void _resetSharedpref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setString("login_status", "false");
      prefs.setString("login_token", "");
      prefs.setString("login_tokenType", "");
      prefs.setString("login_userId", "");
      prefs.setString("login_userName", "");
      prefs.setString("login_userEmail", "");
      prefs.setString("login_userisMember", "");
      prefs.setString("isSubscriber", "");
      getSharePref();
    });

    print(prefs.get("login_status"));
  }
}
