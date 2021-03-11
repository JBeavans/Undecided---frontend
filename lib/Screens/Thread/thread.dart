import 'package:flutter/material.dart';
//import 'package:test_app/Custom_Widgets/forumScrollView.dart';
import 'package:test_app/Custom_Widgets/postCard.dart';
import 'package:test_app/Custom_Widgets/replyButton.dart';
import 'package:test_app/Data/post.dart';

class Thread extends StatelessWidget {
  final Post origin;
  final int currentUserID;
  //bool _isMinimized = true;

  Thread({Key key, @required this.origin, this.currentUserID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 112,
        title: Text(
          'Rally',
          style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 32,
              fontWeight: FontWeight.w700,
              fontFamily: 'Rufina'),
        ),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          header(),
          OGPost(
            origin: origin,
            currentUserID: currentUserID,
          ),
          Replies(
            origin: origin,
            currentUserID: currentUserID,
          )
        ]),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget header() {
    String title = "${origin.forumID} Thread";
    return ListTile(title: Text(title));
  }
}

class OGPost extends StatefulWidget {
  final Post origin;
  final int currentUserID;

  OGPost({Key key, @required this.origin, this.currentUserID})
      : super(key: key);

  @override
  _OGPostState createState() => _OGPostState();
}

class _OGPostState extends State<OGPost> {
  bool _isMinimized = true;

  Icon arrow() {
    if (_isMinimized) {
      return Icon(Icons.arrow_left);
    } else {
      return Icon(Icons.arrow_drop_down);
    }
  }

  Widget content() {
    if (_isMinimized) {
      return Container();
    } else {
      return Text(
        widget.origin.content,
        softWrap: true,
        maxLines: null,
      );
    }
  }

  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
      title: Column(children: [
        Row(
          children: [
            Text(widget.origin.title),
            Spacer(),
            IconButton(
              icon: arrow(),
              onPressed: () {
                setState(() {
                  _isMinimized = !_isMinimized;
                });
              },
            )
          ],
        ),
        Divider(
          //indent: 12.0,
          endIndent: 16.0,
          thickness: 1,
        ),
      ]),
      subtitle: Container(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                    width: MediaQuery.of(super.context).size.width * 0.875,
                    child: content()),
              ],
            ),
            Row(
              children: [
                IconButton(
                    icon: Icon(Icons.thumb_up_alt_outlined), onPressed: null),
                IconButton(
                    icon: Icon(Icons.thumb_down_alt_outlined), onPressed: null),
                ReplyButton(post: widget.origin, user: widget.currentUserID),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(right: 14.0),
                  child: Text(
                    //
                    //************************************************** */
                    //ADD DYNAMIC FUNCTIONALITY **************************
                    //************************************************** */

                    "Replies: ${widget.origin.numReplies}",
                  ),
                )
              ],
            )
          ],
        ),
      ),
    ));
  }
}

class Replies extends StatefulWidget {
  final Post origin;
  final int currentUserID;

  Replies({Key key, @required this.origin, this.currentUserID})
      : super(key: key);

  @override
  _RepliesState createState() => _RepliesState();
}

class _RepliesState extends State<Replies> {
  @override
  Widget build(BuildContext context) {
    //get replies
    Future<List<Post>> replies = Post.getReplies(widget.origin.postID);

    //build list view
    return SizedBox(
        width: MediaQuery.of(super.context).size.width,
        height: MediaQuery.of(super.context).size.height * .6,
        child: FutureBuilder<List<Post>>(
            future: replies,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Post> directReplies = snapshot.data ?? [];
                return ListView.builder(
                  itemCount: directReplies.length * 2,
                  itemBuilder: (context, index) {
                    if (index.isEven) {
                      //int semantic_index = index ~/ 2;
                      Post reply = directReplies[index ~/ 2];
                      print(reply.content);
                      return PostCard(
                          post: reply,
                          text: reply.content,
                          currentUserID: widget.currentUserID);
                    } else {
                      return Divider(
                        thickness: 12,
                      );
                    }
                  },
                ); //just a placeholder for now
              } else if (snapshot.hasError) {
                Text error = Text('${snapshot.error}');
                return error;
              } else {
                return CircularProgressIndicator();
              }
            }));
  }
}
