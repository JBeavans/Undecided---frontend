import 'dart:convert';

import 'package:test_app/Data/user.dart';
import 'package:test_app/Validation/newPostValidation.dart';
import 'package:http/http.dart' as http;

class Post {
  final int postID;
  final String forumID;
  final int threadID;
  final String title;
  final String content;
  final int userID;
  final int replyID;
  final int numReplies;
  final int agree;
  final int disagree;

  Post(
      {this.postID,
      this.forumID,
      this.threadID,
      this.title,
      this.content,
      this.userID,
      this.replyID,
      this.numReplies,
      this.agree,
      this.disagree});

  factory Post.fromJSON(Map<String, dynamic> json) {
    return Post(
        postID: json['postID'],
        forumID: json['forumID'],
        threadID: json['threadID'],
        title: json['title'],
        content: json['content'],
        userID: json['userID'],
        replyID: json['replyID'],
        numReplies: json['numReplies'],
        agree: json['agree'],
        disagree: json['disagree']);
  }

  static Future<List<Post>> fetchPosts(forumID) async {
    final url = 'http://localhost:3000/posts/forum/' + forumID;
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<Post> forum = [];
      int threadCount = 0;
      for (var post in json.decode(response.body)) {
        Post newPost = Post.fromJSON(post);
        if (newPost.threadID != threadCount) {
          forum.add(newPost);
          threadCount = newPost.threadID;
        }
      }
      return forum;
    } else {
      throw Exception('Failed to get posts');
    }
  }

  static void sendPost(forum, thread, title, content, user,
      {replyID = 0}) async {
    final http.Response res = await http.post(
      'http://localhost:3000/posts',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'postID': 0,
        'forumID': forum,
        'threadID': thread,
        'title': title,
        'content': content,
        'userID': user,
        'replyID': replyID,
        'numReplies': 0,
        'agree': 0,
        'disagree': 0
      }),
    );
    if (res.statusCode != 201) {
      throw Exception('Failed to send post');
    }
  }

  static void sendNewValidatedPost(
      NewPostValidation validator, User user) async {
    final int userID = user.userID;
    final String content = validator.postContent.value;
    final String title = validator.postTitle.value;
    final int tc = await getThreadCount();
    final int thread = tc + 1;
    String forum;

    switch (validator.forumName.value) {
      case "national":
        forum = "USA";
        break;
      case "state":
        forum = user.getState();
        break;
      case "local":
        forum = user.getCity();
        break;
      default:
        forum = null;
        throw Exception("null Forum");
    }

    sendPost(forum, thread, title, content, userID);
  }

  static Future<int> getThreadCount() async {
    final res = await http.get('http://localhost:3000/posts/threadcount');

    if (res.statusCode == 200) {
      var resJSON = json.decode(res.body);
      int tc = resJSON['max'];
      return tc;
    } else {
      throw Exception('Failed to get thread count');
    }
  }

  static Future<List<Post>> getReplies(postID) async {
    final res = await http
        .get('http://localhost:3000/posts/replies/' + postID.toString());

    if (res.statusCode == 200) {
      List<Post> replies = [];
      for (var reply in json.decode(res.body)) {
        Post newReply = Post.fromJSON(reply);
        replies.add(newReply);
      }
      return replies;
    } else {
      throw Exception('Failed to get replies');
    }
  }

  static Future<bool> updateReplies(postID) async {
    final url =
        'http://localhost:3000/posts/updateReplies/' + postID.toString();
    final res = await http.put(url);

    if (res.statusCode != 200) {
      print(res.body);
      throw Exception('Failed to update thread');
    }
    return true;
  }

  static Future<int> getNumReplies(postID) async {
    final url = 'http://localhost:3000/posts/numReplies/' + postID.toString();
    final res = await http.get(url);

    if (res.statusCode != 200) {
      print(res.body);
      throw Exception('Failed to retrieve number of replies');
    }
    num replies = json.decode(res.body);
    return replies;
  }
}
