import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SortDialog extends StatelessWidget {
  final Widget content;

  SortDialog({
    @required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      content: content
    );
  }
}

Future<bool> showSortDialog({
  @required BuildContext context,
  @required Widget content,
}) async {
  return await showDialog<bool>(
      context: context,
      builder: (_) {
        return SortDialog(
          content: content,
        );
      });
}
