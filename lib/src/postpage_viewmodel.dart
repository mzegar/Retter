import 'package:draw/draw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter/foundation.dart';

part 'postpage_viewmodel.g.dart';

class PostPageViewModel = PostPageViewModelBase with _$PostPageViewModel;

abstract class PostPageViewModelBase with Store {
  final Submission submission;

  PostPageViewModelBase({
    @required this.submission,
  });

  bool isSelfPost() {
    return submission.isSelf &&
        submission.selftext != null &&
        submission.selftext.isNotEmpty;
  }
}
