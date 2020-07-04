import 'package:flutter/material.dart';

class SortDialog extends StatelessWidget {
  final String title, description, buttonText;
  final Image image;

  SortDialog({
    @required this.title,
    @required this.description,
    @required this.buttonText,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      elevation: 0.0,
      backgroundColor: Colors.blue,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text('Test'),
        ],
      ),
    );
  }
}

Future<bool> showSortDialog({
  @required BuildContext context,
}) async {
  return await showDialog<bool>(
      context: context,
      builder: (_) {
        return SortDialog(
          title: 'Test',
          description: 'No Idea',
          buttonText: 'Text',
        );
      });
}
