import 'package:flutter/material.dart';

class SubDrawer extends StatelessWidget {
  final void Function(String enteredText) onSubmitted;

  const SubDrawer({
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFF121212),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                onSubmitted: (String enteredText) {
                  onSubmitted(enteredText);
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  hintText: 'Enter a subreddit',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
