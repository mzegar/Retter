import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterreddit/common/launchURL.dart';
import 'package:flutterreddit/common/loadingPostIndicator.dart';
import 'package:flutterreddit/postpage_viewmodel.dart';
import 'package:flutterreddit/common/subredditPost.dart';
import 'package:google_fonts/google_fonts.dart';

class PostPage extends StatelessWidget {
  final PostPageViewModel viewModel;

  const PostPage({
    @required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Scaffold(
        backgroundColor: Color(0xFF121212),
        appBar: AppBar(
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
            SubredditPost(
              context: context,
              submissionData: viewModel.submission,
              isViewingPost: true,
              selfText:
                  viewModel.isSelfPost() ? viewModel.submission.selftext : '',
              onTap: () async {
                if (!viewModel.submission.isSelf) {
                  await launchURL(viewModel.submission.url.toString());
                }
              },
              onSubredditTap: viewModel.goToSubreddit,
              onProfileTap: (String username) {
                Navigator.pop(context);
                viewModel.goToProfile(
                  username,
                );
              },
            ),
            viewModel.loadingComments
                ? buildLoadingPostIndicator('Loading comments...')
                : _buildComments(),
          ],
        ),
      );
    });
  }

  Widget _buildComments() {
    return Observer(builder: (_) {
      return ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: viewModel.comments.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildComment(viewModel.comments[index], index);
        },
      );
    });
  }

  Widget _buildComment(PageComment comment, int index) {
    return Observer(builder: (_) {
      if (comment.isBelowCollapsed) {
        return Container();
      } else if (comment.isCollapsed) {
        return GestureDetector(
          onTap: () {
            viewModel.unCollapseNestedComments(index);
          },
          child: Card(
            elevation: 0,
            color: Colors.transparent,
            margin:
                EdgeInsets.fromLTRB(5.0 * comment.commentLevel, 5.0, 5.0, 5.0),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.keyboard_arrow_right,
                        size: 20,
                      ),
                      Text(
                        comment.commentData.author,
                        style: GoogleFonts.inter(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w300,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      } else {
        return GestureDetector(
          onTap: () {
            viewModel.collapseNestedComments(index);
          },
          child: Container(
            margin:
                EdgeInsets.fromLTRB(5.0 * comment.commentLevel, 5.0, 5.0, 5.0),
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 20,
                      ),
                      Text(
                        comment.commentData.author,
                        style: GoogleFonts.inter(
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.w300,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  MarkdownBody(
                    styleSheet: MarkdownStyleSheet(
                      p: GoogleFonts.inter(
                        fontSize: 12,
                      ),
                      h1: GoogleFonts.inter(
                        fontSize: 13,
                      ),
                      h2: GoogleFonts.inter(
                        fontSize: 14,
                      ),
                      h3: GoogleFonts.inter(
                        fontSize: 15,
                      ),
                    ),
                    data: comment.commentData.body,
                    onTapLink: (String url) async {
                      await launchURL(url);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}
