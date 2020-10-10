import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildLoadingPostIndicator(String text) {
  return Padding(
    padding: EdgeInsets.all(10),
    child: Text(
      text,
      style: GoogleFonts.inter(),
    ),
  );
}
