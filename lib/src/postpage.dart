import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:flutterreddit/src/postpage_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutterreddit/src/common/LaunchURL.dart';

class PostPage extends StatelessWidget {
  final PostPageViewModel viewModel;

  const PostPage({@required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Post Page',
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: Text(viewModel.submission.title)),
        body: ListView(
          children: <Widget>[
            _buildPost(context: context, submission: viewModel.submission),
            if (viewModel.isSelfPost())
              _buildSelfText(
                  context: context, submission: viewModel.submission),
          ],
        ),
      ),
    );
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

  Widget _buildSelfText({BuildContext context, Submission submission}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 0),
      child: Card(
        color: Colors.black26,
        child: Padding(
          padding: EdgeInsets.all(5),
          child: MarkdownBody(
            data: submission.selftext,
            onTapLink: (String url) {
//              launchURL(context, url);
            },
          ),
        ),
      ),
    );
  }
}
