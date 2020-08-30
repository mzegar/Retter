import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

Future launchURL(String url) async {
  FlutterWebBrowser.openWebPage(url: url, androidToolbarColor: Colors.black26);
}
