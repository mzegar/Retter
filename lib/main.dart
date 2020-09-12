import 'dart:async';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutterreddit/common/loadingPostIndicator.dart';
import 'package:flutterreddit/common/popupMenu.dart';
import 'package:flutterreddit/common/config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterreddit/mainpage_viewmodel.dart';
import 'package:flutterreddit/common/subredditPost.dart';
import 'package:flutterreddit/drawer.dart';
import 'package:flutterreddit/common/launchURL.dart';

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
            if (pulledExtent < 15) {
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
              return buildLoadingPostIndicator('Loading posts...');
            }

            var submissionData = viewModel.submissionContent.elementAt(index);
            return SubredditPost(
              context: context,
              submissionData: submissionData,
              isViewingPost: false,
              isLoggedIn: viewModel?.redditor != null,
              onTap: () {
                if (submissionData.isSelf) {
                  viewModel.goToPostPage(context, submissionData);
                } else {
                  launchURL(submissionData.url.toString());
                }
              },
              onCommentTap: () {
                viewModel.goToPostPage(context, submissionData);
              },
            );
          }),
        ),
      );
    });
  }
}
