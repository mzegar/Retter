import 'package:draw/draw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterreddit/src/postpage.dart';
import 'package:flutterreddit/src/postpage_viewmodel.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterreddit/src/common/config.dart';

part 'mainpage_viewmodel.g.dart';

class MainPageViewModel = MainPageViewModelBase with _$MainPageViewModel;

abstract class MainPageViewModelBase with Store {
  final Reddit reddit;
  final Redditor user;
  final Config config;
  final ScrollController scrollController = ScrollController();
  final String defaultSubredditString = 'all';

  final int _numberOfPostsToFetch = 25;

  MainPageViewModelBase({
    @required this.reddit,
    @required this.user,
    @required this.config
  }) {
    _initPage();
  }

  @observable
  String expandedPost;

  @observable
  List<Submission> submissionContent = ObservableList<Submission>();

  @observable
  SubredditRef currentSubreddit;

  @observable
  bool loadingPosts = false;

  @observable
  bool loadedPostSuccessfully = true;

  void goToPostPage(BuildContext context, Submission submission) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => PostPage(
                viewModel: PostPageViewModel(submission: submission),
              )),
    );
  }

  void changeToSubreddit(String subredditTextField) async {
    submissionContent.clear();
    currentSubreddit = reddit.subreddit(subredditTextField);

    loadedPostSuccessfully = true;
    loadedPostSuccessfully = await _getPosts(currentSubreddit);
  }

  Future refreshPosts() async {
    submissionContent.clear();
    loadedPostSuccessfully = true;
    loadedPostSuccessfully = await _getPosts(currentSubreddit);
  }

  void _initPage() async {
    _setDefaultSubreddit();

    changeToSubreddit(defaultSubredditString);

    _initScrollController();
  }

  SubredditRef _setDefaultSubreddit() {
    return currentSubreddit = reddit.subreddit('all');
  }

  Future<bool> _getPosts(SubredditRef subredditToFetchFrom) async {
    try{
      loadingPosts = true;
      var subreddit = subredditToFetchFrom.hot(
          after: submissionContent.isNotEmpty
              ? submissionContent.last.fullname
              : null,
          limit: _numberOfPostsToFetch);

      await for (UserContent post in subreddit) {
        Submission submission = post;
        submissionContent.add(submission);
      }
      loadingPosts = false;
      return true;
    }
    catch(_) {
      loadingPosts = false;
      return false;
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
