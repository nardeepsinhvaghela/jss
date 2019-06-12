import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jss/Activity/Act_DashBoard.dart';
import 'package:jss/Activity/Act_login.dart';
import 'package:jss/loader/color_loader_4.dart';
import 'package:jss/utils/CustomThemeData.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "My App",
    home: new MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(

        child:ColorLoader4(
          dotOneColor: Colors.blue,
          dotTwoColor: Colors.orangeAccent,
          dotThreeColor: Colors.blue,
          duration: Duration(seconds: 2),
        ),
      ),
    );
  }*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setPref();
    Timer(Duration(seconds: 5), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Act_DashBoard()));
    });
  }

  setPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      if (prefs.getString("login_status") == null ||
          prefs.getString("login_status") == "false") {
        print("Login-Status ==> " + prefs.getString("login_status"));
      } else {
        print("Login-Token ==> " + prefs.getString("login_token"));
        print("Login-Token-Type ==> " + prefs.getString("login_tokenType"));
        print("Login-UserID ==> " + prefs.getString("login_userId"));
        print("Login-UserNAME ==> " + prefs.getString("login_userName"));
      }
    }catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomColors.orageColor,
        body: Center(
            child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("jss_logo_white.png"), fit: BoxFit.cover)),
        )));
  }
}
