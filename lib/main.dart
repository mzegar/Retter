import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:draw/draw.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterreddit/common/launchURL.dart';
import 'package:flutterreddit/common/popupMenu.dart';
import 'package:flutterreddit/common/config.dart';
import 'package:google_fonts/google_fonts.dart';
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
        reddit: await config.onAppOpenLogin(),
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
      return Text(
        viewModel.currentSubreddit != null
            ? viewModel.currentSubreddit.displayName
            : viewModel.defaultSubredditString,
        style: GoogleFonts.poppins(),
      );
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
            Observer(builder: (_) {
              return CustomPopupMenu(
                isLoggedIn: viewModel?.redditor != null,
                onTap: (popupMenuOptions optionSelected) async {
                  switch (optionSelected) {
                    case popupMenuOptions.Login:
                      await viewModel.login();
                      break;
                    case popupMenuOptions.Logout:
                      await viewModel.logout();
                      break;
                  }
                },
              );
            }),
          ],
        ),
        CupertinoSliverRefreshControl(
          builder: (
            BuildContext context,
            RefreshIndicatorMode refreshState,
            double pulledExtent,
            double refreshTriggerPullDistance,
            double refreshIndicatorExtent,
          ) {
            if (pulledExtent < 10) {
              return Container();
            }
            switch (refreshState) {
              case RefreshIndicatorMode.inactive:
              case RefreshIndicatorMode.done:
              case RefreshIndicatorMode.armed:
              case RefreshIndicatorMode.refresh:
                return Container();
                break;
              case RefreshIndicatorMode.drag:
                return Icon(EvaIcons.arrowIosUpward);
                break;
            }

            return Container();
          },
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Card(
          margin: EdgeInsets.zero,
          color: Color(0xFF282828),
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
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              submission.title,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    submission.isSelf
                        ? Container()
                        : _buildPostThumbnail(submission.preview),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: Icon(EvaIcons.messageSquareOutline),
                          onPressed: () {
                            viewModel.goToPostPage(context, submission);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildLoadingPostIndicator() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Loading posts...',
            style: GoogleFonts.poppins(),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildPostThumbnail(List<SubmissionPreview> thumbnails) {
    if (thumbnails != null && thumbnails.isNotEmpty) {
      var image = thumbnails.first.resolutions.last;
      return CachedNetworkImage(
        imageUrl: image.url.toString(),
        fit: BoxFit.fitWidth,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Container(),
      );
    }
    return Container();
  }
}
