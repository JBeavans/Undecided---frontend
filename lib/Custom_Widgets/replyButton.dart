import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:test_app/Data/post.dart';

class ReplyButton extends StatelessWidget {
  ReplyButton({@required this.post, @required this.user});
  //final String forum; //should contain the tabcontroller context
  //final int thread; //threadID
  final Post post;
  final int user;
  final TextEditingController _postController = TextEditingController();
  //final GestureTapCallback() onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () {
          _replySheet(context, this.post);
        },
        child: Text(
          "Reply",
          style: TextStyle(
              color: Color(0xFF4C4C51),
              fontSize: 16,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500),
        ));
  }

  void _replySheet(context, post) {
    showModalBottomSheet(
        isScrollControlled: true, //allows user to scroll modal content
        context: context,
        builder: (BuildContext bc) {
          return ReplySheet(
              postController: _postController, user: user, post: post);
        });
  }
}

class ReplySheet extends StatefulWidget {
  const ReplySheet(
      {Key key,
      @required TextEditingController postController,
      @required this.user,
      @required this.post})
      : _postController = postController,
        super(key: key);

  final TextEditingController _postController;
  final int user;
  final Post post;

  @override
  _ReplySheetState createState() => _ReplySheetState();
}

class _ReplySheetState extends State<ReplySheet> {
  @override
  Widget build(BuildContext context) {
    TextEditingController _postController = super.widget._postController;
    Post _post = super.widget.post;
    int _user = super.widget.user;
    return Container(
        height: MediaQuery.of(context).size.height * 0.65,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text('New Post'),
                  Spacer(),
                  FlatButton(
                      onPressed: () async {
                        //add actualy addPost function
                        debugPrint('pressed');
                        String content = _postController.text;
                        int replyID = _post.postID;
                        debugPrint(
                            "forum: ${_post.forumID} thread: ${_post.threadID} content: $content user: $_user");
                        Post.sendPost(_post.forumID, _post.threadID,
                            "reply to: ${_post.title}", content, _user,
                            replyID: replyID);

                        debugPrint("updating replies");

                        await Post.updateReplies(
                            _post.postID); //pass in post ID

                        _postController.clear();
                        Navigator.of(context).pop();
                        setState(() {});
                      },
                      child: Text('Post!'))
                ],
              ),
              TextField(
                controller: _postController,
                textInputAction: TextInputAction.newline,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              )
            ],
          ),
        ));
  }
}
