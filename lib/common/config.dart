import 'package:shared_preferences/shared_preferences.dart';

class Config {
  static final String subredditKey = 'subreddits';
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
}
