import 'dart:async';
import 'dart:io';
import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_full_pdf_viewer/full_pdf_viewer_scaffold.dart';
import 'package:jss/utils/CustomThemeData.dart';
import 'package:path_provider/path_provider.dart';

class Act_MagazinePdf extends StatefulWidget {
  @override
  _Act_MagazinePdfState createState() => _Act_MagazinePdfState();
}

class _Act_MagazinePdfState extends State<Act_MagazinePdf> {
  String pathPDF = "";
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    createFileOfPdfUrl().then((f) {
      setState(() {
        pathPDF = f.path;
        print(pathPDF);
      });
    });
  }

  Future<File> createFileOfPdfUrl() async {
    if (isLoading == false) {
      setState(() {
        isLoading = true;
      });
    }
    final url = "http://africau.edu/images/default/sample.pdf";
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    bool exists = await new File('$dir/$filename').exists();
    print(exists);
    if(exists){

    }else{
      await file.writeAsBytes(bytes);
    }
    if (isLoading == true) {
      setState(() {
        isLoading = false;
      });
    }
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              valueColor:
                  new AlwaysStoppedAnimation<Color>(CustomColors.progressBar),
            ),
          )
        : PDFViewerScaffold(
            appBar: AppBar(
              title: Text("Document"),
              backgroundColor: CustomColors.appBarColor,
            ),
            path: pathPDF);
  }
}
