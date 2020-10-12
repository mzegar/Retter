import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum popupMenuOptions { Login, Logout }

class CustomPopupMenu extends StatelessWidget {
  final void Function(popupMenuOptions optionSelected) onTap;
  final bool isLoggedIn;
  final List<popupMenuOptions> _options = [];

  CustomPopupMenu({
    this.onTap,
    this.isLoggedIn,
  }) {
    isLoggedIn
        ? _options.add(popupMenuOptions.Logout)
        : _options.add(popupMenuOptions.Login);
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Color(0xFF121212),
      itemBuilder: (BuildContext context) {
        return _options.map((option) {
          return PopupMenuItem(
            value: option,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                option.toString().split('.').last,
                style: GoogleFonts.inter(),
              ),
            ),
          );
        }).toList();
      },
      onSelected: (popupMenuOptions option) {
        onTap(option);
      },
    );
  }
}
