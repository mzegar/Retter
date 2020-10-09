// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mainpage_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MainPageViewModel on MainPageViewModelBase, Store {
  final _$redditAtom = Atom(name: 'MainPageViewModelBase.reddit');

  @override
  Reddit get reddit {
    _$redditAtom.reportRead();
    return super.reddit;
  }

  @override
  set reddit(Reddit value) {
    _$redditAtom.reportWrite(value, super.reddit, () {
      super.reddit = value;
    });
  }

  final _$redditorAtom = Atom(name: 'MainPageViewModelBase.redditor');

  @override
  Redditor get redditor {
    _$redditorAtom.reportRead();
    return super.redditor;
  }

  @override
  set redditor(Redditor value) {
    _$redditorAtom.reportWrite(value, super.redditor, () {
      super.redditor = value;
    });
  }

  final _$expandedPostAtom = Atom(name: 'MainPageViewModelBase.expandedPost');

  @override
  String get expandedPost {
    _$expandedPostAtom.reportRead();
    return super.expandedPost;
  }

  @override
  set expandedPost(String value) {
    _$expandedPostAtom.reportWrite(value, super.expandedPost, () {
      super.expandedPost = value;
    });
  }

  final _$savedSubsAtom = Atom(name: 'MainPageViewModelBase.savedSubs');

  @override
  List<String> get savedSubs {
    _$savedSubsAtom.reportRead();
    return super.savedSubs;
  }

  @override
  set savedSubs(List<String> value) {
    _$savedSubsAtom.reportWrite(value, super.savedSubs, () {
      super.savedSubs = value;
    });
  }

  final _$submissionContentAtom =
      Atom(name: 'MainPageViewModelBase.submissionContent');

  @override
  List<Submission> get submissionContent {
    _$submissionContentAtom.reportRead();
    return super.submissionContent;
  }

  @override
  set submissionContent(List<Submission> value) {
    _$submissionContentAtom.reportWrite(value, super.submissionContent, () {
      super.submissionContent = value;
    });
  }

  final _$currentSubredditAtom =
      Atom(name: 'MainPageViewModelBase.currentSubreddit');

  @override
  SubredditRef get currentSubreddit {
    _$currentSubredditAtom.reportRead();
    return super.currentSubreddit;
  }

  @override
  set currentSubreddit(SubredditRef value) {
    _$currentSubredditAtom.reportWrite(value, super.currentSubreddit, () {
      super.currentSubreddit = value;
    });
  }

  final _$loadedPostSuccessfullyAtom =
      Atom(name: 'MainPageViewModelBase.loadedPostSuccessfully');

  @override
  bool get loadedPostSuccessfully {
    _$loadedPostSuccessfullyAtom.reportRead();
    return super.loadedPostSuccessfully;
  }

  @override
  set loadedPostSuccessfully(bool value) {
    _$loadedPostSuccessfullyAtom
        .reportWrite(value, super.loadedPostSuccessfully, () {
      super.loadedPostSuccessfully = value;
    });
  }

  final _$hasLoadedAllAvailablePostsAtom =
      Atom(name: 'MainPageViewModelBase.hasLoadedAllAvailablePosts');

  @override
  bool get hasLoadedAllAvailablePosts {
    _$hasLoadedAllAvailablePostsAtom.reportRead();
    return super.hasLoadedAllAvailablePosts;
  }

  @override
  set hasLoadedAllAvailablePosts(bool value) {
    _$hasLoadedAllAvailablePostsAtom
        .reportWrite(value, super.hasLoadedAllAvailablePosts, () {
      super.hasLoadedAllAvailablePosts = value;
    });
  }

  @override
  String toString() {
    return '''
reddit: ${reddit},
redditor: ${redditor},
expandedPost: ${expandedPost},
savedSubs: ${savedSubs},
submissionContent: ${submissionContent},
currentSubreddit: ${currentSubreddit},
loadedPostSuccessfully: ${loadedPostSuccessfully},
hasLoadedAllAvailablePosts: ${hasLoadedAllAvailablePosts}
    ''';
  }
}
