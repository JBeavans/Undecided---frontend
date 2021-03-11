import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class NewPostBloc {
  final _forumName = BehaviorSubject<String>();
  final _postTitle = BehaviorSubject<String>();
  final _postContent = BehaviorSubject<String>();

  //Get
  Stream<String> get forumName =>
      _forumName.stream.transform(validateForumName);
  Stream<String> get postTitle =>
      _postTitle.stream.transform(validatePostTitle);
  Stream<String> get postContent =>
      _postContent.stream.transform(validatePostContent);

  // Stream<bool> get validPost =>
  //     Rx.(forumName, postTitle, postContent,
  //         (forumName, postTitle, postContent) {
  //       //debugPrint(forumName);
  //       //debugPrint(postTitle);
  //       debugPrint(postContent);
  //       //try {
  //       this.postContent;
  //       //} catch (error) {
  //       //  return false;
  //       //}
  //       return true;
  //     });

  // //Set
  // Function(String) get changeForumName => _forumName.sink.add;
  // Function(String) get changePostTitle => _postTitle.sink.add;
  // Function(String) get changePostContent => _postContent.sink.add;

  // dispose() {
  //   _forumName.close();
  //   _postTitle.close();
  //   _postContent.close();
  //   // validPrice.close();
  // }

  //Transformers
  final validateForumName = StreamTransformer<String, String>.fromHandlers(
      handleData: (forumName, sink) {
    if (forumName == 'null') {
      sink.addError('Please select a forum');
    } else {
      sink.add(forumName);
      //debugPrint(forumName);
    }
  });

  final validatePostTitle = StreamTransformer<String, String>.fromHandlers(
      handleData: (postTitle, sink) {
    if (postTitle.length < 4) {
      sink.addError("Pick a better title");
    } else if (postTitle.length > 40) {
      sink.addError("Pick a shorter title");
    } else {
      sink.add(postTitle);
    }
  });

  final validatePostContent = StreamTransformer<String, String>.fromHandlers(
      handleData: (postContent, sink) {
    if (postContent.length < 4) {
      sink.addError("The bar is higher than that");
    } else if (postContent.length > 800) {
      sink.addError(
          "Whoa there bud... you think someone's gonna read all this?");
    } else {
      sink.add(postContent);
    }
  });

  submitPost() {
    print(
        'Post submitted to forum: ${_forumName.value} with title: ${_postTitle.value} and content: ${_postContent.value}');
  }
}
