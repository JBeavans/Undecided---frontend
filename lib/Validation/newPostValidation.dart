import 'package:flutter/material.dart';
import 'package:test_app/Validation/ValidationItem.dart';

class NewPostValidation with ChangeNotifier {
  ValidationItem _forumName = ValidationItem(null, 'Please select a forum');
  ValidationItem _postTitle = ValidationItem(null, null);
  ValidationItem _postContent = ValidationItem(null, null);

  //gettters
  ValidationItem get forumName => _forumName;
  ValidationItem get postTitle => _postTitle;
  ValidationItem get postContent => _postContent;
  bool get isValid => (_forumName.error == null &&
          forumName.value != null &&
          _postTitle.error == null &&
          _postTitle.value != null &&
          _postContent.error == null &&
          _postContent.value != null)
      ? true
      : false;

  //Setters
  void changeForumName(String value) {
    if (value == "null") {
      _forumName = ValidationItem(null, 'Please select a forum');
    } else {
      _forumName = ValidationItem(value, null);
    }
    notifyListeners();
  }

  void changePostTitle(String value) {
    if (value.length < 4) {
      _postTitle = ValidationItem(null, 'Pick a longer title');
    } else if (value.length > 40) {
      _postTitle = ValidationItem(null, 'Pick a shorter title');
    } else {
      _postTitle = ValidationItem(value, null);
    }
    notifyListeners();
  }

  void changePostContent(String value) {
    if (value.length < 4) {
      _postContent = ValidationItem(null, 'Need more content');
    } else if (value.length > 800) {
      _postContent = ValidationItem(null, 'Please shorten your manifesto');
    } else {
      _postContent = ValidationItem(value, null);
    }
    notifyListeners();
  }

  void clear() {
    _forumName = ValidationItem(null, 'Please select a forum');
    _postTitle = ValidationItem(null, null);
    _postContent = ValidationItem(null, null);
    notifyListeners();
  }

  submitPost() {
    print(
        'Post submitted to forum: ${_forumName.value} with title: ${_postTitle.value} and content: ${_postContent.value}');
  }
}
