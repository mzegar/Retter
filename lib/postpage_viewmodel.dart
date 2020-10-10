import 'package:draw/draw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';

part 'postpage_viewmodel.g.dart';

class PostPageViewModel = PostPageViewModelBase with _$PostPageViewModel;
class PageComment = PageCommentModelBase with _$PageComment;

abstract class PageCommentModelBase with Store {
  final Comment commentData;
  final int commentLevel;

  @observable
  bool isCollapsed = false;

  @observable
  bool isBelowCollapsed = false;

  PageCommentModelBase({
    this.commentData,
    this.commentLevel,
  });
}

abstract class PostPageViewModelBase with Store {
  final Submission submission;
  final Function(String) goTo;

  @observable
  bool loadingComments = false;

  @observable
  List<PageComment> comments = [];

  PostPageViewModelBase({
    @required this.submission,
    this.goTo,
  }) {
    getComments();
  }

  bool isSelfPost() {
    return submission.isSelf && submission.selftext != null && submission.selftext.isNotEmpty;
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

  void collapseNestedComments(int index) {
    // Collapse clicked on comment
    comments[index].isCollapsed = true;

    // Mark comments below the collapsed comment as "isBelowCollapsed" which will completely
    // remove them from the screen
    int collapseCommentIndex = index + 1;
    for (int i = collapseCommentIndex; i < comments.length; ++i) {
      if (comments[index].commentLevel < comments[i].commentLevel) {
        comments[i].isBelowCollapsed = true;
      } else {
        break;
      }
    }
  }

  void unCollapseNestedComments(int index) {
    // UnCollapse clicked on comment
    comments[index].isCollapsed = false;

    // Mark comments below the collapsed comment as not "isBelowCollapsed" which will
    // reveal the comments again
    int collapseCommentIndex = index + 1;
    for (int i = collapseCommentIndex; i < comments.length; ++i) {
      if (comments[index].commentLevel < comments[i].commentLevel) {
        comments[i].isBelowCollapsed = false;
      } else {
        break;
      }
    }
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
