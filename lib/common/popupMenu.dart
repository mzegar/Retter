import 'package:flutter/material.dart';

enum options {
  Settings,
}

class CustomPopupMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Color(0xFF121212),
      itemBuilder: (BuildContext context) {
        return options.values.map((option) {
          return PopupMenuItem(
            value: option,
            child: Text(option.toString().split('.').last),
          );
        }).toList();
      },
      onSelected: (options option) {
        switch (option) {
          case options.Settings:
            break;
        }
      },
    );
  }
}
