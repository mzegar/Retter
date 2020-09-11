import 'package:flutter/material.dart';

enum popupMenuOptions { Login, Logout }

class CustomPopupMenu extends StatelessWidget {
  final void Function(popupMenuOptions optionSelected) onTap;
  bool isLoggedIn = false;
  List<popupMenuOptions> _options = [];

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
            child: Text(
              option.toString().split('.').last,
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
