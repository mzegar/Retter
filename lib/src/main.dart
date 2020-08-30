import 'package:cached_network_image/cached_network_image.dart';
import 'package:draw/draw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterreddit/src/mainpage_viewmodel.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterreddit/src/common/launchURL.dart';
import 'package:flutterreddit/src/common/postIcon.dart';
import 'package:flutterreddit/src/common/config.dart';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //TODO: Setup logging in and some system to parse information somewhere else
  String jsonConfigString = await rootBundle.loadString('assets/config.json');
  var jsonConfig = json.decode(jsonConfigString);
  Reddit reddit = await Reddit.createReadOnlyInstance(
    clientId: jsonConfig['clientId'],
    clientSecret: jsonConfig['clientSecret'],
    userAgent: jsonConfig['userAgent'],
  );

  Redditor currentUser = null;

  Config config = Config(
    isAndroid: Platform.isAndroid,
    sharedPreferences: await SharedPreferences.getInstance(),
  );

  runApp(MaterialApp(
    title: 'Retter',
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Color(0xFF030303),
      accentColor: Colors.blueAccent,
    ),
    home: MainPage(
      viewModel:
          MainPageViewModel(reddit: reddit, user: currentUser, config: config),
    ),
  ));
}

class MainPage extends StatelessWidget {
  final MainPageViewModel viewModel;

  const MainPage({this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      resizeToAvoidBottomInset: false,
      drawer: _buildDrawer(context),
      body: _buildCustomScrollView(context),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color(0xFF121212),
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
      ),
    );
  }

  Widget _buildTitle() {
    return Observer(builder: (_) {
      return Text(viewModel.currentSubreddit != null
          ? viewModel.currentSubreddit.displayName
          : viewModel.defaultSubredditString);
    });
  }

  Widget _buildCustomScrollView(BuildContext context) {
    return CustomScrollView(
      physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      controller: viewModel.scrollController,
      slivers: <Widget>[
        SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: _buildTitle(),
          ),
        ),
        CupertinoSliverRefreshControl(
          onRefresh: () async {
            viewModel.refreshPosts();
          },
        ),
        if (viewModel.loadedPostSuccessfully) _buildPosts(context: context),
      ],
    );
  }

  List<Widget> _buildPostSortTypeOptions(BuildContext context) {
    List<Widget> cards = [];
    PostSortType.values.forEach((element) {
      cards.add(Card(
        child: InkWell(
          child: Container(
            width: 200,
            height: 50,
            child: Center(
              child: Padding(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                child: Text(element.toString().split('.').last),
              ),
            ),
          ),
          onTap: () {
            viewModel.currentSortType = element;
            return Navigator.pop(context, true);
          },
        ),
      ));
    });
    return cards;
  }

  Widget _buildPosts({BuildContext context}) {
    return Observer(builder: (_) {
      return SliverList(
        delegate: SliverChildListDelegate(
          List.generate(viewModel.submissionContent.length + 1, (index) {
            if (index == viewModel.submissionContent.length) {
              return _buildLoadingPostIndicator();
            }

            var submissionData = viewModel.submissionContent.elementAt(index);
            return _buildPost(context: context, submission: submissionData);
          }),
        ),
      );
    });
  }

  Widget _buildPost({BuildContext context, Submission submission}) {
    return Observer(builder: (_) {
      var isExpanded = viewModel.expandedPost == submission.id;
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
        child: Container(
          color: Color(0xFF282828),
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
                            : _buildPostThumbnail(submission.preview),
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

  Widget _buildPostThumbnail(List<SubmissionPreview> thumbnails) {
    if (thumbnails != null && thumbnails.isNotEmpty) {
      var image = thumbnails.first.resolutions.last;
      return Container(
        child: Padding(
          padding: EdgeInsets.all(5.0),
          child: CachedNetworkImage(
              imageUrl: image.url.toString(),
              fit: BoxFit.fitWidth,
              placeholder: (context, url) => CupertinoActivityIndicator(
                    radius: 20,
                  ),
              errorWidget: (context, url, error) => Container()),
        ),
      );
    }
    return Container();
  }
}
