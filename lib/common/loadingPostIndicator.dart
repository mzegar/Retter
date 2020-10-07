import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildLoadingPostIndicator(String text) {
  return Padding(
    padding: EdgeInsets.all(10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          text,
          style: GoogleFonts.inter(),
        ),
        SizedBox(
          width: 10,
        ),
        Container(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(),
        ),
      ],
    ),
  );
}
