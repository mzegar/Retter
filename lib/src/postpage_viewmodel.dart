import 'package:draw/draw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';

part 'postpage_viewmodel.g.dart';

class PostPageViewModel = PostPageViewModelBase with _$PostPageViewModel;

abstract class PostPageViewModelBase with Store {
  final Submission submission;

  @observable
  List<Comment> comments = [];

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
    await submission.refreshComments();

    List<Comment> postComments = [];
    if (submission.comments != null && submission.comments.comments != null) {
      for (var comment in submission.comments.comments) {
        if (comment is Comment) {
          postComments.add(comment);
        }
      }
    }

    comments = ObservableList.of(postComments);
  }
}
