import 'package:flutter/material.dart';

enum popupMenuOptions {
  Login,
  Settings,
}

class CustomPopupMenu extends StatelessWidget {
  final void Function(popupMenuOptions optionSelected) onTap;

  CustomPopupMenu({
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Color(0xFF121212),
      itemBuilder: (BuildContext context) {
        return popupMenuOptions.values.map((option) {
          return PopupMenuItem(
            value: option,
            child: Text(option.toString().split('.').last),
          );
        }).toList();
      },
      onSelected: (popupMenuOptions option) {
        onTap(option);
      },
    );
  }
}
