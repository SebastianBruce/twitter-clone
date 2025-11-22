/*

POST PAGE

This page displays:

- individual post
— comments on this post

*/

import 'package:flutter/material.dart';
import 'package:twitter_clone/models/post.dart';

class PostPage extends StatefulWidget {
  final Post post;

  const PostPage({super.key, required this.post});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  // BUILD UI
  @override
  Widget build(BuildContext context) {
    // SCAFFOLD
    return Scaffold(appBar: AppBar(title: Text(widget.post.message)));
  }
}
