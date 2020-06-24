import 'package:draw/draw.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobx/mobx.dart';

part 'mainpage_viewmodel.g.dart';

class MainPageViewModel = MainPageViewModelBase with _$MainPageViewModel;

abstract class MainPageViewModelBase with Store {
  final Reddit reddit;
  final Redditor user;
  final ScrollController scrollController = ScrollController();
  final String defaultSubredditString = 'all';

  MainPageViewModelBase({
    this.reddit,
    this.user,
  }) {
    _initPage();
  }

  @observable
  List<Submission> submissionContent = ObservableList<Submission>();

  @observable
  SubredditRef currentSubreddit;

  void _initPage() {
    _setDefaultSubreddit();

    _getPosts(currentSubreddit);

    _initScrollController();
  }

  SubredditRef _setDefaultSubreddit() {
    return currentSubreddit = reddit.subreddit('all');
  }

  Future _getPosts(SubredditRef subredditToFetchFrom) async {
    print('fetching new posts');
    var subreddit = subredditToFetchFrom.hot();
    await for (UserContent post in subreddit) {
      Submission submission = post;
      submissionContent.add(submission);
    }
  }

  void _initScrollController() {
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent) {
        _getPosts(currentSubreddit);
      }
    });
  }
}
