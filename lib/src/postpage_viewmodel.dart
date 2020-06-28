import 'package:draw/draw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';

part 'postpage_viewmodel.g.dart';

class PostPageViewModel = PostPageViewModelBase with _$PostPageViewModel;

class PageComment {
  final Comment commentData;
  final int commentLevel;

  const PageComment({
    this.commentData,
    this.commentLevel,
  });
}

abstract class PostPageViewModelBase with Store {
  final Submission submission;

  @observable
  bool loadingComments = false;

  @observable
  List<PageComment> comments = [];

  PostPageViewModelBase({
    @required this.submission,
  }) {
    getComments();
  }

  bool isSelfPost() {
    return submission.isSelf &&
        submission.selftext != null &&
        submission.selftext.isNotEmpty;
  }

  Future getComments() async {
    loadingComments = true;
    await submission.refreshComments();

    List<PageComment> postComments = [];
    if (submission.comments != null && submission.comments.comments != null) {
      _getNestedComments(submission.comments.comments, postComments, 0);
    }

    comments = ObservableList.of(postComments);
    loadingComments = false;
  }

  void _getNestedComments(List commentList, List<PageComment> pageCommentList, int level) {
    level += 1;
    for (var comment in commentList) {
      if (comment is Comment) {
        pageCommentList.add(PageComment(commentData: comment, commentLevel: level));

        if (comment.replies != null) {
          _getNestedComments(comment.replies.comments, pageCommentList, level);
        }
      }
    }
  }
}
