import 'dart:io';

import 'package:draw/draw.dart';
import 'package:flutter/material.dart';

class SubredditPost {
  static Widget buildPostIcon(Submission submission) {
    if (submission.isSelf) {
      return _buildIcon(
        Platform.isAndroid ? Icons.arrow_right : Icons.arrow_forward,
      );
    } else if (submission.isVideo) {
      return _buildIcon(Icons.videocam);
    } else {
      return _buildIcon(  Platform.isAndroid ? Icons.open_in_browser: Icons.launch);
    }
  }

  static Widget _buildIcon(IconData icon) {
    return Icon(
      icon,
      size: 25,
    );
  }
}
