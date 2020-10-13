import 'package:draw/draw.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutterreddit/common/launchURL.dart';
import 'package:flutterreddit/common/popupDialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:markdown/markdown.dart' as md;

class SubredditPost extends StatefulWidget {
  final BuildContext context;
  final Submission submissionData;
  final bool isViewingPost;
  final bool isLoggedIn;
  final void Function() onTap;
  final void Function() onCommentTap;
  final void Function(String subreddit) onSubredditTap;
  final void Function(String name) onProfileTap;
  final String selfText;

  const SubredditPost({
    this.context,
    this.submissionData,
    this.isViewingPost,
    this.isLoggedIn,
    this.onTap,
    this.onCommentTap,
    this.onSubredditTap,
    this.onProfileTap,
    this.selfText,
  });
  @override
  _SubredditPostState createState() => _SubredditPostState();
}

class _SubredditPostState extends State<SubredditPost> {
  VoteState voteStatus = VoteState.none;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Card(
        margin: EdgeInsets.zero,
        color: Color(0xFF282828),
        child: InkWell(
          onTap: () {
            if (widget.onTap != null) widget.onTap();
          },
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.submissionData.title,
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 4),
                        InkWell(
                          onTap: () {
                            if (widget.onProfileTap != null)
                              widget.onProfileTap(widget.submissionData.author);
                          },
                          child: Text(
                            'u/${widget.submissionData.author}',
                            style: GoogleFonts.inter(
                              color: Colors.blueGrey,
                              fontSize: 11,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              '${NumberFormat.compact().format(widget.submissionData.upvotes + (voteStatus == VoteState.upvoted ? 1 : 0) + (voteStatus == VoteState.downvoted ? -1 : 0))} upvotes  •  ${widget.submissionData.numComments.toString()} comments  •  ',
                              style: GoogleFonts.inter(
                                color: Colors.white60,
                                fontSize: 11,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                if (widget.isViewingPost) {
                                  Navigator.pop(context);
                                }
                                widget.onSubredditTap(
                                  widget.submissionData.subreddit.displayName,
                                );
                              },
                              child: Text(
                                'r/${widget.submissionData.subreddit.displayName}',
                                style: GoogleFonts.inter(
                                  color: Colors.white60,
                                  fontSize: 11,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                      ],
                    ),
                  ),
                  widget.submissionData.isSelf || widget.isViewingPost
                      ? Container()
                      : _buildPostThumbnail(
                          widget.submissionData.preview,
                          screenWidth,
                        ),
                  if (widget.selfText != null && widget.selfText.isNotEmpty)
                    _buildSelfText(),
                ],
              ),
              _buildBottomBar(context),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _upVote() async {
    // TODO: Setup API call such that it cant be spammed
    setState(() {
      voteStatus = VoteState.upvoted;
    });
  }

  Future<void> _downVote() async {
    // TODO: Setup API call such that it cant be spammed
    setState(() {
      voteStatus = VoteState.downvoted;
    });
  }

  Future<void> _copyPostUrl(BuildContext context) async {
    Clipboard.setData(
        ClipboardData(text: widget.submissionData.url.toString()));
    await showPopupDialog(context: context, dialogMessage: 'Copied Link');
  }

  Widget _buildBottomBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (!widget.isViewingPost)
          IconButton(
            icon: Icon(
              EvaIcons.messageSquareOutline,
            ),
            onPressed: () {
              if (widget.onCommentTap != null) widget.onCommentTap();
            },
          ),
        if (!widget.isViewingPost && widget.isLoggedIn)
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_up,
              color: widget.submissionData.vote == VoteState.upvoted ||
                      voteStatus == VoteState.upvoted
                  ? Colors.red
                  : Colors.white,
            ),
            onPressed: () {
              _upVote();
            },
          ),
        if (!widget.isViewingPost && widget.isLoggedIn)
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: widget.submissionData.vote == VoteState.downvoted ||
                      voteStatus == VoteState.downvoted
                  ? Colors.red
                  : Colors.white,
            ),
            onPressed: () {
              _downVote();
            },
          ),
        IconButton(
          icon: Icon(Icons.content_copy),
          onPressed: () {
            _copyPostUrl(context);
          },
        ),
      ],
    );
  }

  Widget _buildPostThumbnail(
      List<SubmissionPreview> thumbnails, double screenWidth) {
    if (thumbnails != null && thumbnails.isNotEmpty) {
      var image = thumbnails.first.resolutions.last;
      var imageResolution = image.height / image.width;
      return FadeInImage.memoryNetwork(
        fadeInDuration: Duration(milliseconds: 200),
        placeholder: kTransparentImage,
        image: image.url.toString(),
        width: screenWidth,
        fit: BoxFit.fitWidth,
        height: imageResolution * screenWidth,
      );
    }
    return Container();
  }

  Widget _buildSelfText() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.all(10),
      child: IntrinsicHeight(
        child: MarkdownBody(
          styleSheet: MarkdownStyleSheet(
            p: GoogleFonts.inter(
              fontSize: 13,
            ),
            h1: GoogleFonts.inter(
              fontSize: 16,
            ),
            h2: GoogleFonts.inter(
              fontSize: 19,
            ),
            h3: GoogleFonts.inter(
              fontSize: 22,
            ),
            tableHead: TextStyle(fontWeight: FontWeight.bold),
            tableBody: GoogleFonts.ptMono(),
            tableColumnWidth: IntrinsicColumnWidth(),
          ),
          data: widget.submissionData.selftext,
          extensionSet:
              md.ExtensionSet(md.ExtensionSet.gitHubWeb.blockSyntaxes, [
            md.EmojiSyntax(),
            ...md.ExtensionSet.gitHubFlavored.inlineSyntaxes,
          ]),
          onTapLink: (String url) async {
            await launchURL(url);
          },
        ),
      ),
    );
  }
}
