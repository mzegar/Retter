import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:draw/draw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterreddit/common/launchURL.dart';
import 'package:flutterreddit/common/popupMenu.dart';
import 'package:flutterreddit/common/postIcon.dart';
import 'package:flutterreddit/common/config.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterreddit/mainpage_viewmodel.dart';

import 'drawer.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      viewModel: MainPageViewModel(
        reddit: await config.anonymousLogin(),
        config: config,
      ),
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
        backgroundColor: Color(0xFF121212),
        resizeToAvoidBottomInset: false,
        drawer: _buildDrawer(context),
        body: _buildCustomScrollView(context),
      );
    });
  }

  Widget _buildDrawer(BuildContext context) {
    return Observer(builder: (_) {
      return SubDrawer(
        savedSubs: viewModel.savedSubs,
        onSavedSubredditTap: (String subredditClicked) {
          viewModel.changeToSubreddit(subredditClicked);
          Navigator.pop(context);
        },
        onSubmitted: (String enteredText) {
          viewModel.changeToSubreddit(enteredText);
          Navigator.pop(context);
        },
        onDeleteSubredditTap: (String subredditDeleted) {
          viewModel.deleteSubreddit(subredditDeleted);
        },
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
          actions: [
            CustomPopupMenu(
              onTap: (popupMenuOptions optionSelected) async {
                switch (optionSelected) {
                  case popupMenuOptions.Login:
                    break;
                  case popupMenuOptions.Settings:
                    // TODO: Handle this case.
                    break;
                }
              },
            ),
          ],
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
