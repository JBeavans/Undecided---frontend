import 'package:flutter/material.dart';
import 'package:test_app/Validation/newPostValidation.dart';

enum PostOptions { national, state, local }

class ForumRadioSelection extends StatefulWidget {
  final NewPostValidation validator;

  ForumRadioSelection({Key key, @required this.validator}) : super(key: key);

  @override
  _ForumRadioState createState() => _ForumRadioState();
}

class _ForumRadioState extends State<ForumRadioSelection> {
  PostOptions _selection;

  String optionsToString(PostOptions val) {
    if (val == PostOptions.local) {
      return "local";
    } else if (val == PostOptions.state) {
      return "state";
    } else if (val == PostOptions.national) {
      return "national";
    } else {
      return "null";
    }
  }

  PostOptions stringToOptions(String val) {
    if (val == "national") {
      return PostOptions.national;
    } else if (val == "state") {
      return PostOptions.state;
    } else if (val == "local") {
      return PostOptions.local;
    } else {
      return null;
    }
  }

  Widget build(BuildContext context) {
    _selection = stringToOptions(widget.validator.forumName.value);
    return Column(
      children: [
        prompt(_selection),
        ListTile(
          title: const Text('National Forum'),
          leading: Radio(
            activeColor: Color(0xFF9B6FF9),
            value: PostOptions.national,
            groupValue: _selection,
            onChanged: (PostOptions value) {
              widget.validator.changeForumName(optionsToString(value));
              setState(() {
                _selection = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('State Forum'),
          leading: Radio(
            activeColor: Color(0xFF9B6FF9),
            value: PostOptions.state,
            groupValue: _selection,
            onChanged: (PostOptions value) {
              setState(() {
                _selection = value;
              });
              widget.validator.changeForumName(optionsToString(value));
            },
          ),
        ),
        ListTile(
          title: const Text('Local Forum'),
          leading: Radio(
            activeColor: Color(0xFF9B6FF9),
            value: PostOptions.local,
            groupValue: _selection,
            onChanged: (PostOptions value) {
              widget.validator.changeForumName(optionsToString(value));
              setState(() {
                _selection = value;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget prompt(PostOptions forum) {
    if (forum == null) {
      return ListTile(
        title: Text('Please Select A Forum',
            style: TextStyle(
              color: Colors.white,
            )),
        tileColor: Color(0xFF9B6FF9),
      );
    } else {
      return Divider(
        height: 0,
      );
    }
  }
}
