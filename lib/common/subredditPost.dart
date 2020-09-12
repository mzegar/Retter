import 'package:cached_network_image/cached_network_image.dart';
import 'package:draw/draw.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:transparent_image/transparent_image.dart';

class SubredditPost extends StatelessWidget {
  final BuildContext context;
  final Submission submissionData;
  final bool isViewingPost;
  final void Function() onTap;
  final void Function() onCommentTap;

  const SubredditPost({
    this.context,
    this.submissionData,
    this.isViewingPost,
    this.onTap,
    this.onCommentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Card(
          margin: EdgeInsets.zero,
          color: Color(0xFF282828),
          child: Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                  if (onTap != null) onTap();
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
                              submissionData.title,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    submissionData.isSelf
                        ? Container()
                        : _buildPostThumbnail(submissionData.preview),
                    if (!isViewingPost)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: Icon(EvaIcons.messageSquareOutline),
                            onPressed: () {
                              if (onCommentTap != null) onCommentTap();
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

  Widget _buildPostThumbnail(List<SubmissionPreview> thumbnails) {
    if (thumbnails != null && thumbnails.isNotEmpty) {
      var image = thumbnails.first.resolutions.last;
      return CachedNetworkImage(
        imageUrl: image.url.toString(),
        fit: BoxFit.fitWidth,
        placeholder: (context, url) => FadeInImage.memoryNetwork(
          fadeInDuration: Duration(milliseconds: 200),
          placeholder: kTransparentImage,
          image: image.url.toString(),
        ),
        errorWidget: (context, url, error) => Container(),
      );
    }
    return Container();
  }
}
