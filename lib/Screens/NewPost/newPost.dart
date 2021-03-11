import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_app/Custom_Widgets/forumRadioSelection.dart';
import 'package:test_app/Data/post.dart';
import 'package:test_app/Data/user.dart';
import 'package:test_app/Validation/newPostValidation.dart';

class NewPost extends StatefulWidget {
  final User user;

  NewPost({Key key, @required this.user}) : super(key: key);

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final _postController = TextEditingController();
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final validationService = Provider.of<NewPostValidation>(context);

    ForumRadioSelection _radios =
        ForumRadioSelection(validator: validationService);

    String _title = validationService.postTitle.value;
    if (_title != null) {
      _titleController.value = TextEditingValue(
          text: _title,
          selection:
              TextSelection.fromPosition(TextPosition(offset: _title.length)));
    }

    String _content = validationService.postContent.value;
    if (_content != null) {
      _postController.value = TextEditingValue(
          text: _content,
          selection: TextSelection.fromPosition(
              TextPosition(offset: _content.length)));
    }

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
        body: Center(
            child: Container(
                color: Colors.white,
                child: Column(children: [
                  Divider(thickness: 18, color: Color(0xFFD8D5CF)),
                  _radios,
                  Card(
                      margin: EdgeInsets.only(left: 16, right: 16),
                      color: Color(0xFFE8E5DF),
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Give your post a title...',
                            errorText: validationService.postTitle.error),
                        controller: _titleController,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        onChanged: (String value) {
                          validationService.changePostTitle(value);
                        },
                      )),
                  Card(
                      margin: EdgeInsets.only(left: 16, right: 16, top: 22),
                      color: Color(0xFFE8E5DF),
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: 'Type your post here...',
                            errorText: validationService.postContent.error),
                        controller: _postController,
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        maxLines: 14,
                        onChanged: (String value) {
                          validationService.changePostContent(value);
                        },
                      )),
                  Padding(
                    padding: const EdgeInsets.only(top: 22),
                    child: Row(
                      children: [
                        Spacer(flex: 19),
                        SizedBox(
                          width: 135,
                          child: OutlinedButton(
                              onPressed: (!validationService.isValid)
                                  ? null
                                  : () async {
                                      validationService.submitPost();
                                      await Post.sendNewValidatedPost(
                                          validationService, widget.user);
                                      _postController.clear();
                                      _titleController.clear();
                                      validationService.clear();

                                      Navigator.of(context).pop();
                                      setState(() {});
                                    },
                              child: Text(
                                "Post",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                              style: ButtonStyle(backgroundColor:
                                  // MaterialStateProperty.all(
                                  //     Color(0xFF666666))));
                                  MaterialStateProperty.resolveWith(
                                      (Set<MaterialState> states) {
                                if (states.contains(MaterialState.disabled)) {
                                  return const Color(0xFFA9A9C9);
                                }
                                return const Color(0xFF666666);
                              }))),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ]))));
  }
}
