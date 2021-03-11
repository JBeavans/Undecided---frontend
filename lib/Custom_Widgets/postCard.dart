import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:test_app/Custom_Widgets/replyButton.dart';
import 'package:test_app/Data/post.dart';
import 'package:test_app/Screens/Thread/thread.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final String text;
  final int currentUserID;

  PostCard(
      {Key key,
      @required this.post,
      @required this.text,
      @required this.currentUserID})
      : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 0,
        margin: EdgeInsets.only(left: 0.5, right: 0.5),
        child: ListTile(
            contentPadding: EdgeInsets.only(top: 16, left: 16, bottom: 8),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Thread(
                          origin: widget.post,
                          currentUserID: widget.currentUserID)));
              setState(() {});
            },
            title: Text(
              widget.text,
              style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Inter'),
            ),
            subtitle: Container(
                height: 48,
                child: Row(
                  children: [
                    IconButton(
                        icon: Icon(Icons.thumb_up_alt_outlined),
                        onPressed: null),
                    IconButton(
                        icon: Icon(Icons.thumb_down_alt_outlined),
                        onPressed: null),
                    //************************************************** */
                    //ADD REPLY FUNCTIONALITY **************************
                    //************************************************** */

                    // _postSheet(tc_context,
                    //     thread: widget.post.threadID, post: widget.post.postID);
                    // OutlinedButton(
                    //     onPressed: () {},
                    //     child: Text(
                    //       "Reply",
                    //       style: TextStyle(
                    //           color: Color(0xFF4C4C51),
                    //           fontSize: 16,
                    //           fontFamily: 'Inter',
                    //           fontWeight: FontWeight.w500),
                    //     )),
                    ReplyButton(
                      post: widget.post,
                      user: widget.currentUserID,
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 14.0),
                      child: Text(
                        //
                        //************************************************** */
                        //ADD DYNAMIC FUNCTIONALITY **************************
                        //************************************************** */

                        "Replies: ${numReplies(widget.post.postID)}",
                      ),
                    )
                  ],
                ))));
  }

  numReplies(postID) async {
    await Post.getNumReplies(postID).then((numReplies) => numReplies);
  }
}
