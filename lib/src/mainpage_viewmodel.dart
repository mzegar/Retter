import 'package:draw/draw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterreddit/src/postpage.dart';
import 'package:flutterreddit/src/postpage_viewmodel.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';

part 'mainpage_viewmodel.g.dart';

class MainPageViewModel = MainPageViewModelBase with _$MainPageViewModel;

abstract class MainPageViewModelBase with Store {
  final Reddit reddit;
  final Redditor user;
  final ScrollController scrollController = ScrollController();
  final String defaultSubredditString = 'all';

  final int _numberOfPostsToFetch = 25;

  MainPageViewModelBase({
    @required this.reddit,
    @required this.user,
  }) {
    _initPage();
  }

  @observable
  List<Submission> submissionContent = ObservableList<Submission>();

  @observable
  SubredditRef currentSubreddit;

  void goToPostPage(BuildContext context, Submission submission) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PostPage(
                viewModel: PostPageViewModel(submission: submission),
              )),
    );
  }

  void changeToSubreddit(String subredditTextField) {
    submissionContent.clear();
    currentSubreddit = reddit.subreddit(subredditTextField);
    _getPosts(currentSubreddit);
  }

  void _initPage() {
    _setDefaultSubreddit();

    _getPosts(currentSubreddit);

    _initScrollController();
  }

  SubredditRef _setDefaultSubreddit() {
    return currentSubreddit = reddit.subreddit('all');
  }

  Future _getPosts(SubredditRef subredditToFetchFrom) async {
    try{
      var subreddit = subredditToFetchFrom.hot(
          after: submissionContent.isNotEmpty
              ? submissionContent.last.fullname
              : null,
          limit: _numberOfPostsToFetch);

      await for (UserContent post in subreddit) {
        Submission submission = post;
        submissionContent.add(submission);
      }
    }
    catch(_) {
      //TODO: handle this!
      print('failed to load subs');
    }
  }

  void _initScrollController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        _getPosts(currentSubreddit);
      }
    });
  }
}
