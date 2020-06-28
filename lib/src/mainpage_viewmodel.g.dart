// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mainpage_viewmodel.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$MainPageViewModel on MainPageViewModelBase, Store {
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

  final _$loadingPostsAtom = Atom(name: 'MainPageViewModelBase.loadingPosts');

  @override
  bool get loadingPosts {
    _$loadingPostsAtom.reportRead();
    return super.loadingPosts;
  }

  @override
  set loadingPosts(bool value) {
    _$loadingPostsAtom.reportWrite(value, super.loadingPosts, () {
      super.loadingPosts = value;
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

  @override
  String toString() {
    return '''
expandedPost: ${expandedPost},
submissionContent: ${submissionContent},
currentSubreddit: ${currentSubreddit},
loadingPosts: ${loadingPosts},
loadedPostSuccessfully: ${loadedPostSuccessfully}
    ''';
  }
}
