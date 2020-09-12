import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutterreddit/common/launchURL.dart';
import 'package:flutterreddit/common/loadingPostIndicator.dart';
import 'package:flutterreddit/postpage_viewmodel.dart';
import 'package:google_fonts/google_fonts.dart';

class PostPage extends StatelessWidget {
  final PostPageViewModel viewModel;

  const PostPage({@required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Scaffold(
        backgroundColor: Color(0xFF121212),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Platform.isAndroid ? Icons.arrow_back : Icons.arrow_back_ios,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Align(
            alignment:
                Platform.isAndroid ? Alignment.centerLeft : Alignment.center,
            child: Text(viewModel.submission.title),
          ),
        ),
        body: ListView(
          children: <Widget>[
            _buildPost(),
            viewModel.loadingComments
                ? buildLoadingPostIndicator('Loading comments...')
                : _buildComments(),
          ],
        ),
      );
    });
  }

  Widget _buildPost() {
    return GestureDetector(
      onTap: () {
        if (!viewModel.submission.isSelf) {
          launchURL(viewModel.submission.url.toString());
        }
      },
      child: Card(
        margin: EdgeInsets.zero,
        color: Color(0xFF282828),
        child: Container(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  viewModel.submission.title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                  ),
                ),
                if (viewModel.isSelfPost()) Divider(),
                Padding(
                  padding: EdgeInsets.all(5),
                  child: MarkdownBody(
                    data: viewModel.submission.selftext,
                    onTapLink: (String url) {
                      launchURL(url);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
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
                        Icons.keyboard_arrow_down,
                        size: 20,
                      ),
                      Text(
                        comment.commentData.author,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  MarkdownBody(
                    data: comment.commentData.body,
                    onTapLink: (String url) {
                      launchURL(url);
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
