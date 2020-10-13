import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopupDialog extends StatelessWidget {
  final String dialogMessage;

  const PopupDialog({
    Key key,
    this.dialogMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AlertDialog(
          backgroundColor: Color(0xFF282828),
          content: Text(
            dialogMessage,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(),
          ),
        ),
      ],
    );
  }
}

Future<void> showPopupDialog({
  BuildContext context,
  String dialogMessage,
}) async {
  return await showDialog(
      context: context,
      barrierColor: Colors.white.withOpacity(0),
      builder: (_) {
        Future.delayed(
          Duration(seconds: 1),
          () {
            Navigator.of(context).pop(true);
          },
        );
        return PopupDialog(
          dialogMessage: dialogMessage,
        );
      });
}
