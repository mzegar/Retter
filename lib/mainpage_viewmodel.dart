import 'package:draw/draw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterreddit/postpage.dart';
import 'package:flutterreddit/postpage_viewmodel.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterreddit/common/config.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

part 'mainpage_viewmodel.g.dart';

class MainPageViewModel = MainPageViewModelBase with _$MainPageViewModel;

abstract class MainPageViewModelBase with Store {
  final Config config;
  final ScrollController scrollController = ScrollController();
  final RefreshController refreshController =
      RefreshController(initialRefresh: false);
  final String defaultSubredditString = 'all';
  final int _numberOfPostsToFetch = 25;

  MainPageViewModelBase({
    @required this.reddit,
    @required this.config,
  }) {
    _initPage();
  }

  @observable
  Reddit reddit;

  @observable
  Redditor redditor;

  @observable
  String expandedPost;

  @observable
  List<String> savedSubs = ObservableList<String>();

  @observable
  List<Submission> submissionContent = ObservableList<Submission>();

  @observable
  SubredditRef currentSubreddit;

  @observable
  bool loadedPostSuccessfully = true;

  @observable
  bool hasLoadedAllAvailablePosts = false;

  void goToPostPage(BuildContext context, Submission submission) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => PostPage(
          viewModel: PostPageViewModel(submission: submission),
          mainPageViewModel: this,
        ),
      ),
    );
  }

  void changeToSubreddit(String subredditTextField) async {
    submissionContent.clear();
    currentSubreddit = reddit.subreddit(subredditTextField);
    hasLoadedAllAvailablePosts = false;

    loadedPostSuccessfully = true;
    loadedPostSuccessfully = await _getPosts(currentSubreddit);
    if (loadedPostSuccessfully) {
      savedSubs = ObservableList.of(config.saveSubreddit(subredditTextField));
    }
  }

  void deleteSubreddit(String subredditToDelete) {
    savedSubs = ObservableList.of(config.deleteSubreddit(subredditToDelete));
  }

  Future login() async {
    if (redditor == null) {
      await config.login((Reddit redditResponse) async {
        if (redditResponse != null) {
          reddit = redditResponse;
          await getRedditor();
        }
      });
    }
  }

  Future logout() async {
    if (redditor != null) {
      await config.logout((Reddit redditResponse) async {
        if (redditResponse != null) {
          reddit = redditResponse;
          redditor = null;
          config.deleteLoginDetails();
        }
      });
    }
  }

  Future refreshPosts() async {
    submissionContent.clear();
    hasLoadedAllAvailablePosts = false;
    loadedPostSuccessfully = true;
    loadedPostSuccessfully = await _getPosts(currentSubreddit);
  }

  void _initPage() async {
    await getRedditor();

    _setDefaultSubreddit();

    changeToSubreddit(defaultSubredditString);

    _initScrollController();
  }

  SubredditRef _setDefaultSubreddit() {
    return currentSubreddit = reddit.subreddit('all');
  }

  Future<bool> _getPosts(SubredditRef subredditToFetchFrom) async {
    if (!hasLoadedAllAvailablePosts)
      try {
        var subreddit = subredditToFetchFrom.hot(
            after: submissionContent.isNotEmpty
                ? submissionContent.last.fullname
                : null,
            limit: _numberOfPostsToFetch);

        var posts = await subreddit.toList();
        hasLoadedAllAvailablePosts = posts.length != _numberOfPostsToFetch;
        for (UserContent post in posts) {
          Submission submission = post;
          submissionContent.add(submission);
        }
        return true;
      } catch (_) {
        return false;
      }
    return true;
  }

  void _initScrollController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
              scrollController.position.maxScrollExtent &&
          !hasLoadedAllAvailablePosts) {
        _getPosts(currentSubreddit);
      }
    });
  }

  Future getRedditor() async {
    try {
      redditor = await reddit.user.me();
    } catch (e) {
      // TODO: handle this error
    }
  }
}
