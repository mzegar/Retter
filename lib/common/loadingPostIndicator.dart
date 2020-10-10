import 'package:flutter/material.dart';
import 'package:flutterreddit/mainpage_viewmodel.dart';
import 'package:google_fonts/google_fonts.dart';

Widget buildLoadingPostIndicator(String text, MainPageViewModel viewModel) {
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
          width: !viewModel.refreshController.isRefresh ? 10 : 0,
        ),
        Container(
          width: 20,
          height: 20,
          child: !viewModel.refreshController.isRefresh
              ? CircularProgressIndicator()
              : null,
        ),
      ],
    ),
  );
}
