import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutterreddit/src/mainpage_viewmodel.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

Future<void> main() async {
  //TODO: Add proper login, don't steal my info
  Reddit reddit = await Reddit.createScriptInstance(
    clientId: 'aNfHGVwRIHidMQ',
    clientSecret: 's7ZrpkVBUtB3Eua970V__qXZyZ0',
    userAgent: 'flutterapp',
    username: "testredditor20200622",
    password: "weirdpassword2020", // Fake
  );

  Redditor currentUser = await reddit.user.me();

  runApp(
    MainPage(
      viewModel: MainPageViewModel(reddit: reddit, user: currentUser),
    ),
  );
}

class MainPage extends StatelessWidget {
  final MainPageViewModel viewModel;

  const MainPage({this.viewModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reddit App',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.apps),
            onPressed: () {},
          ),
          title: Text(viewModel.currentSubreddit != null
              ? viewModel.currentSubreddit.displayName
              : viewModel.defaultSubredditString),
        ),
        body: _buildListView(),
      ),
    );
  }

  Widget _buildListView() {
    return Observer(builder: (_) {
      return ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        controller: viewModel.scrollController,
        itemCount: viewModel.submissionContent.length,
        itemBuilder: (_, index) {
          var submissionData = viewModel.submissionContent.elementAt(index);
          return _buildPost(submission: submissionData);
        },
      );
    });
  }

  Widget _buildPost({Submission submission}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0),
      child: Card(
        color: Colors.black26,
        child: Padding(
            padding: EdgeInsets.all(5),
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    submission.isSelf
                        ? Icon(Icons.arrow_forward_ios)
                        : Icon(Icons
                            .videocam), // TODO: Display media widget / post instead
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(submission.title),
                      ),
                    ),
                    Column(
                      children: <Widget>[
                        Text(submission.upvotes.toString()),
                      ],
                    ),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
