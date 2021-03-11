import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:test_app/Custom_Widgets/forumScrollView.dart';
import 'package:test_app/Data/post.dart';
import 'package:test_app/Data/user.dart';
import 'package:test_app/Screens/NewPost/newPost.dart';
import 'package:test_app/Screens/Settings/settings.dart';

class Home extends StatefulWidget {
  final int id;

  Home({Key key, @required this.id}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<User> currentUser;
  Future<List<Post>> nationalForum;
  Future<List<Post>> stateForum;
  Future<List<Post>> localForum;

  final _postController = TextEditingController();

  @override
  void initState() {
    super.initState();
    currentUser = User.fetchUser(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Builder(
        builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              // shadowColor: Color(0xFF000000),
              toolbarHeight: 112,
              elevation: 1,
              automaticallyImplyLeading: false,
              title: Text(
                "Rally",
                style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Rufina'),
              ),
              actions: [
                IconButton(
                    icon: Icon(Icons.add),
                    color: Color(0xFF808080),
                    padding: EdgeInsets.only(right: 12, top: 40),
                    onPressed: () async {
                      await currentUser.then((User user) => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  NewPost(user: user))));
                      setState(() {});
                    }),
              ],
              leading: IconButton(
                  icon: Icon(Icons.settings),
                  color: Color(0xFF808080),
                  padding: EdgeInsets.only(left: 12, top: 40),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Settings()));
                  }),
            ),
            body: FutureBuilder<User>(
              future: currentUser,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  nationalForum = Post.fetchPosts('USA');
                  stateForum = Post.fetchPosts(snapshot.data.state);
                  String stateName = snapshot.data.state;
                  localForum = Post.fetchPosts(snapshot.data.city);
                  String localName = snapshot.data.city;
                  return TabBarView(children: [
                    Center(
                      child: FutureBuilder<List<Post>>(
                        future: nationalForum,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<Post> posts = snapshot.data ?? [];
                            return ForumScrollView(
                              heading: "National Forum",
                              posts: posts,
                              currentUserID: widget.id,
                            );
                          } else if (snapshot.hasError) {
                            Text error = Text("${snapshot.error}");
                            return error;
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                    ),
                    Center(
                        child: FutureBuilder<List<Post>>(
                      future: stateForum,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Post> posts = snapshot.data ?? [];
                          return ForumScrollView(
                            heading: "$stateName Forum",
                            posts: posts,
                            currentUserID: widget.id,
                          );
                        } else if (snapshot.hasError) {
                          Text error = Text("${snapshot.error}");
                          return error;
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    )),
                    Center(
                        child: FutureBuilder<List<Post>>(
                      future: localForum,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Post> posts = snapshot.data ?? [];

                          return ForumScrollView(
                            heading: "$localName Forum",
                            posts: posts,
                            currentUserID: widget.id,
                          );
                        } else if (snapshot.hasError) {
                          Text error = Text("${snapshot.error}");
                          return error;
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ))
                  ]);
                } else if (snapshot.hasError) {
                  Text error = Text("${snapshot.error}");
                  return TabBarView(children: [error, error, error]);
                }

                return CircularProgressIndicator();
              },
            ),
            bottomNavigationBar: BottomAppBar(
              color: Colors.white,
              child: TabBar(
                indicatorColor: Colors.green,
                tabs: [
                  Tab(icon: Text("Nation")),
                  Tab(icon: Text("State")),
                  Tab(icon: Text("Local")),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _postSheet(context, {thread, post}) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (BuildContext bc) {
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
                              bool update = false;
                              String forum;
                              TabController tc =
                                  DefaultTabController.of(context);
                              int tab = tc.index;
                              switch (tab) {
                                case 0:
                                  forum = 'USA';
                                  debugPrint("case 0");
                                  break;
                                case 1:
                                  await currentUser.then((userData) {
                                    forum = userData.getState();
                                    debugPrint(forum);
                                  });
                                  debugPrint("case 1");
                                  break;
                                case 2:
                                  await currentUser.then((userData) {
                                    forum = userData.getCity();
                                    debugPrint(forum);
                                  });
                                  debugPrint("case 2");
                                  break;
                                default:
                              }
                              if (thread == null) {
                                thread = await Post.getThreadCount();
                                thread = thread + 1;
                                debugPrint('thread: $thread');
                              } else {
                                //update OG post to indicate it is a thread
                                update = true;
                              }

                              int user = super.widget.id;
                              String content = _postController.text;
                              int replyID = 0;
                              if (update) {
                                replyID = post;
                              }
                              debugPrint(
                                  "tab: $tab forum: $forum thread: $thread content: $content user: $user");
                              Post.sendPost(
                                  forum, thread, "title", content, user,
                                  replyID: replyID);
                              debugPrint('here');
                              if (update) {
                                debugPrint("updating replies");
                                update =
                                    await updateReplies(post); //pass in post ID
                              }

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
        });
  }

  void _pushThread(id) {
    Future<List<Post>> threadList =
        fetchThread(id); //UPDATE TO ONLY get replies
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Thread'),
          ),
          body: Center(
            child: FutureBuilder<List<Post>>(
              future: threadList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Post> posts = snapshot.data ?? [];
                  return ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        Post post = posts[index];

                        //fix reply button in here somewhere

                        return new ListTile(
                            title: Text(
                              post.title,
                              style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Inter'),
                            ),
                            subtitle: FlatButton(
                                onPressed: () {}, child: Text("Reply")));
                      });
                } else if (snapshot.hasError) {
                  Text error = Text("${snapshot.error}");
                  return error;
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),
        );
      }),
    );
  }
}

Future<List<Post>> fetchThread(threadID) async {
  final url = 'http://localhost:3000/posts/thread/' + threadID.toString();
  final response = await http.get(url);

  if (response.statusCode == 200) {
    List<Post> thread = [];

    for (var post in json.decode(response.body)) {
      Post newPost = Post.fromJSON(post);
      thread.add(newPost);
    }
    return thread;
  } else {
    debugPrint(response.body);
    throw Exception('Failed to get posts');
  }
}

Future<bool> updateReplies(postID) async {
  final url = 'http://localhost:3000/posts/updateReplies/' + postID.toString();
  final res = await http.put(url);

  if (res.statusCode != 200) {
    debugPrint(res.body);
    throw Exception('Failed to update thread');
  }
  return true;
}
