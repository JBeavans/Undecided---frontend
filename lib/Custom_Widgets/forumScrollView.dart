import 'package:flutter/material.dart';
import 'package:test_app/Custom_Widgets/postCard.dart';
import 'package:test_app/Data/post.dart';

class ForumScrollView extends StatefulWidget {
  final String heading;
  List<Post> posts;
  final int currentUserID;

  ForumScrollView(
      {Key key,
      @required this.heading,
      @required this.posts,
      @required this.currentUserID})
      : super(key: key);

  @override
  _ForumScrollViewState createState() => _ForumScrollViewState();
}

class _ForumScrollViewState extends State<ForumScrollView> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          automaticallyImplyLeading: false,
          centerTitle: false,
          pinned: true,
          title: Text(
            widget.heading,
            style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 24,
                fontWeight: FontWeight.w400,
                fontFamily: 'Rufina'),
          ),
        ),
        SliverList(delegate: SliverChildBuilderDelegate(
          (BuildContext context, int local_index) {
            if (local_index.isOdd && local_index ~/ 2 < widget.posts.length) {
              Post post = widget.posts[(local_index ~/ 2)];

              //*****************************************
              //******* REASSESS FUNCTIONALITY **********
              //*****************************************

              // Widget threadArrow;
              // if (post.numReplies > 0) {
              //   int id = post.threadID;
              //   threadArrow = IconButton(
              //       icon: Icon(Icons.arrow_forward_ios),
              //       onPressed: () {
              //         _pushThread(id);
              //       });
              // }
              return PostCard(
                  post: post,
                  text: post.title,
                  currentUserID: widget.currentUserID);
            } else if (local_index.isEven) {
              //divider
              return Divider(thickness: 18, color: Color(0xFFD8D5CF));
            }
          },
        ))
      ],
    );
  }
}
