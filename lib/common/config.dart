import 'package:draw/draw.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:uuid/uuid.dart';

class Config {
  // API Config
  static final String clientId = '9h-Tx1lSokXDPA';
  static final String userAgent = 'RetterApp';
  static final String redirectUri = 'https://mzegar.github.io/';

  static final String subredditKey = 'subreddits';
  static final String credentialsKey = 'credentials';
  final bool isAndroid;
  final SharedPreferences sharedPreferences;

  Config({
    this.isAndroid,
    this.sharedPreferences,
  }) {
    _init();
  }

  void _init() {
    if (!sharedPreferences.containsKey(subredditKey)) {
      sharedPreferences.setStringList(subredditKey, <String>[]);
    }
  }

  List<String> saveSubreddit(String subreddit) {
    var sharedPreferencesSubs = sharedPreferences.getStringList(subredditKey);
    if (!sharedPreferencesSubs.contains(subreddit)) {
      sharedPreferencesSubs.add(subreddit);
      sharedPreferences.setStringList(subredditKey, sharedPreferencesSubs);
    }
    return sharedPreferencesSubs;
  }

  List<String> deleteSubreddit(String subreddit) {
    var sharedPreferencesSubs = sharedPreferences.getStringList(subredditKey);
    if (sharedPreferencesSubs.contains(subreddit)) {
      sharedPreferencesSubs.remove(subreddit);
      sharedPreferences.setStringList(subredditKey, sharedPreferencesSubs);
    }
    return sharedPreferencesSubs;
  }

  Future login(void Function(Reddit redditResponse) onLogin) async {
    FlutterWebviewPlugin flutterWebView = FlutterWebviewPlugin();

    final redditLogin = Reddit.createInstalledFlowInstance(
      clientId: clientId,
      userAgent: userAgent,
      redirectUri: Uri.parse(redirectUri),
    );

    final authUrl = redditLogin.auth.url(
      ['*'],
      userAgent,
      compactLogin: true,
    );

    flutterWebView.onUrlChanged.listen((String url) async {
      if (url.contains('$redirectUri?state=$userAgent&code=')) {
        var authCode = Uri.parse(url).queryParameters['code'];
        await redditLogin.auth.authorize(authCode);
        saveLoginDetails(redditLogin.auth.credentials.toJson());
        flutterWebView.close();
        onLogin(redditLogin);
      } else if (url
          .contains('$redirectUri?state=$userAgent&error=access_denied')) {
        // TODO: Failed to authenticate
        flutterWebView.close();
        onLogin(null);
      }
    });

    await flutterWebView.launch(authUrl.toString());
  }

  Future logout(void Function(Reddit redditResponse) onLogin) async {
    onLogin(await anonymousLogin());
  }

  void deleteLoginDetails() {
    sharedPreferences.setString(credentialsKey, '');
  }

  void saveLoginDetails(String jsonCredentials) {
    sharedPreferences.setString(credentialsKey, jsonCredentials);
  }

  String getLoginDetails() {
    return sharedPreferences.getString(credentialsKey);
  }

  Future<Reddit> onAppOpenLogin() async {
    var savedLoginCredentials = getLoginDetails();
    if (savedLoginCredentials == null || savedLoginCredentials.isEmpty) {
      return anonymousLogin();
    } else {
      Reddit client = Reddit.restoreAuthenticatedInstance(
        savedLoginCredentials,
        clientId: clientId,
        userAgent: userAgent,
        redirectUri: Uri.parse(redirectUri),
      );

      return client;
    }
  }

  Future<Reddit> anonymousLogin() async {
    final redditLogin = await Reddit.createUntrustedReadOnlyInstance(
      clientId: clientId,
      userAgent: userAgent,
      deviceId: Uuid().v1(),
    );

    return redditLogin;
  }
}
