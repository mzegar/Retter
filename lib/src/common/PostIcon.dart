import 'package:draw/draw.dart';
import 'package:flutter/material.dart';

class SubredditPost {

  static Widget buildPostIcon(Submission submission) {
    if (submission.isSelf) {
      return _buildIcon(Icons.arrow_forward_ios);
    } else if (submission.isVideo) {
      return _buildIcon(Icons.videocam);
    } else {
      return _buildIcon(Icons.launch);
    }
  }

  static Widget _buildIcon(IconData icon) {
    return Icon(icon, size: 25,);
  }
}