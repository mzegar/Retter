import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutterreddit/src/mainpage_viewmodel.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterreddit/src/common/LaunchURL.dart';
import 'package:flutterreddit/src/common/PostIcon.dart';

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
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
      accentColor: Colors.blueAccent,
    ),
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
    return Observer(builder: (_) {
      var isExpanded = viewModel.expandedPost == submission.id;
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 0),
        child: Card(
          color: Colors.black26,
          child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          if (submission.isSelf) {
                            viewModel.goToPostPage(context, submission);
                          } else {
                            launchURL(submission.url.toString());
                          }
                        },
                        onLongPress: () {
                          viewModel.expandedPost = submission.id;
                          print('clicked');
                        },
                        child: Row(
                          children: <Widget>[
                            SubredditPost.buildPostIcon(submission),
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
                      ),
                      isExpanded
                          ? SizedBox(
                              height: 10,
                            )
                          : SizedBox(),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        height: isExpanded ? 30 : 0,
                        curve: Curves.fastOutSlowIn,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: () {
                                viewModel.goToPostPage(context, submission);
                              },
                              child: Text(
                                'Comments',
                                style: TextStyle(
                                  color: Colors.blueGrey
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
      );
    });
  }
}
