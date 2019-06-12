import 'dart:convert';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jss/Activity/Act_BlogDetail.dart';
import 'package:jss/Activity/Act_EventDetail.dart';
import 'package:jss/utils/ConfigApi.dart';
import 'package:jss/utils/CustomThemeData.dart';
import 'package:http/http.dart' as http;

class Frag_Blog extends StatefulWidget {
  @override
  _Frag_BlogState createState() => _Frag_BlogState();
}

class model_class {
  int roleId;
  String roleName;
  List<dynamic> eventList;

  model_class(this.roleId, this.roleName, this.eventList);
}

class _Frag_BlogState extends State<Frag_Blog> with TickerProviderStateMixin {
  TabController _tabController;
  final List<Tab> tabs1 = new List();
  List<model_class> blogsList = new List();
  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBlogsApi();
  }

  Future getBlogsApi() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      var response = await http.get(
        ConfigApi.BLOGS_API + "?page=1",
        headers: {"content-type": "application/json"},
      );
      print(response.body);
      Map responseMap = jsonDecode(response.body);
      List<dynamic> responseList = responseMap['data'];
      for (int i = 0; i < responseList.length; i++) {
        tabs1.add(new Tab(
          text: responseList[i]['category']['name'],
          id: responseList[i]['category']['id'],
        ));
      }

      blogsList.clear();
      for (int i = 0; i < tabs1.length; i++) {
        List<dynamic> tempBlogsList = new List();
        for (int j = 0; j < responseList.length; j++) {
          if (tabs1[i].id == responseList[j]['category']['id']) {
            tempBlogsList.add(responseList[i]);
          }
        }
        print(tempBlogsList);
        model_class model = new model_class(responseList[i]['category']['id'],
            responseList[i]['category']['name'], tempBlogsList);
        blogsList.add(model);
      }
      print(tabs1);
      _tabController = new TabController(vsync: this, length: tabs1.length);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.backgroundColor,
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
          : Stack(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height,
                  child: blogsList.length <= 0
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.0, vertical: 10.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.5),
                                        width: 1.0),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0))),
                                child: Text(
                                  "No Blog",
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            )
                          ],
                        )
                      : Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              color: CustomColors.appBarColor,
                              child: new TabBar(
                                controller: _tabController,
                                tabs: tabs1,
                                unselectedLabelColor: tabs1.length == 1
                                    ? CustomColors.appBarColor
                                    : Colors.white,
                                labelColor: CustomColors.appBarColor,
                                indicatorSize: TabBarIndicatorSize.tab,
                                indicator: new BubbleTabIndicator(
                                  indicatorRadius: 5.0,
                                  indicatorHeight: 30.0,
                                  indicatorColor: Colors.white,
                                  tabBarIndicatorSize: TabBarIndicatorSize.tab,
                                ),
                                isScrollable: true,
                              ),
                            ),
                            Expanded(
                              child: new TabBarView(
                                controller: _tabController,
                                children: tabs1.map((Tab tab) {
                                  List<dynamic> tempBlogList = new List();
                                  for (int i = 0; i < blogsList.length; i++) {
                                    if (tab.id == blogsList[i].roleId) {
                                      tempBlogList = blogsList[i].eventList;
                                    }
                                  }
                                  return new Center(
                                      child: ListView.builder(
                                          itemCount: tempBlogList.length + 1,
                                          itemBuilder: (context, index) {
                                            return tempBlogList.length - 1 >=
                                                    index
                                                ? InkWell(
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) => Act_BlogDetail(
                                                                  tempBlogList[index]['title'] ==
                                                                          null
                                                                      ? ""
                                                                      : tempBlogList[index]
                                                                          [
                                                                          'title'],
                                                                  tempBlogList[index]
                                                                              [
                                                                              'description'] ==
                                                                          null
                                                                      ? ""
                                                                      : tempBlogList[index]
                                                                          [
                                                                          'description'],
                                                                  tab.text,
                                                                  tempBlogList[index]
                                                                              [
                                                                              'created_at'] ==
                                                                          null
                                                                      ? ""
                                                                      : tempBlogList[index]
                                                                          ['created_at'])));
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 5.0),
                                                      height: 120,
                                                      child: Card(
                                                        elevation: 5.0,
                                                        color: Colors.grey[100],
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        5.0))),
                                                        child: Row(
                                                          children: <Widget>[
                                                            Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      image: DecorationImage(
                                                                          image: AssetImage(
                                                                              "ic_listitem2.jpg"),
                                                                          colorFilter: ColorFilter.mode(
                                                                              Colors
                                                                                  .black12,
                                                                              BlendMode
                                                                                  .darken),
                                                                          fit: BoxFit
                                                                              .cover),
                                                                      borderRadius: BorderRadius.only(
                                                                          topLeft: Radius.circular(
                                                                              5.0),
                                                                          bottomLeft:
                                                                              Radius.circular(5.0))),
                                                                )),
                                                            Expanded(
                                                                flex: 2,
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              5.0),
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            10.0),
                                                                    child:
                                                                        Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .stretch,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: <
                                                                          Widget>[
                                                                        Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
                                                                          children: <
                                                                              Widget>[
                                                                            Text(
                                                                              tempBlogList[index]['title'] == null ? " - " : tempBlogList[index]['title'],
                                                                              maxLines: 2,
                                                                              style: TextStyle(fontFamily: "Quicksand", fontSize: 16),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(top: 3.0),
                                                                              child: Text(
                                                                                tempBlogList[index]['user_id'] == null ? " - " : tempBlogList[index]['user_id']['name'] == null ? " - " : tempBlogList[index]['user_id']['name'],
                                                                                maxLines: 2,
                                                                                style: TextStyle(fontFamily: "Quicksand", color: Color(0xFF999999), fontSize: 12),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Container(
                                                                          alignment:
                                                                              Alignment.centerRight,
                                                                          child:
                                                                              Text(
                                                                            "${DateFormat("EEEE, MMM dd, yyyy").format(DateFormat("yyyy-MM-dd hh:mm:ss").parse(tempBlogList[index]['created_at']))}",
                                                                            maxLines:
                                                                                1,
                                                                            style: TextStyle(
                                                                                fontFamily: "Quicksand",
                                                                                fontWeight: FontWeight.w600,
                                                                                color: CustomColors.orageColor[87],
                                                                                fontSize: 12),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : Container(
                                                    height: 30.0,
                                                  );
                                          }));
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
    );
  }
}
