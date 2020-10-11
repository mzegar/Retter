import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterreddit/profilepage_viewmodel.dart';

class ProfilePage extends StatelessWidget {
  final ProfilePageViewModel viewModel;

  const ProfilePage({
    @required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Scaffold(
        backgroundColor: Color(0xFF121212),
        appBar: AppBar(
          title: Text('username here'),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: ListView(
          children: <Widget>[
            Container(),
          ],
        ),
      );
    });
  }
}
