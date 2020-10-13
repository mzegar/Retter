import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PopupDialog extends StatelessWidget {
  const PopupDialog({Key key, this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      title: Text(text),
    );
  }
}
