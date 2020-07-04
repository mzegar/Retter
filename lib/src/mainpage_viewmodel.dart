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

enum PostSortType {
  HOT,
  NEW,
  CONTROVERSIAL,
  RISING,
}

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
  bool loadedPostSuccessfully = true;

  @observable
  PostSortType currentSortType = PostSortType.HOT;

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
      var subreddit;
      // TODO: Handle all cases
      switch(currentSortType) {
        case PostSortType.HOT:
          subreddit = subredditToFetchFrom.hot(
              after: submissionContent.isNotEmpty
                  ? submissionContent.last.fullname
                  : null,
              limit: _numberOfPostsToFetch);
          break;
        case PostSortType.NEW:
          subreddit = subredditToFetchFrom.newest(
              after: submissionContent.isNotEmpty
                  ? submissionContent.last.fullname
                  : null,
              limit: _numberOfPostsToFetch);
          break;
        case PostSortType.CONTROVERSIAL:
          subreddit = subredditToFetchFrom.controversial(
              after: submissionContent.isNotEmpty
                  ? submissionContent.last.fullname
                  : null,
              limit: _numberOfPostsToFetch);
          break;
        case PostSortType.RISING:
          subreddit = subredditToFetchFrom.rising(
              after: submissionContent.isNotEmpty
                  ? submissionContent.last.fullname
                  : null,
              limit: _numberOfPostsToFetch);
          break;
      }

      await for (UserContent post in subreddit) {
        Submission submission = post;
        submissionContent.add(submission);
      }
      return true;
    }
    catch(_) {
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
