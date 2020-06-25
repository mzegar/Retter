import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutterreddit/src/mainpage_viewmodel.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterreddit/src/common/LaunchURL.dart';

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

  runApp(MaterialApp(
    title: 'Reddit app',
    theme: ThemeData.dark(),
    home: MainPage(
      viewModel: MainPageViewModel(reddit: reddit, user: currentUser),
    ),
  ));
}

class MainPage extends StatelessWidget {
  final MainPageViewModel viewModel;

  const MainPage({this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: _buildTitle(),
      ),
      body: _buildListView(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Observer(builder: (_) {
      return Drawer(
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                onSubmitted: (String enteredText) {
                  viewModel.changeToSubreddit(enteredText);
                  Navigator.pop(context);
                },
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0),
                  ),
                  hintText: 'Enter a subreddit',
                ),
              ),
            ),
            ListTile(),
          ],
        ),
      );
    });
  }

  Widget _buildTitle() {
    return Observer(builder: (_) {
      return Text(viewModel.currentSubreddit != null
          ? viewModel.currentSubreddit.displayName
          : viewModel.defaultSubredditString);
    });
  }

  Widget _buildListView(BuildContext context) {
    return Observer(builder: (_) {
      return ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        controller: viewModel.scrollController,
        itemCount: viewModel.submissionContent.length,
        itemBuilder: (_, index) {
          var submissionData = viewModel.submissionContent.elementAt(index);
          return _buildPost(context: context, submission: submissionData);
        },
      );
    });
  }

  Widget _buildPost({BuildContext context, Submission submission}) {
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
                      child: GestureDetector(
                        onTap: () {
                          if (submission.isSelf) {
                            viewModel.goToPostPage(context, submission);
                          } else {
                            launchURL(submission.url.toString());
                          }
                        },
                        onLongPress: () {
                          print('long press');
                        },
                        child: Padding(
                          padding: EdgeInsets.only(left: 5),
                          child: Text(submission.title),
                        ),
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
