import 'package:cached_network_image/cached_network_image.dart';
import 'package:draw/draw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterreddit/src/mainpage_viewmodel.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterreddit/src/common/LaunchURL.dart';
import 'package:flutterreddit/src/common/PostIcon.dart';
import 'dart:convert';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //TODO: Setup logging in
  String jsonConfigString = await rootBundle.loadString('assets/config.json');
  var jsonConfig = json.decode(jsonConfigString);
  Reddit reddit = await Reddit.createReadOnlyInstance(
    clientId: jsonConfig['clientId'],
    clientSecret: jsonConfig['clientSecret'],
    userAgent: jsonConfig['userAgent'],
  );

  Redditor currentUser = null;

  runApp(MaterialApp(
    title: 'Retter',
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
    return Observer(builder: (_) {
      return Scaffold(
          resizeToAvoidBottomInset: false,
          drawer: _buildDrawer(context),
          appBar: AppBar(
            title: _buildTitle(),
          ),
          body: viewModel.loadedPostSuccessfully
              ? _buildPosts(context)
              : _buildFailedIndicator());
    });
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
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
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

  Widget _buildPosts(BuildContext context) {
    return Observer(builder: (_) {
      return ListView.builder(
        physics: ScrollPhysics(),
        shrinkWrap: true,
        controller: viewModel.scrollController,
        itemCount: viewModel.submissionContent.length + 1,
        itemBuilder: (_, index) {
          if (index == viewModel.submissionContent.length) {
            return _buildLoadingPostIndicator();
          }

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
                  GestureDetector(
                    onTap: () {
                      if (submission.isSelf) {
                        viewModel.goToPostPage(context, submission);
                      } else {
                        launchURL(submission.url.toString());
                      }
                    },
                    onDoubleTap: () {
                      viewModel.expandedPost = submission.id;
                    },
                    child: Column(
                      children: <Widget>[
                        submission.isSelf
                            ? Container()
                            : addImage(submission.thumbnail),
                        Row(
                          children: <Widget>[
                            SubredditPost.buildPostIcon(submission),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(submission.title),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 0, top: 10, bottom: 10),
                              child: Column(
                                children: <Widget>[
                                  Text(submission.upvotes.toString()),
                                ],
                              ),
                            ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Text(
                          submission.author,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            viewModel.goToPostPage(context, submission);
                          },
                          child: Text(
                            'Comments',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      );
    });
  }

  Widget _buildLoadingPostIndicator() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Loading posts...'),
          SizedBox(
            width: 10,
          ),
          CupertinoActivityIndicator(),
        ],
      ),
    );
  }

  Widget _buildFailedIndicator() {
    return Center(
      child: Text('Failed to load posts... does this subreddit exist?'),
    );
  }
}

/// Draw thumbnail using width available.
///
Widget addImage(Uri url) {
  return LayoutBuilder(
      builder: (a, b) => CachedNetworkImage(
          width: b.biggest.width,
          imageUrl: url.toString(),
          fit: BoxFit.fitWidth,
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Container()));
}
