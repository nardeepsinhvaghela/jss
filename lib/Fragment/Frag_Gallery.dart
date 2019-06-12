import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jss/utils/ConfigApi.dart';
import 'package:jss/utils/CustomThemeData.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Frag_Gallery extends StatefulWidget {
  @override
  _Frag_GalleryState createState() => _Frag_GalleryState();
}

class _Frag_GalleryState extends State<Frag_Gallery> {
  String login_status = "false", login_userEmail = "";
  String login_userToken = "";
  bool isLoading = false;
  bool isPageLoading = false;
  List<dynamic> galleryList = new List();

  ScrollController _scrollController = new ScrollController();

  String nextPage = "";
  int pageNumber = 1;
  int lastPageNumber = 1;

  List<String> image_list = [
    "gallery1.jpg",
    "gallery2.jpg",
    "gallery3.jpg",
    "gallery4.jpg",
    "gallery5.jpg",
    "gallery6.jpg",
    "gallery7.jpg",
    "gallery8.jpg",
    "gallery1.jpg",
    "gallery2.jpg",
  ];

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
          getDonationApi(pageNumber);
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
    getDonationApi(1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future getDonationApi(int currentPageNumber) async {
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
        ConfigApi.GALLERY_API + "?page=$currentPageNumber",
        headers: {
          "content-type": "application/json",
          "Authorization": 'Bearer $login_userToken'
        },
      );
      print(response.body);
      galleryList = jsonDecode(response.body);
      print(galleryList);
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
        backgroundColor: Colors.grey[300],
        body: Stack(
          children: <Widget>[
            new StaggeredGridView.countBuilder(
              crossAxisCount: 4,
              itemCount: galleryList.length,
              itemBuilder: (BuildContext context, int index) => new Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      image: DecorationImage(
                          image: NetworkImage(galleryList[index]['url']),
                          fit: BoxFit.cover),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.black12,
                          backgroundBlendMode: BlendMode.darken,
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    ),
                  )),
              /*staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(2, index.isEven ? 2 : 1),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,*/
              staggeredTileBuilder: (int index) =>
                  new StaggeredTile.count(2, index.isEven ? 2 : 1),
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
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
        ));
  }
}
