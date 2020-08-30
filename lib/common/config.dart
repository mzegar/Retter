import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static final String subredditKey = 'subreddits';
  final bool isAndroid;
  final SharedPreferences sharedPreferences;

  const Config({
    this.isAndroid,
    this.sharedPreferences,
  });
}
